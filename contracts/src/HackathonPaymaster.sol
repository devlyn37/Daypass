// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

/* solhint-disable reason-string */

import "../lib/account-abstraction/contracts/core/BasePaymaster.sol";
import "../lib/account-abstraction/contracts/interfaces/IPaymaster.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

// Sample Paymaster Contract
contract HackathonPaymaster is BasePaymaster {
    using UserOperationLib for UserOperation;

    // NFTs a wallet account needs to own to ask Paymaster a fee
    address public nftPassAddress;

    // List of contract address Paymaster can pay fee for
    address[] public whiteListAddresses;

    constructor(IEntryPoint _entryPoint, address _nftPassAddress, address[] memory _whiteListAddresses)
        BasePaymaster(_entryPoint)
    {
        nftPassAddress = _nftPassAddress;
        whiteListAddresses = _whiteListAddresses;
    }

    function setNftPassAddress(address newNftPassAddress) external onlyOwner {
        nftPassAddress = newNftPassAddress;
    }

    function setWhiteAddresses(address[] memory addresses) external onlyOwner {
        whiteListAddresses = addresses;
    }

    function validatePaymasterUserOp(UserOperation calldata userOp, bytes32 userOpHash, uint256 maxCost)
        external
        view
        override
        returns (bytes memory context, uint256 deadline)
    {
        // 1. Make sure Account Wallet calls allowed contract (e.g. their protocol) during execution
        (address dest, uint256 value, bytes memory func) = abi.decode(userOp.callData, (address, uint256, bytes));
        if (!_isInWhiteList(dest)) {
            return ("", 1);
        }

        // 2. Make sure Account Wallet has a specific NFT indicating the Account Wallet is allowed no fee execution
        IERC721 nftContract = IERC721(nftPassAddress);
        uint256 tokenCount = nftContract.balanceOf(userOp.sender);

        if (totalCount == 0) {
            // Don't pay for the operation, the user doesn't own a pass
            return ("", 1);
        }

        // 3. Additional conditions (e.g. Timeframe, Gas Limit)

        // Pay for the operation! the user owns a pass
        return ("", 0);
    }

    function postOp(PostOpMode mode, bytes calldata context, uint256 actualGasCost) external {
        // Reduce gas limit allowance from the slot associated with NFT
    }

    function _isInWhiteList(address addr) internal view returns (bool) {
        for (uint256 i = 0; i < whiteListAddresses.length; i++) {
            if (whiteListAddresses[i] == addr) {
                return true;
            }
        }

        return false;
    }
}
