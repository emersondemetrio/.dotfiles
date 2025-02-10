#!/opt/homebrew/bin/node

const cleanUpString = (s) => {
  return s
    .toLowerCase() // A -> a
    .replace(/[\[\]]/g, "") // [ge-123] -> ge-123
    .replace(/[^a-z0-9\s-]/g, "") // non alphanumeric -> ""
    .replace(/\s+/g, "-") // space -> -
    .trim(); // trim
};

const removeMultipleDashes = (s) => s.replace(/-+/g, "-"); // All -- -> -

const dashAll = (...all) => {
  const cleanedArgs = all.map(cleanUpString); // Clean and remove multiple dashes
  return removeMultipleDashes(cleanedArgs.join("-"));
};

const args = process.argv.slice(2);

console.log(dashAll(...args));
