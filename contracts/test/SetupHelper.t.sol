// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/SetupHelper.sol";
import "../src/Daypass.sol";
import "../src/Simple721.sol";
import "../src/DaypassPaymaster.sol";

contract SetupHelperTest is Test {
    using stdStorage for StdStorage;

    uint256 goerliFork;

    SetupHelper private setupHelper;
    address private normalAddress;
    address private contractAddress;
    address private deployerAddress;

    function setUp() public {
        goerliFork = vm.createFork(vm.envString("GOERLI_RPC_URL"));
        vm.selectFork(goerliFork);

        deployerAddress = address(1);
        vm.prank(deployerAddress);
        setupHelper = new SetupHelper();
        contractAddress = address(setupHelper);
        normalAddress = address(2);

        vm.deal(address(this), 100 ether);
        vm.deal(deployerAddress, 100 ether);
        vm.deal(contractAddress, 100 ether);
        vm.deal(normalAddress, 100 ether);
    }

    function testSetup() public {
        vm.startPrank(normalAddress);

        // Sample entry point address
        IEntryPoint entryPoint = IEntryPoint(0x0576a174D229E3cFA37253523E645A78A0C91B57);

        // Sample white-listed addresses
        address[] memory whiteListedAddresses = new address[](1);
        whiteListedAddresses[0] = 0xe358557b9e2a9a67318c32c09Daa3CD781b1A58b;

        console.log("Here's the address of the deployed setup helper");
        console.log(address(setupHelper));

        address[] memory passHolders = new address[](2);
        passHolders[0] = address(11);
        passHolders[1] = address(22);

        (Daypass dayPassContract, DaypassPaymaster paymasterContract) =
            setupHelper.setupDaypass{value: 1 ether}(entryPoint, whiteListedAddresses, false, 0, 0, 0, passHolders);

        // call should own both of the deployed contracts
        assertEq(dayPassContract.owner(), normalAddress);
        assertEq(dayPassContract.getIsTransferable(), false);

        assertEq(paymasterContract.owner(), normalAddress);
        assertEq(paymasterContract.getDeposit(), 0.5 ether);

        assertEq(dayPassContract.balanceOf(passHolders[0]), 1);
        assertEq(dayPassContract.balanceOf(passHolders[1]), 1);

        vm.stopPrank();
    }
}
