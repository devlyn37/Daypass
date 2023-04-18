// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/Daypass.sol";

contract DaypassTest is Test {
    using stdStorage for StdStorage;

    Daypass private nft;
    address private normalAddress;
    address private contractAddress;
    address private deployerAddress;

    function setUp() public {
        deployerAddress = address(1);
        vm.prank(deployerAddress);
        nft = new Daypass("Daypass", "DPASS", true);
        contractAddress = address(nft);
        normalAddress = address(2);

        vm.deal(deployerAddress, 100 ether);
        vm.deal(normalAddress, 100 ether);
    }

    function testDaypassMintTo(uint256 quantity) public {
        vm.startPrank(deployerAddress);
        assertEq(nft.balanceOf(normalAddress), 0);

        vm.assume(quantity < 100 && quantity > 0);
        nft.mintTo(quantity, normalAddress);

        assertEq(nft.balanceOf(normalAddress), quantity);
        vm.stopPrank();
    }

    function testDaypassTime() public {
        vm.startPrank(deployerAddress);
        assertEq(nft.balanceOf(normalAddress), 0);
        assertEq(nft.hasValidPass(normalAddress), false);
        nft.mintTo(1, normalAddress);

        assertEq(nft.balanceOf(normalAddress), 1);
        assertEq(nft.hasValidPass(normalAddress), true);

        // Go way into the future, these passes shouldn't be valid anymore
        vm.warp(1000000000000000);
        assertEq(nft.hasValidPass(normalAddress), false);

        vm.stopPrank();
    }
}
