// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "../lib/forge-std/src/Script.sol";
import "../src/HackathonPaymaster.sol";
import "../src/Hackathon721.sol";
import "../lib/account-abstraction/contracts/samples/SimpleAccount.sol";
import "../lib/account-abstraction/contracts/core/EntryPoint.sol";

contract SimpleAccountNFTReceiver is SimpleAccount, ERC721TokenReceiver {
    constructor(IEntryPoint anEntryPoint) SimpleAccount(anEntryPoint) {}
    // Enable erc721 transfers
}

contract MintNFTScript is Script {
    uint256 deployerPrivateKey;
    SimpleAccountNFTReceiver player;
    EntryPoint entrypoint;
    HackathonPaymaster hackathonPaymaster;

    using ECDSA for bytes32;

    function run() external {
        deployerPrivateKey = vm.envUint("OWNER_PRIVATE_KEY");
        entrypoint = EntryPoint(payable(0x0576a174D229E3cFA37253523E645A78A0C91B57));
        hackathonPaymaster = HackathonPaymaster(payable(0x32710e951D76c48D5b62aD9B38d4faf13a0AF80A));
        Hackathon721 nftPass = Hackathon721(payable(0xe358557b9e2a9a67318c32c09Daa3CD781b1A58b));

        uint256 mintAmount = 1;
        uint256 salePrice = 0 ether * mintAmount;
        bytes memory mintFunction = abi.encodeWithSignature("mint(uint256)", mintAmount);

        bytes memory callData =
            abi.encodeWithSignature("execute(address,uint256,bytes)", address(nftPass), salePrice, mintFunction);
        vm.startBroadcast(deployerPrivateKey);
        sendUserOp(SimpleAccountNFTReceiver(payable(0xCb3555773F4e5629065A03FA656B5b663cE49b40)), callData);
        vm.stopBroadcast();
    }

    function sendUserOp(SimpleAccountNFTReceiver contractAccount, bytes memory data) internal {
        // Sign the hash
        // No init code
        UserOperation memory userOp = UserOperation(
            address(contractAccount),
            contractAccount.nonce(),
            abi.encode(),
            data,
            8000_00,
            1000_00,
            20000_00,
            10000000000,
            100000000,
            abi.encodePacked(address(hackathonPaymaster)),
            abi.encode()
        );
        bytes32 userOpHash = entrypoint.getUserOpHash(userOp).toEthSignedMessageHash();
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(deployerPrivateKey, userOpHash);
        userOp.signature = abi.encodePacked(r, s, v);
        UserOperation[] memory userOperations = new UserOperation[](1);
        userOperations[0] = userOp;

        entrypoint.handleOps{gas: 1000000}(userOperations, payable(address(contractAccount)));
    }

    function internalUserOpHash(UserOperation memory userOp) internal pure returns (bytes32) {
        return keccak256(
            abi.encode(
                userOp.sender,
                userOp.nonce,
                keccak256(userOp.initCode),
                keccak256(userOp.callData),
                userOp.callGasLimit,
                userOp.verificationGasLimit,
                userOp.preVerificationGas,
                userOp.maxFeePerGas,
                userOp.maxPriorityFeePerGas,
                keccak256(userOp.paymasterAndData)
            )
        );
    }
}
