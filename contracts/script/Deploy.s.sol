// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {BrawlToken} from "../src/BrawlToken.sol";

contract CounterScript is Script {
    BrawlToken public brawlToken;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        brawlToken = new BrawlToken("Brawl Token", "BRAWL");

        vm.stopBroadcast();
    }
}
