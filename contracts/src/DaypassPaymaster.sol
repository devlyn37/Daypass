// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

/* solhint-disable reason-string */

import "../lib/account-abstraction/contracts/core/BasePaymaster.sol";
import "../lib/account-abstraction/contracts/core/Helpers.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "./Daypass.sol";

error ExceedingGasLimit();
error ExceedingSpendingLimit();
error NoDaypass();
error AddressNotAllowed();

// Sample Paymaster Contract

contract DaypassPaymaster is BasePaymaster {
    using UserOperationLib for UserOperation;

    address public nftPassAddress;
    address[] public whiteAddresses;
    uint256 public gasLimitPerOperation;
    uint256 public spendingLimitPerOperation;
    uint256 public timeLimitInSecond;

    constructor(
        IEntryPoint _entryPoint,
        address _nftPassAddress,
        address[] memory addresses,
        uint256 _gasLimitPerOperation,
        uint256 _spendingLimitPerOperation,
        uint256 _timeLimitInSecond
    ) BasePaymaster(_entryPoint) {
        nftPassAddress = _nftPassAddress;
        whiteAddresses = addresses;
        gasLimitPerOperation = _gasLimitPerOperation;
        spendingLimitPerOperation = _spendingLimitPerOperation;
        timeLimitInSecond = _timeLimitInSecond;
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

        Daypass daypassContract = Daypass(nftPassAddress);
        uint256 tokenCount = daypassContract.balanceOf(userOp.sender);

        if (tokenCount < 1) {
            revert("no daypass");
        }

        if (!_isInWhiteList(dest)) {
            revert("address not allowed");
        }

        if (_exceedsGasLimit(userOp.callGasLimit)) {
            revert("gas limit too high");
        }

        if (_exceedsSpendingLimit(maxCost)) {
            revert("max cost too high");
        }

        // Ok, the operation is valid as far as we're concerned
        // return validUntil based on the latest Daypass
        // let the bundler check the time
        uint48 validUntil = daypassContract.hasGasCoveredUntil(userOp.sender);
        uint48 validAfter = uint48(block.timestamp);
        return ("", _packValidationData(false, validUntil, validAfter));
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

    function _exceedsSpendingLimit(uint256 maxCost) internal view returns (bool) {
        return spendingLimitPerOperation != 0 && maxCost > spendingLimitPerOperation;
    }
}
