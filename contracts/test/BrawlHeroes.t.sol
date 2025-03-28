// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {BrawlHeroes} from "../src/BrawlHeroes.sol";

contract BrawlHeroesTest is Test {
    BrawlHeroes private brawlHeroes;

    function setUp() public {
        brawlHeroes = new BrawlHeroes("Brawl Heroes", "HERO", "ipfs://QmVNiWuUSGNabL9RwcvsghobnhWHXqUuKdzKdGBgpJfGm8/", "gif");
    }

    function test_RevertsWhen_BalanceOf() public {
        vm.expectRevert();
        assertEq(brawlHeroes.balanceOf(address(0)), 0);
    }

    function testFuzz_Mint(uint256 x) public {
        address rng = vm.randomAddress();
        BrawlHeroes.MintableHero[] memory heroes = new BrawlHeroes.MintableHero[](1);
        heroes[0] = BrawlHeroes.MintableHero(rng, x, x >> 5);
        brawlHeroes.mintBatch(heroes);
        assertEq(brawlHeroes.balanceOf(rng), 1);
        assertEq(brawlHeroes.ownerOf(x), rng);
    }

    function test_Uris() public {
        address rng = vm.randomAddress();
        BrawlHeroes.MintableHero[] memory heroes = new BrawlHeroes.MintableHero[](1);
        heroes[0] = BrawlHeroes.MintableHero(rng, 0, 22300785707104958605423891346518438181863497);
        brawlHeroes.mintBatch(heroes);
        // console.log();
        // brawlHeroes.generateHeroToken(22300785707104958605423891346518438181863497);
        brawlHeroes.tokenURI(0);
    }
}
