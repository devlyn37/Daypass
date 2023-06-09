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
    uint48 private oneDay;

    function setUp() public {
        deployerAddress = address(1);
        normalAddress = address(2);
        oneDay = 86400;

        vm.deal(deployerAddress, 100 ether);
        vm.deal(normalAddress, 100 ether);
    }

    function testDaypassMintTo(uint256 quantity) public {
        vm.startPrank(deployerAddress);
        nft = new Daypass("Daypass", "DPASS", true, oneDay);

        assertEq(nft.balanceOf(normalAddress), 0);

        vm.assume(quantity < 100 && quantity > 0);
        nft.mintTo(quantity, normalAddress);

        assertEq(nft.balanceOf(normalAddress), quantity);
        vm.stopPrank();
    }

    // Add this new test function for batchMint
    function testBatchMint(uint256 quantity) public {
        vm.startPrank(deployerAddress);
        nft = new Daypass("Daypass", "DPASS", true, oneDay);

        vm.assume(quantity > 0 && quantity < 25);

        address[] memory recipients = new address[](quantity);
        for (uint256 i = 0; i < quantity; i++) {
            recipients[i] = address(uint160(i + 1000)); // Use uint160 for type conversion
        }

        nft.batchMint(recipients);

        for (uint256 i = 0; i < quantity; i++) {
            assertEq(nft.balanceOf(recipients[i]), 1);
        }
        vm.stopPrank();
    }

    function testValidUntilTimestamp(uint48 numDays) public {
        vm.startPrank(deployerAddress);
        vm.assume(numDays >= 0 && numDays < 14);
        nft = new Daypass("Daypass", "DPASS", true, oneDay * numDays);
        assertEq(nft.balanceOf(normalAddress), 0);

        nft.mintTo(1, normalAddress);
        assertEq(nft.balanceOf(normalAddress), 1);
        uint256 gasCoveredUntil = nft.hasGasCoveredUntil(normalAddress);
        assertEq(gasCoveredUntil, block.timestamp + oneDay * numDays);
        vm.stopPrank();
    }

    function test_revertWhen_disallowedTransferAttempted() public {
        vm.startPrank(deployerAddress);
        nft = new Daypass("Daypass", "DPASS", false, oneDay);
        nft.mintTo(1, normalAddress);
        vm.stopPrank();

        vm.startPrank(normalAddress);
        vm.expectRevert(NotTransferable.selector);
        nft.transferFrom(normalAddress, deployerAddress, 1);
        vm.stopPrank();
    }

    function testAllowedTransfer() public {
        vm.startPrank(deployerAddress);
        nft = new Daypass("Daypass", "DPASS", true, oneDay);
        nft.mintTo(1, normalAddress);
        vm.stopPrank();

        vm.startPrank(normalAddress);
        nft.transferFrom(normalAddress, deployerAddress, 1);
        assertEq(nft.balanceOf(normalAddress), 0);
        assertEq(nft.balanceOf(deployerAddress), 1);
        vm.stopPrank();
    }
}
