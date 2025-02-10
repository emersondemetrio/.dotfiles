#!/opt/homebrew/bin/node
const fs = require('fs');
const [link, path] = process.argv.slice(2);

const style = `
font-size: 80px;
padding: 10px;
margin: 5px"
`;

const template = `<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <title>File to Link</title>
    </head>
    <body>
        <a style="${style}" href="${link}">Open Link</a>
    </body>
</html>
`;

((contents, filePath) => {
	console.log('Creating file:', filePath);
	fs.writeFileSync(filePath, contents, 'utf8');
	console.log('Done.');
})(template, path || './link.html');
