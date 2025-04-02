import { createPublicClient, createWalletClient, getContract, http, isHex, nonceManager, zeroAddress } from "viem";
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
const contractAddress = isTestnet ? "0xE8b11401351aD4501305fa8E04E259B818af752F" : "0x"

async function main() {

	const PRIVATE_KEY = process.env.PRIVATE_KEY;
	if (!PRIVATE_KEY) {
		throw new Error("Missign Private Key");
	}

	const walletClient = createWalletClient({
		chain: chain,
		transport: http(),
		account: privateKeyToAccount(PRIVATE_KEY as `0x${string}`, {
			nonceManager
		})
	});

	const dropList: Token[] = (TokenSnapshot.data.balances as Token[]).filter((v) => {
		if (v.balance !== "" && BigInt(v.balance) > BigInt(0)) {
			return v;
		}
	});

	const addresses = dropList.map((v) => v.address);
	const balances = dropList.map((v) => v.balance);

	// Should work for up to 13,000
	const res = await walletClient.writeContract({
		abi: BrawlTokenNebulaABI,
		address: contractAddress,
		functionName: "batchMint",
		args: [
			addresses,
			balances.map((v) => BigInt(v))
		],
		gas: BigInt(268_000_000)
	});

	console.log("Batch Mint Transaction Hash: ", res);

}

main()
	.catch((err) => {
		console.error(err);
		process.exitCode = 1;
	})