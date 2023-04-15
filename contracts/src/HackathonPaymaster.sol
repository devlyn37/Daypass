// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.19;

/* solhint-disable reason-string */

import "../lib/account-abstraction/contracts/core/BasePaymaster.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "./Hackathon721.sol";

// Sample Paymaster Contract
contract HackathonPaymaster is BasePaymaster {
    using UserOperationLib for UserOperation;

    address public nftPassAddress;
    address[] public whiteAddresses;

    constructor(IEntryPoint _entryPoint, address _nftPassAddress, address[] memory addresses)
        BasePaymaster(_entryPoint)
    {
        nftPassAddress = _nftPassAddress;
        whiteAddresses = addresses;
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
        // 1. Make sure the protocol is in whitelist
        (address dest, uint256 value, bytes memory func) = abi.decode(userOp.callData[4:], (address, uint256, bytes));
        if (!_isInWhiteList(dest)) {
            // Don't pay for the operation, the user doesn't own a pass
            return ("", 1);
        }

        // 2. Make sure the sender has valid NFT
        if (!_hasValidPass(userOp.sender)) {
            // Don't pay for the operation, the user doesn't own a pass
            return ("", 1);
        }

        // Pay for the operation! the user owns a pass
        return ("", 0);
    }

    function _isInWhiteList(address addr) internal view returns (bool) {
        // XXX: Use mapping
        for (uint256 i = 0; i < whiteAddresses.length; i++) {
            if (whiteAddresses[i] == addr) {
                return true;
            }
        }

        return false;
    }

    function _hasValidPass(address account) internal view returns (bool) {
        Hackathon721 nft = Hackathon721(nftPassAddress);
        uint256 tokenCount = nft.balanceOf(account);

        for (uint256 i = 0; i < tokenCount; i++) {
            uint256 tokenId = nft.tokenOfOwnerByIndex(account, i);
            uint256 mintedAt = nft.getMintedAt(tokenId);
            uint256 period = nft.getValidPeriod(tokenId);

            if (block.timestamp < mintedAt + period) {
                return true;
            }
        }

        return false;
    }
}
