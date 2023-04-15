pragma solidity 0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/HackathonPaymaster.sol";
import "../src/Hackathon721.sol";
import {ERC721TokenReceiver} from "solmate/tokens/ERC721.sol";
import "../lib/account-abstraction/contracts/core/EntryPoint.sol";
import "../lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import "../lib/account-abstraction/contracts/interfaces/UserOperation.sol";
import "../lib/account-abstraction/contracts/samples/SimpleAccount.sol";
import "../lib/account-abstraction/contracts/bls/BLSSignatureAggregator.sol";

contract SimpleAccountNFTReceiver is SimpleAccount, ERC721TokenReceiver {
    constructor(IEntryPoint anEntryPoint) SimpleAccount(anEntryPoint) {}
    // Enable erc721 transfers
}

contract HackathonPaymasterTest is Test {
    uint256 goerliFork;
    uint256 ownerKey;
    address owner;
    SimpleAccountNFTReceiver player;
    EntryPoint entrypoint;
    HackathonPaymaster hackathonPaymaster;
    Hackathon721 nftPass;
    Hackathon721 randomNFT;

    using ECDSA for bytes32;
    using UserOperationLib for UserOperation;

    event EmitS(uint256 s);
    // create two _different_ forks during setup.

    function setUp() public {
        goerliFork = vm.createFork(vm.envString("GOERLI_RPC_URL"));

        ownerKey = vm.envUint("OWNER_PRIVATE_KEY");
        owner = vm.addr(ownerKey);
        // Give some eth to the paymaster
        vm.selectFork(goerliFork);

        vm.deal(owner, 1001 ether);

        // Paymaster stakes

        vm.startPrank(owner);
        nftPass = new Hackathon721("", "", false);
        randomNFT = new Hackathon721("", "", true);
        address[] memory whiteListedAddresses = new address[](1);
        whiteListedAddresses[0] = address(randomNFT);

        entrypoint = EntryPoint(payable(0x0576a174D229E3cFA37253523E645A78A0C91B57));
        hackathonPaymaster = new HackathonPaymaster(entrypoint, address(nftPass), whiteListedAddresses, 500000_00);
        hackathonPaymaster.addStake{value: 500 ether}(100000);
        hackathonPaymaster.deposit{value: 500 ether}();

        player = new SimpleAccountNFTReceiver(entrypoint);
        player.initialize(owner);

        vm.stopPrank();
    }

    function test_mint_erc721_free_mint() external {
        // Give a user DayPass NFT to allow randomNFT minting
        vm.prank(address(player));
        nftPass.mint(1);

        uint256 mintAmount = 1;
        bytes memory mintFunction = abi.encodeWithSignature("mint(uint256)", mintAmount);
        bytes memory callData =
            abi.encodeWithSignature("execute(address,uint256,bytes)", address(randomNFT), 0, mintFunction);
        // Make sure the main account has some funds
        vm.deal(address(player), 1 ether);
        sendUserOp(callData);
    }

    function sendUserOp(bytes memory data) internal {
        uint256 nonce = player.nonce();
        bytes memory initCode = abi.encode();
        uint256 callGasLimit = 400000_00;
        uint256 verificationGasLimit = 400000_00;
        uint256 preVerificationGas = 200000_00;
        uint256 maxFeePerGas = 100000000000;
        uint256 maxPriorityFeePerGas = 1000000000;
        bytes memory paymasterAndData = abi.encodePacked(address(hackathonPaymaster));

        // Sign the hash
        UserOperation memory userOp = UserOperation(
            address(player),
            nonce,
            initCode,
            data,
            callGasLimit,
            verificationGasLimit,
            preVerificationGas,
            maxFeePerGas,
            maxPriorityFeePerGas,
            paymasterAndData,
            abi.encode()
        );
        bytes32 userOpHash = entrypoint.getUserOpHash(userOp).toEthSignedMessageHash();
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(ownerKey, userOpHash);
        userOp.signature = abi.encodePacked(r, s, v);
        UserOperation[] memory userOperations = new UserOperation[](1);
        userOperations[0] = userOp;

        entrypoint.handleOps(userOperations, payable(address(1)));
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
