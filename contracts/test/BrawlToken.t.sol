// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BrawlToken} from "../src/BrawlToken.sol";

contract BrawlTokenTest is Test {
    BrawlToken public brawlToken;

    function setUp() public {
        brawlToken = new BrawlToken("Brawl Token", "BRAWL");
    }

    function test_BalanceOf() public view {
        assertEq(brawlToken.balanceOf(address(0)), 0);
        assertEq(brawlToken.balanceOf(address(0x0)), 0);
        assertEq(brawlToken.balanceOf(address(0x1)), 0);
    }

    function testFuzz_Mint(uint256 x) public {
        address rng = vm.randomAddress();
        brawlToken.mint(rng, x);
        assertEq(brawlToken.balanceOf(rng), x);
    }
}
