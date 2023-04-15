// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "./Hackathon721.sol";
import "./HackathonPaymaster.sol";

contract SetupHelper {
    function setupDaypass(IEntryPoint entryPoint, address[] memory addresses)
        public
        payable
        returns (Hackathon721 nftContract, HackathonPaymaster paymasterContract)
    {
        // Deploy the NFT contract
        nftContract = new Hackathon721();

        // Deploy the Hackathon Paymaster Contract, then deposit and stake
        paymasterContract = new HackathonPaymaster(entryPoint, address(nftContract), addresses);
        paymasterContract.deposit{value: msg.value / 2}();
        paymasterContract.addStake{value: msg.value / 2}(86400);

        // Transfer ownership of the Paymaster and NFT contracts to the called
        paymasterContract.transferOwnership(msg.sender);
        nftContract.transferOwnership(msg.sender);

        return (nftContract, paymasterContract);
    }
}
