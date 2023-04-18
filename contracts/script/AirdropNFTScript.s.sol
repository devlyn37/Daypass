// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/HackathonPaymaster.sol";
import "../src/Daypass.sol";
import "../lib/account-abstraction/contracts/samples/SimpleAccount.sol";
import "../lib/account-abstraction/contracts/core/EntryPoint.sol";

contract AirdropNFT is Script {
    uint256 deployerPrivateKey;
    EntryPoint entrypoint;
    HackathonPaymaster hackathonPaymaster;

    using ECDSA for bytes32;

    function run() external {
        deployerPrivateKey = vm.envUint("OWNER_PRIVATE_KEY");

        entrypoint = EntryPoint(payable(0x0576a174D229E3cFA37253523E645A78A0C91B57));

        //Airdrop the NFT
        Daypass nftPass = Daypass(payable(0xe358557b9e2a9a67318c32c09Daa3CD781b1A58b));
        vm.startBroadcast(deployerPrivateKey);
        nftPass.mintTo(1, address(0xCb3555773F4e5629065A03FA656B5b663cE49b40));
        vm.stopBroadcast();
    }
}
