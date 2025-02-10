#!/opt/homebrew/bin/node

/**
 * Calculate the difference in days, months, and weeks between two dates.
 * @param {Date} startDate - The start date.
 * @param {Date} endDate - The end date.
 * @param {boolean} includeDates - Include the start and end dates in the calculation.
 * @returns {Object} An object with properties for days, months, and weeks.
 */
const dateDifference = (startDate, endDate, includeDates = false) => {
	const timeDifference = endDate - startDate;

	let days = Math.floor(timeDifference / (1000 * 60 * 60 * 24));

	if (includeDates) {
		days += 1; // If including dates, add 1 to the days difference
	}

	// Calculate months and weeks
	const months = (days / 30).toFixed(2);
	const weeks = (days / 7).toFixed(2);
	const years = (days / 365).toFixed(2);

	const summary = `[ ${startDate.toDateString()} -> ${endDate.toDateString()} ] (${
		includeDates ? 'including' : 'excluding'
	})`;

	return {
		summary,
		days,
		months,
		weeks,
		years,
	};
};

/**
 // Example usage:
 const startDate = new Date('2023-01-01');
 const endDate = new Date('2023-02-15');
 const includeDates = true;
 const difference = dateDifference(startDate, endDate, includeDates);

 console.log(difference);
 */

if (!process.argv[2] || !process.argv[3]) {
	console.log(`\nError: Missing arguments.\n`);
	console.error(
		'Usage: interval.js <YYYY-MM-DD> <YYYY-MM-DD> [includeDates]\n'
	);
	console.log(`Example: interval 2023-01-01 2023-02-15 true\n`);
	process.exit(-1);
}

const startDate = new Date(process.argv[2]);
const endDate = new Date(process.argv[3]);
const includeDates = process.argv[4] === 'true';
const difference = dateDifference(startDate, endDate, includeDates);

console.log(JSON.stringify(difference, null, 4));
console.log(`\n`);

// https://www.timeanddate.com/date/durationresult.html?d1=1&m1=12&y1=2023&d2=25&m2=3&y2=2024&ti=on
