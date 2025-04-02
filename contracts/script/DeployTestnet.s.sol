// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BrawlToken} from "../src/BrawlToken.sol";
import {BrawlHeroes} from "../src/BrawlHeroes.sol";

contract DeployTestnetScript is Script {
    BrawlToken public brawlToken;
    BrawlHeroes public brawlHeroes;

    function setUp() public {}

    function run() public {
        
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.createSelectFork("nebula_testnet");
        vm.startBroadcast(deployer);

        brawlToken = new BrawlToken("Brawl Token", "BRAWL");
        brawlHeroes = new BrawlHeroes("Brawl Heroes", "HERO", "ipfs://QmVNiWuUSGNabL9RwcvsghobnhWHXqUuKdzKdGBgpJfGm8/", "gif");

        vm.stopBroadcast();
    }
}
