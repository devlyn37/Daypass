// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/HackathonPaymaster.sol";

contract MyScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Sample entry point address, replace with the actual address
        IEntryPoint entryPoint = IEntryPoint(0x0576a174D229E3cFA37253523E645A78A0C91B57);

        // Sample NFT pass address, replace with the actual address
        address nftPassAddress = 0xe358557b9e2a9a67318c32c09Daa3CD781b1A58b;

        // Sample white-listed addresses, replace with the actual addresses
        address[] memory whiteListedAddresses = new address[](1);
        whiteListedAddresses[0] = 0xe358557b9e2a9a67318c32c09Daa3CD781b1A58b;

        HackathonPaymaster paymaster = new HackathonPaymaster(entryPoint, nftPassAddress, whiteListedAddresses);

        vm.stopBroadcast();
    }
}
