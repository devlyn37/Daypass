pragma solidity 0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/DaypassPaymaster.sol";
import "../src/Daypass.sol";
import "../src/Simple721.sol";
import "../lib/account-abstraction/contracts/core/EntryPoint.sol";
import "../lib/account-abstraction/contracts/interfaces/IEntryPoint.sol";
import "../lib/account-abstraction/contracts/interfaces/UserOperation.sol";
import "../lib/account-abstraction/contracts/samples/SimpleAccount.sol";
import "../lib/account-abstraction/contracts/bls/BLSSignatureAggregator.sol";

contract SimpleAccountNFTReceiver is SimpleAccount {
    constructor(IEntryPoint anEntryPoint) SimpleAccount(anEntryPoint) {}
    // Enable erc721 transfers

    function onERC721Received(address, address, uint256, bytes calldata) external virtual returns (bytes4) {
        return SimpleAccountNFTReceiver.onERC721Received.selector;
    }
}

contract DaypassPaymasterTest is Test {
    uint256 goerliFork;
    uint256 ownerKey;
    address owner;
    SimpleAccountNFTReceiver player;
    EntryPoint entrypoint;
    DaypassPaymaster paymaster;
    Daypass nftPass;
    Simple721 randomNFT;

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
        nftPass = new Daypass("", "", false, 86400);
        randomNFT = new Simple721();

        address[] memory whiteListedAddresses = new address[](1);
        whiteListedAddresses[0] = address(randomNFT);

        entrypoint = EntryPoint(payable(0x0576a174D229E3cFA37253523E645A78A0C91B57));
        // entrypoint = new EntryPoint();
        paymaster = new DaypassPaymaster(entrypoint, address(nftPass), whiteListedAddresses, 500000_00, 0, 5000);
        paymaster.addStake{value: 500 ether}(100000);
        paymaster.deposit{value: 500 ether}();
        // daypassPass = DaypassPaymaster(payable(0x38A310a0D9a015d23B973478c1EF961C3e44Ee62));

        //Some AA wallet
        player = new SimpleAccountNFTReceiver(entrypoint);
        player.initialize(owner);

        // Give the AA wallet the NFTPass
        nftPass.mintTo(1, address(player));
        vm.stopPrank();

        vm.label(address(player), "player");
    }

    function test_mint_erc721_free_mint() external {
        // Give a user DayPass NFT to allow randomNFT minting

        vm.prank(owner);
        nftPass.mintTo(1, address(player));
        vm.stopPrank();

        vm.prank(address(player));
        uint256 mintAmount = 1;
        bytes memory mintFunction = abi.encodeWithSignature("mint(uint256)", mintAmount);
        bytes memory callData =
            abi.encodeWithSignature("execute(address,uint256,bytes)", address(randomNFT), 0, mintFunction);
        // Make sure the main account has some funds
        vm.deal(address(player), 1 ether);

        vm.warp(4500);
        sendUserOp(callData);
        address latestNftOwner = nftPass.ownerOf(nftPass.currentTokenId());
        assertEq(latestNftOwner, address(player));
    }

    function sendUserOp(bytes memory data) internal {
        uint256 nonce = player.nonce();
        bytes memory initCode = abi.encode();
        uint256 callGasLimit = 40000_00;
        uint256 verificationGasLimit = 40000_00;
        uint256 preVerificationGas = 20000_00;
        uint256 maxFeePerGas = 10000000000;
        uint256 maxPriorityFeePerGas = 100000000;
        bytes memory paymasterAndData = abi.encodePacked(address(paymaster));

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
