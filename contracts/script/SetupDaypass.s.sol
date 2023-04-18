// // SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/DaypassPaymaster.sol";
import "../src/SetupHelper.sol";
import "../src/Daypass.sol";
import "../src/Simple721.sol";
import "../lib/account-abstraction/contracts/samples/SimpleAccount.sol";
import "../lib/account-abstraction/contracts/core/EntryPoint.sol";

// contract SimpleAccountNFTReceiver is SimpleAccount {
//     constructor(IEntryPoint anEntryPoint) SimpleAccount(anEntryPoint) {}
//     // Enable erc721 transfers

//     function onERC721Received(address, address, uint256, bytes calldata) external virtual returns (bytes4) {
//         return SimpleAccountNFTReceiver.onERC721Received.selector;
//     }
// }

contract SetupDayPassScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("OWNER_PRIVATE_KEY");
        EntryPoint entrypoint = EntryPoint(payable(0x0576a174D229E3cFA37253523E645A78A0C91B57));
        vm.startBroadcast(deployerPrivateKey);
        SetupHelper setupHelper = new SetupHelper();
        vm.stopBroadcast();

        address[] memory whiteListedAddresses = new address[](1);
        whiteListedAddresses[0] = address(0x38853627cadCB75B7537453b12bFc2AB6eE16E23);

        address[] memory addresses = new address[](1);
        addresses[0] = address(0xb2Fa18B41e77EbB56e318c676A288290F3330894);

        vm.startBroadcast(deployerPrivateKey);
        console.log(vm.addr(deployerPrivateKey));
        (Daypass dayPassContract, Simple721 spaceCanNFTContract, DaypassPaymaster paymaster) = setupHelper.setupDaypass{
            value: 1 ether
        }(
            entrypoint,
            whiteListedAddresses, // List of target contracts which AA can call
            true, // NFT or SBT
            100000000000000000000000000000000000000000000, // How much gas AA can consume in a user operation
            100000000000000000000000000000000000000000000, // How much token AA can transfer in a user transaction
            800000, // how long the NFT is available
            addresses // list of
        );
        vm.stopBroadcast();

        vm.label(address(dayPassContract), "Daypass");
        vm.label(address(spaceCanNFTContract), "Spacecan");
        vm.label(address(setupHelper), "setupHelper");
        console.log(address(dayPassContract));
        console.log(address(spaceCanNFTContract));
        console.log(address(setupHelper));
        console.log(address(paymaster));
        // console.log("DayPass address %s", address(dayPassContract));
        // console.log("SpaceCan address %s", address(spaceCanNFTContract));
        // console.log("SetupHelper address %s", address(setupHelper));
        // console.log("PayMaster address %s", address(paymasterContract));
    }
}
