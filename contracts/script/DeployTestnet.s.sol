// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BrawlToken} from "../src/BrawlToken.sol";

contract DeployTestnetScript is Script {
    BrawlToken public brawlToken;

    function setUp() public {}

    function run() public {
        
        uint256 deployer = vm.envUint("PRIVATE_KEY");
        vm.createSelectFork("nebula_testnet");
        vm.startBroadcast(deployer);

        brawlToken = new BrawlToken("Brawl Token", "BRAWL");

        vm.stopBroadcast();
    }
}
