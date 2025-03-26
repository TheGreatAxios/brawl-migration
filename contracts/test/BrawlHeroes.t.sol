// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BrawlHeroes} from "../src/BrawlHeroes.sol";

contract BrawlHeroesTest is Test {
    BrawlHeroes public brawlHeroes;

    function setUp() public {
        brawlHeroes = new BrawlHeroes("Brawl Heroes", "HERO");
    }

    function test_RevertsWhen_BalanceOf() public {
        vm.expectRevert();
        assertEq(brawlHeroes.balanceOf(address(0)), 0);
    }

    function testFuzz_Mint(uint256 x) public {
        address rng = vm.randomAddress();
        brawlHeroes.safeMint(rng, x);
        assertEq(brawlHeroes.balanceOf(rng), 1);
        assertEq(brawlHeroes.ownerOf(x), rng);
    }
}
