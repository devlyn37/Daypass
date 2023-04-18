// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "./Daypass.sol";
import "./Simple721.sol";
import "./DaypassPaymaster.sol";

contract SetupHelper {
    event DaypassSetUp(address dayPass, address spaceCanNFT, address payMaster);

    function setupDaypass(
        IEntryPoint entryPoint,
        address[] memory targetAdddresses, // List of target contracts which AA can call
        bool isDayPassTransferble, // NFT or SBT
        uint256 gasLimitPerOperation, // How much gas AA can consume in a user operation
        uint256 spendingLimitPerOperation, // How much token AA can transfer in a user transaction
        uint256 timeLimitInSecond, // how long the NFT is available
        address[] memory addresses // list of AA address that gets DayPass NFT
    )
        public
        payable
        returns (Daypass dayPassContract, Simple721 spaceCanNFTContract, DaypassPaymaster paymasterContract)
    {
        // Deploy the NFT contract
        dayPassContract = new Daypass("Daypass", "DPASS", isDayPassTransferble);

        // Deploy the Hackathon Paymaster Contract, then deposit and stake
        paymasterContract =
        new DaypassPaymaster(entryPoint, address(dayPassContract), targetAdddresses, gasLimitPerOperation, spendingLimitPerOperation, timeLimitInSecond);
        paymasterContract.deposit{value: msg.value / 2}();
        paymasterContract.addStake{value: msg.value / 2}(86400);

        // AirDrop
        for (uint256 i = 0; i < addresses.length; i++) {
            dayPassContract.mintTo(1, addresses[i]);
        }

        // Transfer ownership of the Paymaster and NFT contracts to the called
        paymasterContract.transferOwnership(msg.sender);
        dayPassContract.transferOwnership(msg.sender);

        emit DaypassSetUp(address(dayPassContract), address(spaceCanNFTContract), address(paymasterContract));

        return (dayPassContract, Simple721(0x38853627cadCB75B7537453b12bFc2AB6eE16E23), paymasterContract);
    }
}
