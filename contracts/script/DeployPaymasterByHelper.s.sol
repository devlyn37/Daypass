// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/HackathonPaymaster.sol";
import "../src/Hackathon721.sol";
import "../src/SetupHelper.sol";
import "../lib/account-abstraction/contracts/samples/SimpleAccount.sol";
import "../lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";

contract DeployPaymasterByHelperScript is Script {
    uint256 deployerPrivateKey;
    SetupHelper setupHelper;

    HackathonPaymaster paymaster;
    Hackathon721 dayPass;
    Hackathon721 nft;

    using ECDSA for bytes32;

    function run() external {
        deployerPrivateKey = vm.envUint("OWNER_PRIVATE_KEY");

        setupHelper = SetupHelper(0xd4C747bDE076B5c9340ae4aFeab0611970Ea0e68);

        Hackathon721 nftPass = Hackathon721(payable(0xe358557b9e2a9a67318c32c09Daa3CD781b1A58b));
        address[] memory whiteListedAddresses = new address[](1);
        whiteListedAddresses[0] = address(nftPass);

        address[] memory accounts = new address[](1);
        accounts[0] = vm.addr(deployerPrivateKey);

        vm.startBroadcast(deployerPrivateKey);
        (dayPass, nft, paymaster) = setupHelper.setupDaypass{value: 2 ether}(
            IEntryPoint(payable(0x0576a174D229E3cFA37253523E645A78A0C91B57)),
            whiteListedAddresses,
            false,
            0,
            0,
            0,
            accounts
        );
        vm.stopBroadcast();
    }
}
