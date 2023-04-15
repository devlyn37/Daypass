// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

/* solhint-disable reason-string */

import "../lib/account-abstraction/contracts/core/BasePaymaster.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";

// Sample Paymaster Contract
contract HackathonPaymaster is BasePaymaster {
    using UserOperationLib for UserOperation;

    error ExceedingGasLimit();

    address public nftPassAddress;
    address[] public whiteAddresses;
    uint256 public gasLimitPerOperation;
    uint256 public spendingLimitPerOperation;

    constructor(
        IEntryPoint _entryPoint,
        address _nftPassAddress,
        address[] memory addresses,
        uint256 _gasLimitPerOperation,
        uint256 _spendingLimitPerOperation
    )
        BasePaymaster(_entryPoint)
    {
        nftPassAddress = _nftPassAddress;
        whiteAddresses = addresses;
        gasLimitPerOperation = _gasLimitPerOperation;
        spendingLimitPerOperation = _spendingLimitPerOperation;
    }

    function setNftPassAddress(address newNftPassAddress) external onlyOwner {
        nftPassAddress = newNftPassAddress;
    }

    function setWhiteAddresses(address[] memory addresses) external onlyOwner {
        whiteAddresses = addresses;
    }

    function validatePaymasterUserOp(UserOperation calldata userOp, bytes32 userOpHash, uint256 maxCost)
        external
        view
        override
        returns (bytes memory context, uint256 deadline)
    {
        (address dest, uint256 value, bytes memory func) = abi.decode(userOp.callData[4:], (address, uint256, bytes));
        if (!_isInWhiteList(dest)) {
            return ("", 1);
        }

        if (_exceedsGasLimit(userOp.callGasLimit)) {
            return ("", 1);
        }

        if (_exceedsSpendingLimit()) {
            return ("", 1);
        }

        IERC721 nftContract = IERC721(nftPassAddress);
        uint256 tokenCount = nftContract.balanceOf(userOp.sender);

        if (tokenCount > 0) {
            // Pay for the operation! the user owns a pass
            return ("", 0);
        } else {
            // Don't pay for the operation, the user doesn't own a pass
            return ("", 1);
        }
    }

    function _isInWhiteList(address addr) internal view returns (bool) {
        for (uint256 i = 0; i < whiteAddresses.length; i++) {
            if (whiteAddresses[i] == addr) {
                return true;
            }
        }

        return false;
    }

    function _exceedsGasLimit(uint256 operationGasLimit) internal view returns (bool) {
        return gasLimitPerOperation != 0 && operationGasLimit > gasLimitPerOperation;
    }

    function _exceedsSpendingLimit() internal view returns (bool) {
        return spendingLimitPerOperation != 0 && msg.value > spendingLimitPerOperation;
    }
}
