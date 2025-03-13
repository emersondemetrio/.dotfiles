#!/opt/homebrew/bin/node

const cleanUpString = (s, exceptions = []) => {
  // Create a regex pattern that excludes the exceptions
  const exceptionsPattern = exceptions.length
    ? `[^a-z0-9\\s-${exceptions.join('')}]`
    : '[^a-z0-9\\s-]';

  return s
    .toLowerCase() // A -> a
    .replace(/[\[\]]/g, "") // [ge-123] -> ge-123
    .replace(new RegExp(exceptionsPattern, 'g'), "") // non alphanumeric (except exceptions) -> ""
    .replace(/\s+/g, "-") // space -> -
    .trim(); // trim
};

const removeMultipleDashes = (s) => s.replace(/-+/g, "-"); // All -- -> -

const dashAll = (exceptions = [], ...all) => {
  const cleanedArgs = all.map(str => cleanUpString(str, exceptions)); // Clean and remove multiple dashes
  return removeMultipleDashes(cleanedArgs.join("-"));
};

const args = process.argv.slice(2);
const exceptions = args[0]?.startsWith('--exceptions=')
  ? args.shift().replace('--exceptions=', '').split('')
  : [];

console.log(dashAll(exceptions, ...args));
