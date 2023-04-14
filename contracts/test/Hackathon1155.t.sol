// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/Hackathon1155.sol";

contract Hackathon1155Test is Test {
    using stdStorage for StdStorage;

    Hackathon1155 private sft;
    address private normalAddress;
    address private contractAddress;
    address private deployerAddress;

    function setUp() public {
        sft = new Hackathon1155();
        contractAddress = address(sft);
        deployerAddress = address(0xE898BBd704CCE799e9593a9ADe2c1cA0351Ab660);
        normalAddress = address(1);

        vm.deal(contractAddress, 100 ether);
        vm.deal(normalAddress, 100 ether);
    }

    function testFailIncorrectValue(uint256 quantity) public {
        vm.assume(quantity < sft.maxTokensPerTxn() && quantity > 0);
        vm.prank(normalAddress);

        //vm.expectRevert(IncorrectValue.selector);
        sft.mint{value: 0.00002 ether * quantity}(quantity, 1);
    }

    function testFailTooManyTokens(uint256 quantity) public {
        vm.assume(quantity > sft.maxTokensPerTxn() && quantity < 100);
        uint256 salePrice = sft.salePrice();

        vm.prank(normalAddress);

        //vm.expectRevert(TooManyTokens.selector);
        sft.mint{value: salePrice * quantity}(quantity, 1);
    }

    function testMint(uint256 quantity) public {
        vm.startPrank(normalAddress);

        assertEq(sft.balanceOf(normalAddress, 1), 0);

        vm.assume(quantity < sft.maxTokensPerTxn() && quantity > 0);
        sft.mint{value: sft.salePrice() * quantity}(quantity, 1);

        assertEq(sft.balanceOf(normalAddress, 1), quantity);
        vm.stopPrank();
    }
}
