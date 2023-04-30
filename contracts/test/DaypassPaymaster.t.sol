pragma solidity 0.8.19;

import "../lib/forge-std/src/Test.sol";
import "../src/DaypassPaymaster.sol";
import "../src/Daypass.sol";
import "../src/Simple721.sol";
import "../src/setupHelper.sol";
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
    bytes mintFunction;
    address[] whiteListedAddresses = new address[](1);
    address[] airdropAddresses = new address[](1);
    uint48 oneDay = 86400;
    SimpleAccountNFTReceiver player;
    EntryPoint entrypoint;
    DaypassPaymaster paymaster;
    Daypass nftPass;
    SetupHelper setupHelper;
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
        entrypoint = EntryPoint(payable(0x0576a174D229E3cFA37253523E645A78A0C91B57));

        vm.startPrank(owner);
        setupHelper = new SetupHelper();
        randomNFT = new Simple721();
        whiteListedAddresses[0] = address(randomNFT);

        //Some AA wallet
        player = new SimpleAccountNFTReceiver(entrypoint);
        player.initialize(owner);
        vm.label(address(player), "player");
        airdropAddresses[0] = address(player);
        mintFunction = abi.encodeWithSignature("mint(uint256)", 1);

        vm.stopPrank();
    }

    function test_happyPath() external {
        vm.prank(owner);
        (nftPass, paymaster) = setupHelper.setupDaypass{value: 10 ether}(
            entrypoint, whiteListedAddresses, false, 500000_00, 0, oneDay, airdropAddresses
        );

        bytes memory mintFunction = abi.encodeWithSignature("mint(uint256)", 1);
        UserOperation[] memory userOperations = new UserOperation[](1);
        userOperations[0] = constructUserOp(mintFunction, address(randomNFT), 80000);

        vm.prank(address(player));
        entrypoint.handleOps(userOperations, payable(address(1)));

        address latestNftOwner = nftPass.ownerOf(nftPass.currentTokenId());
        assertEq(latestNftOwner, address(player));
    }

    function test_expiredPass() external {
        vm.prank(owner);
        (nftPass, paymaster) = setupHelper.setupDaypass{value: 10 ether}(
            entrypoint, whiteListedAddresses, false, 500000_00, 0, oneDay, airdropAddresses
        );

        uint48 delay = oneDay + 1;
        vm.warp(block.timestamp + delay);

        UserOperation[] memory userOperations = new UserOperation[](1);
        userOperations[0] = constructUserOp(mintFunction, address(randomNFT), 80000);

        vm.prank(address(player));
        vm.expectRevert(abi.encodeWithSignature("FailedOp(uint256,string)", 0, "AA32 paymaster expired or not due"));
        entrypoint.handleOps(userOperations, payable(address(1)));
    }

    function test_revertWhen_noPass() external {
        vm.prank(owner);
        address[] memory emptyAirdropArray = new address[](0);
        (nftPass, paymaster) = setupHelper.setupDaypass{value: 10 ether}(
            entrypoint, whiteListedAddresses, false, 500000_00, 0, oneDay, emptyAirdropArray
        );

        UserOperation[] memory userOperations = new UserOperation[](1);
        userOperations[0] = constructUserOp(mintFunction, address(randomNFT), 80000);

        vm.prank(address(player));
        vm.expectRevert(abi.encodeWithSignature("FailedOp(uint256,string)", 0, "AA33 reverted: no daypass"));
        entrypoint.handleOps(userOperations, payable(address(1)));
    }

    function test_revertWhen_gasTooHigh() external {
        vm.prank(owner);
        uint256 maximumGas = 1;
        (nftPass, paymaster) = setupHelper.setupDaypass{value: 10 ether}(
            entrypoint, whiteListedAddresses, false, maximumGas, 0, oneDay, airdropAddresses
        );

        UserOperation[] memory userOperations = new UserOperation[](1);
        uint256 bigGasLimit = 120000;
        userOperations[0] = constructUserOp(mintFunction, address(randomNFT), bigGasLimit);

        vm.prank(address(player));
        vm.expectRevert(abi.encodeWithSignature("FailedOp(uint256,string)", 0, "AA33 reverted: gas limit too high"));
        entrypoint.handleOps(userOperations, payable(address(1)));
    }

    function test_revertWhen_maxCostTooHigh() external {
        vm.prank(owner);
        uint256 superLowSpendingLimit = 1;
        (nftPass, paymaster) = setupHelper.setupDaypass{value: 10 ether}(
            entrypoint, whiteListedAddresses, false, 500000_00, superLowSpendingLimit, oneDay, airdropAddresses
        );

        UserOperation[] memory userOperations = new UserOperation[](1);
        uint256 largeCallGasLimit = 120000;
        userOperations[0] = constructUserOp(mintFunction, address(randomNFT), largeCallGasLimit);

        vm.prank(address(player));
        vm.expectRevert(abi.encodeWithSignature("FailedOp(uint256,string)", 0, "AA33 reverted: max cost too high"));
        entrypoint.handleOps(userOperations, payable(address(1)));
    }

    function constructUserOp(bytes memory callData, address to, uint256 callGasLimit)
        internal
        view
        returns (UserOperation memory userOp)
    {
        bytes memory data = abi.encodeWithSignature("execute(address,uint256,bytes)", to, 0, callData);

        uint256 nonce = player.nonce();
        bytes memory initCode = abi.encode();
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

        return userOp;
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
