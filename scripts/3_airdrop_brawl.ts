import { createPublicClient, createWalletClient, getContract, http, isHex, zeroAddress } from "viem";
import { skaleBlockBrawlers, skaleNebula, skaleNebulaTestnet } from "viem/chains";
import BrawlTokenNebulaABI from "../abis/brawlTokenNebula.abi.json";
import TokenSnapshot from "../snapshots/brawl-snapshot-7461153.json";
import { privateKeyToAccount } from "viem/accounts";
import dotenv from "dotenv";
dotenv.config();

type Token = {
	address: `0x${string}`;
	balance: string;
	stale?: boolean;
}

const isTestnet = true;

const chain = isTestnet ? skaleNebulaTestnet : skaleNebula;
const contractAddress = isTestnet ? "0xbF5841cAb6F82710c445767087e9313Fd9A0dc75" : "0x"

async function main() {
	let tokens: Token[] = [];

	const PRIVATE_KEY = process.env.PRIVATE_KEY;
	if (!PRIVATE_KEY) {
		throw new Error("Missign Private Key");
	}

	const walletClient = createWalletClient({
		chain: chain,
		transport: http(),
		account: privateKeyToAccount(PRIVATE_KEY as `0x${string}`)

	});

	const contract = getContract({
		abi: BrawlTokenNebulaABI,
		address: contractAddress,
		client: {
			wallet: walletClient
		}
	});

	const dropList = TokenSnapshot.data.balances as Token[];

	// TODO -> generate batches of 1000 addresses & amounts & send batch transactions
	// After sending, validate the balances of the entire list through a large multicall read
	for (let i = 0; i < dropList.length; i+=1000) {
		// const addresses = batchList.
	}

}

main()
	.catch((err) => {
		console.error(err);
		process.exitCode = 1;
	})