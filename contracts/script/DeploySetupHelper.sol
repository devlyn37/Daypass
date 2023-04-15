// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/SetupHelper.sol";
import "../lib/account-abstraction/contracts/samples/SimpleAccount.sol";
import "../lib/account-abstraction/contracts/core/EntryPoint.sol";

contract DeploySetupHelperScript is Script {
    uint256 deployerPrivateKey;
    SetupHelper setupHelper;

    using ECDSA for bytes32;

    function run() external {
        deployerPrivateKey = vm.envUint("OWNER_PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        setupHelper = new SetupHelper();
        vm.stopBroadcast();
    }
}
