#!/usr/bin/env -S deno run --allow-net --allow-read --allow-env

/**
 * A CLI tool for interacting with language models (OpenAI and Ollama).
 * Supports various tasks like translation, grammar checking, and code syntax examples.
 * Features an interactive chat mode with history.
 */

console.error("Work in progress. Try later")
process.exit(1)

import { config } from "https://deno.land/x/dotenv/mod.ts";
import { OpenAI } from "https://deno.land/x/openai@v4.28.0/mod.ts";
import { readFileStr } from "https://deno.land/std@0.59.0/fs/mod.ts";

// Type definitions
type TaskType = "translate" | "grammar" | "syntax" | "adsyntax" | "explain" | "summarize" | "chat" | "tone";
type Message = { role: "user" | "assistant"; content: string };
type Settings = {
  prompt: string;
  context?: string;
  file?: string;
  outputFile?: string;
  task: TaskType;
  outputLang: string;
  debug: boolean;
  keepAlive: boolean;
  maxHistory: number;
  tone: string;
  conversationHistory: Message[];
};

const PromptTemplates = {
  translate: (lang: string): string =>
    `Only give me the translation to ${lang} of the following text: `,

  tone: (toneStyle: string): string =>
    `Rewrite the following text in a ${toneStyle} tone while preserving its meaning and applying grammar fixes: `,

  GRAMMAR: "Unless there's nothing to fix, only reply with the applied english grammar checks and corrections to the following text: ",
  SYNTAX: "Only reply with the most simple example syntax of the following prompt: ",
  AD_SYNTAX: "Only reply with the example syntax of the following prompt: ",
  EXPLAIN: "Only reply with the explanation of the following subject: ",
  SUMMARIZE: "Only reply with the summary of the file: "
};

abstract class LLMClient {
  abstract generateResponse(prompt: string, context?: string, conversationHistory?: Message[]): Promise<string>;
}

class OpenAIClient extends LLMClient {
  private client: OpenAI;

  constructor() {
    super();
    this.client = new OpenAI({
      apiKey: Deno.env.get("OPENAI_API_KEY")
    });
  }

  async generateResponse(prompt: string, context?: string, conversationHistory?: Message[]): Promise<string> {
    const messages = conversationHistory ? [...conversationHistory] : [];

    if (context) {
      messages.push({ role: "user", content: context });
    }
    messages.push({ role: "user", content: prompt });

    const result = await this.client.chat.completions.create({
      model: "gpt-4",
      messages
    });

    return result.choices[0].message.content || "";
  }
}

const checkInternetConnection = async (): Promise<void> => {
  try {
    const conn = await Deno.connect({ hostname: "8.8.8.8", port: 53 });
    conn.close();
  } catch {
    console.error("No internet connection.");
    Deno.exit(1);
  }
};

const processOutput = (output: string, outputFile: string | undefined, settings: Settings): void => {
  if (outputFile) {
    Deno.writeTextFile(outputFile, output);
    console.log(`Output written to file ${outputFile}`);
  } else {
    const separator = "- ".repeat(40);
    console.log(`\n${separator}\n\n${output}\n\n${separator}\n`);

    if (settings.keepAlive) {
      const remainingMessages = settings.maxHistory - settings.conversationHistory.length / 2;
      if (settings.debug) {
        console.log(`Remaining messages in conversation: ${remainingMessages}`);
      }
    }
  }
};

const getPromptForTask = (settings: Settings): string => {
  const taskPrompts: Record<TaskType, string> = {
    translate: PromptTemplates.translate(settings.outputLang),
    grammar: PromptTemplates.GRAMMAR,
    syntax: PromptTemplates.SYNTAX,
    adsyntax: PromptTemplates.AD_SYNTAX,
    explain: PromptTemplates.EXPLAIN,
    summarize: settings.file ? PromptTemplates.SUMMARIZE : "",
    tone: PromptTemplates.tone(settings.tone),
    chat: ""
  };

  return `${taskPrompts[settings.task]}${settings.prompt}`;
};

