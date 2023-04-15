// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/HackathonPaymaster.sol";
import "../src/Hackathon721.sol";
import "../lib/account-abstraction/contracts/samples/SimpleAccount.sol";
import "../lib/account-abstraction/contracts/core/EntryPoint.sol";

contract SimpleAccountNFTReceiver is SimpleAccount {
    constructor(IEntryPoint anEntryPoint) SimpleAccount(anEntryPoint) {}
    // Enable erc721 transfers

    function onERC721Received(address, address, uint256, bytes calldata) external virtual returns (bytes4) {
        return SimpleAccountNFTReceiver.onERC721Received.selector;
    }
}

contract CreateContractAccount is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("OWNER_PRIVATE_KEY");
        EntryPoint entrypoint = EntryPoint(payable(0x0576a174D229E3cFA37253523E645A78A0C91B57));
        vm.startBroadcast(deployerPrivateKey);
        SimpleAccountNFTReceiver player = new SimpleAccountNFTReceiver(entrypoint);
        vm.stopBroadcast();

        vm.startBroadcast(deployerPrivateKey);
        player.initialize(vm.addr(deployerPrivateKey));
        vm.stopBroadcast();
    }
}
