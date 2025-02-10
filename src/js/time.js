const args = process.argv.slice(2);
const here = Intl.DateTimeFormat().resolvedOptions().timeZone;

const interactive = args.includes('--interactive') || args.includes('-i');
const asJson = args.includes('--json') || args.includes('-j');

const locations = [
	{
		timeZone: 'America/Los_Angeles',
		location: 'San Francisco',
	},
	{
		timeZone: 'America/Sao_Paulo',
		location: 'Florianópolis',
	},
	{
		timeZone: 'Europe/Berlin',
		location: 'Munich',
	},
	{
		timeZone: here,
		location: 'Local',
	},
];

const getTzDateString = (timeZone) => {
	return new Date().toLocaleString('en-US', {
		timeZone,
	});
};

const formatDate = (date) => {
	return date.toLocaleString('en-US', {
		weekday: 'short',
		month: 'short',
		day: 'numeric',
		hour: 'numeric',
		minute: 'numeric',
		second: 'numeric',
		hour12: false,
	});
};

const isCurrent = (timeZone) => {
	return timeZone === here;
};

const generateResponse = () =>
	locations.map(({ timeZone, location }) => {
		const now = new Date();

		const currentDate = new Date(getTzDateString(timeZone));

		const diff = Math.floor((now - currentDate) / (1000 * 60 * 60));

		return {
			timeZone,
			current: isCurrent(timeZone) ? '✅' : '',
			location,
			date: formatDate(currentDate),
			diff
		};
	});

const showInteractive = () => {
	setInterval(() => {
		console.clear();
		console.table(generateResponse());
	}, 1000);
};

if (!interactive || asJson) {
	console.clear();
	if (asJson) {
		console.log(JSON.stringify(generateResponse(), null, 2));
		return;
	}

	console.table(generateResponse());
}

if (interactive) {
	showInteractive();
}
