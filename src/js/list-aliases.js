#!/usr/bin/env node
// try to use bun?
const { execSync } = require('child_process');

const colors = {
  yellow: (text) => `\x1b[33m${text}\x1b[0m`,
  green: (text) => `\x1b[32m${text}\x1b[0m`,
  red: (text) => `\x1b[31m${text}\x1b[0m`,
};

const listAliases = (filter) => {
  try {
    // Use the shell script to get aliases
    // this won't work.
    const output = execSync('~/scripts/src/sh/get-aliases.sh', {
      encoding: 'utf8'
    });

    const aliases = output
      .split('\n')
      .filter(Boolean)
      .map(line => {
        const [alias, ...command] = line.split('=');
        return {
          alias: alias.replace('alias ', '').trim(),
          command: command.join('=').replace(/^['"]|['"]$/g, '').trim()
        };
      })
      .sort((a, b) => a.alias.localeCompare(b.alias));

    const filteredAliases = filter
      ? aliases.filter(({ alias, command }) =>
          alias.toLowerCase().includes(filter) ||
          command.toLowerCase().includes(filter))
      : aliases;

    console.log('\nAvailable Aliases:\n');
    filteredAliases.forEach(({ alias, command }) => {
      console.log(`${colors.yellow(alias.padEnd(20))} → ${command}`);
    });

    console.log(`\nTotal aliases: ${colors.green(filteredAliases.length)}\n`);
  } catch (error) {
    console.error(colors.red('Error listing aliases:'), error.message);
  }
};

const searchTerm = process.argv[2]?.toLowerCase();
listAliases(searchTerm);
