// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/HackathonPaymaster.sol";
import "../src/Daypass.sol";
import "../lib/account-abstraction/contracts/samples/SimpleAccount.sol";
import "../lib/account-abstraction/contracts/core/EntryPoint.sol";

contract DeployPaymasterScript is Script {
    uint256 deployerPrivateKey;
    EntryPoint entrypoint;
    HackathonPaymaster hackathonPaymaster;

    using ECDSA for bytes32;

    function run() external {
        deployerPrivateKey = vm.envUint("OWNER_PRIVATE_KEY");

        Daypass nftPass = Daypass(payable(0xe358557b9e2a9a67318c32c09Daa3CD781b1A58b));
        address[] memory whiteListedAddresses = new address[](1);
        whiteListedAddresses[0] = address(nftPass);

        entrypoint = EntryPoint(payable(0x0576a174D229E3cFA37253523E645A78A0C91B57));

        vm.startBroadcast(deployerPrivateKey);
        hackathonPaymaster = new HackathonPaymaster(
            entrypoint,
            address(nftPass),
            whiteListedAddresses,
            0,
            0,
            0
        );
        vm.stopBroadcast();

        // If new paymaster
        vm.startBroadcast(deployerPrivateKey);
        hackathonPaymaster.addStake{value: 1 ether}(100000);
        vm.stopBroadcast();

        vm.startBroadcast(deployerPrivateKey);
        hackathonPaymaster.deposit{value: 1 ether}();
        vm.stopBroadcast();
    }
}
