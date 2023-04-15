// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/Hackathon721.sol";

contract Hackathon721Test is Test {
    using stdStorage for StdStorage;

    Hackathon721 private nft;
    address private normalAddress;
    address private contractAddress;
    address private deployerAddress;

    function setUp() public {
        deployerAddress = address(1);
        vm.prank(deployerAddress);
        nft = new Hackathon721();
        contractAddress = address(nft);
        normalAddress = address(2);

        vm.deal(contractAddress, 100 ether);
        vm.deal(normalAddress, 100 ether);
    }

    function testFailIncorrectValue(uint256 quantity) public {
        vm.assume(quantity < nft.maxTokensPerTxn() && quantity > 0);
        vm.prank(normalAddress);

        //vm.expectRevert(IncorrectValue.selector);
        nft.mint{value: 0.00002 ether * quantity}(quantity);
    }

    function testFailTooManyTokens(uint256 quantity) public {
        vm.assume(quantity > nft.maxTokensPerTxn() && quantity < 100);
        uint256 salePrice = nft.salePrice();

        vm.prank(normalAddress);

        //vm.expectRevert(TooManyTokens.selector);
        nft.mint{value: salePrice * quantity}(quantity);
    }

    function testMint(uint256 quantity) public {
        uint256 blockTime = 1000;

        vm.startPrank(normalAddress);
        assertEq(nft.balanceOf(normalAddress), 0);

        vm.assume(quantity < nft.maxTokensPerTxn() && quantity > 0);

        vm.warp(blockTime);

        nft.mint{value: nft.salePrice() * quantity}(quantity);

        assertEq(nft.balanceOf(normalAddress), quantity);

        for(uint256 i=1; i<=quantity; i++) {
            assertEq(nft.getMintedAt(i), blockTime);
            assertEq(nft.getValidPeriod(i), 0);
        }

        vm.stopPrank();
    }

    function testMintWithPeriod(uint256 quantity) public {
        uint256 blockTime = 1000;
        uint256 period = 20000;
        
        vm.startPrank(normalAddress);
        assertEq(nft.balanceOf(normalAddress), 0);

        vm.assume(quantity < nft.maxTokensPerTxn() && quantity > 0);

        vm.warp(blockTime);

        nft.mintWithPeriod{value: nft.salePrice() * quantity}(quantity, period);

        assertEq(nft.balanceOf(normalAddress), quantity);

        for(uint256 i=1; i<=quantity; i++) {
            assertEq(nft.getMintedAt(i), blockTime);
            assertEq(nft.getValidPeriod(i), period);
        }

        vm.stopPrank();
    }

    function testWithdrawalWorksAsOwner() public {
        // Mint an NFT, sending eth to the contract
        address payable payee = payable(normalAddress);
        uint256 priorPayeeBalance = payee.balance;
        uint256 priorContractBalance = contractAddress.balance;

        vm.prank(deployerAddress);
        nft.withdrawPayments(payee);
        assertEq(payee.balance, priorPayeeBalance + priorContractBalance);
    }

    function testFailWithdrawNotOwner() public {
        vm.prank(normalAddress);
        nft.withdrawPayments(payable(address(0)));
    }
}
