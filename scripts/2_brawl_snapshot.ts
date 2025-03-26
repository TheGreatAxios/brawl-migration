import { createPublicClient, getContract, http } from "viem";
import { skaleBlockBrawlers } from "viem/chains";
import abi from "../abis/blockBrawlersERC721.abi.json";
import { writeFile } from "fs/promises";
import * as path from "path";

type Balance = {
	user: string;
	balance: string;
}

const BASE_URL = "https://frayed-decent-antares.explorer.mainnet.skalenodes.com/api?module=account&action=listaccounts";

async function loadBalances(page: number, offset: number) {
	const url = `${BASE_URL}&page=${page}&offset=${offset}`;

	const response = await fetch(url);
	if (!response.ok) {
		throw new Error(`HTTP error! Status: ${response.status}`);
	}

	return await response.json();
}

async function main() {
	console.time("Snapshot Completed In");

	const client = createPublicClient({
		chain: skaleBlockBrawlers,
		transport: http()
	});

	const block = await client.getBlock();


	let balances: Balance[] = [];
	let page = 1;
	const offset = 250;
	let hasMore = true;

	
		
	

	while (true) {
		// Construct the URL with page and offset parameters
		let prevAccountLength = balances.length;
		const data = await loadBalances(page, offset);

		balances.push(...data.result.map(async(json: any) => {

			const isContract = await client.getCode({
				address: json.address
			});

			return {
				"user": json.address,
				"balance": json.balance,
				"isContract": isContract !== undefined
			}
		}));

		// Assuming the API returns an object with a "result" field containing the account list
		// const accounts: any[] = data.result || [];

		// Extract addresses (adjust this based on the actual structure of the response)
		// const addresses = accounts.map((account: any) => account.address);
		// allAccounts = allAccounts.concat(addresses);

		// Check if this is the last page
		if (balances.length === prevAccountLength) { // Compare this cycle to new legnth
		  break;
		} else {
		  page++; // Move to the next page
		}

		console.log(`Fetched page ${page - 1}, found ${balances.length} accounts`);
	}

	console.log("Balances: ", balances.length);


	// const res = await fetch(`https://frayed-decent-antares.explorer.mainnet.skalenodes.com/api?module=account&action=listaccounts&page=${0}&offset=100`)

	await writeFile(path.resolve(__dirname, `../snapshots/brawl-snapshot-${block.number}.json`), JSON.stringify({
		block: {
			number: block.number.toString(),
			hash: block.hash,
			timestamp: block.timestamp.toString()
		},
		data: {
			skaleChainName: "frayed-decent-antares",
			chainName: "BRAWL Chain",
			balances
		},
		timestamp: {
			str: new Date().toDateString(),
			num: Date.now()
		}
	}, null, 4));


	console.timeEnd("Snapshot Completed In");
	console.log("Snapshot written to: ", path.resolve(__dirname, `../snapshots/brawl-snapshot-${block.number}.json`));


}

main()
	.catch((err) => {
		console.error(err);
		process.exitCode = 1;
	})