const parseArguments = (): Settings => {
  const args = Deno.args;
  const options: Record<string, string> = {};
  let fileOrPrompt = "";
  let currentArg = "";

  // Parse arguments
  for (let i = 0; i < args.length; i++) {
    const arg = args[i];

    if (arg.startsWith("-")) {
      currentArg = arg.replace(/^-+/, "");
      if (currentArg.includes("=")) {
        const [key, value] = currentArg.split("=");
        options[key] = value;
        currentArg = "";
      }
    } else if (currentArg) {
      options[currentArg] = arg;
      currentArg = "";
    } else if (!fileOrPrompt) {
      fileOrPrompt = arg;
    }
  }

  // Set defaults and process options
  const task = (options.t || options.task || "chat") as TaskType;
  const outputLang = options.ol || options["output-lang"] || "en";
  const debug = options.d || options.debug === "true";
  const keepAlive = options.keep === "true";
  const maxHistory = parseInt(options["max-history"] || "100");
  const tone = options.tone || "casual";

  // Handle file argument based on task
  let filePath: string | undefined;
  let prompt = fileOrPrompt || "";

  if (task === "summarize") {
    filePath = fileOrPrompt || options.f || options.file;
  } else {
    filePath = options.f || options.file;
  }

  return {
    prompt,
    context: options.c || options.context,
    file: filePath,
    outputFile: options.o || options.output,
    task,
    outputLang,
    debug,
    keepAlive,
    maxHistory,
    tone,
    conversationHistory: []
  };
};

const updateConversationHistory = (settings: Settings, prompt: string, response: string): void => {
  if (!settings.keepAlive) return;

  settings.conversationHistory.push({ role: "user", content: prompt });
  settings.conversationHistory.push({ role: "assistant", content: response });

  while (settings.conversationHistory.length > settings.maxHistory * 2) {
    settings.conversationHistory.shift();
  }
};

const interactiveChat = async (settings: Settings, client: LLMClient): Promise<void> => {
  console.log("\nInteractive chat mode enabled. Type 'exit' or 'quit' to end the session.");
  if (settings.debug) {
    console.log(`Message history limit: ${settings.maxHistory}`);
  }
  let firstCycle = true;

  while (true) {
    try {
      let userInput: string;
      if (firstCycle && settings.prompt) {
        userInput = settings.prompt;
        firstCycle = false;
      } else {
        const buffer = new Uint8Array(1024);
        const n = await Deno.stdin.read(buffer);
        if (!n) break;
        userInput = new TextDecoder().decode(buffer.subarray(0, n)).trim();
      }

      if (userInput.toLowerCase() === "exit" || userInput.toLowerCase() === "quit") {
        break;
      }

      if (!userInput.trim()) {
        continue;
      }

      settings.prompt = userInput;
      const prompt = getPromptForTask(settings);

      const result = await client.generateResponse(prompt, settings.context, settings.conversationHistory);
      updateConversationHistory(settings, prompt, result);
      processOutput(result, settings.outputFile, settings);

    } catch (error) {
      if (error instanceof Error) {
        console.error(error.message);
      }
      break;
    }
  }
};

const main = async (): Promise<void> => {
  // Load environment variables and check prerequisites
  await config({ export: true });
  if (!Deno.env.get("OPENAI_API_KEY")) {
    console.error("OPENAI_API_KEY is not set");
    Deno.exit(1);
  }
  await checkInternetConnection();

  // Parse arguments and prepare configuration
  const settings = parseArguments();

  // Get file content if specified
  if (settings.file) {
    settings.context = await readFileStr(settings.file);
  }

  // Select appropriate client
  const client = settings.library === "ollama" ? new OllamaClient() : new OpenAIClient();

  // Log debug information
  if (settings.debug) {
    console.log(
      `Task: ${settings.task} | Context: ${settings.context} | Prompt: ${settings.prompt} | ` +
      `File: ${settings.file} | Keep Alive: ${settings.keepAlive} | Tone: ${settings.tone}`
    );
  }

  if (settings.keepAlive) {
    await interactiveChat(settings, client);
  } else {
    const prompt = getPromptForTask(settings);
    const result = await client.generateResponse(prompt, settings.context);
    processOutput(result, settings.outputFile, settings);
  }
};

if (import.meta.main) {
  main().catch((error) => {
    console.error(error);
    Deno.exit(1);
  });
}
