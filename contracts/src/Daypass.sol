// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract Daypass is ERC721Enumerable, Ownable {
    uint256 public currentTokenId;
    bool isTransferable;

    mapping(uint256 => uint256) public mintedAt;

    error NotTransferable();

    constructor(string memory name, string memory symbol, bool _isTransferable) payable ERC721(name, symbol) {
        isTransferable = _isTransferable;
    }

    // PUBLIC

    function mintTo(uint256 quantity, address recipient) external onlyOwner {
        _mintToken(quantity, recipient);
    }

    function isPassValid(uint256 tokenId) public view returns (bool) {
        uint256 mintTimestamp = mintedAt[tokenId];
        uint256 threeDays = 3 * 24 * 60 * 60;

        if (block.timestamp < mintTimestamp + threeDays) {
            return true;
        } else {
            return false;
        }
    }

    function hasValidPass(address owner) public view returns (bool) {
        uint256 tokenCount = balanceOf(owner);

        for (uint256 i = 0; i < tokenCount; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(owner, i);
            if (isPassValid(tokenId)) {
                return true;
            }
        }

        return false;
    }

    // VIEW
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        uint256 mintTimestamp = mintedAt[tokenId];
        uint256 threeDays = 3 * 24 * 60 * 60;
        uint256 remainingTime;

        if (block.timestamp < mintTimestamp + threeDays) {
            remainingTime = mintTimestamp + threeDays - block.timestamp;
        } else {
            remainingTime = 0;
        }

        uint256 hoursLeft = remainingTime / 3600;
        uint256 minutesLeft = (remainingTime % 3600) / 60;
        uint256 secondsLeft = remainingTime % 60;

        string[5] memory parts;
        parts[0] =
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350"><style>.base { fill: black; font-family: serif; font-size: 24px; }</style><rect width="100%" height="100%" fill="white" /><text x="50%" y="50%" class="base" text-anchor="middle">';

        parts[1] = string(
            abi.encodePacked(
                "Time Left: ",
                Strings.toString(hoursLeft),
                "h ",
                Strings.toString(minutesLeft),
                "m ",
                Strings.toString(secondsLeft),
                "s "
            )
        );

        parts[2] = "</text></svg>";

        string memory output = string(abi.encodePacked(parts[0], parts[1], parts[2]));

        string memory base64Svg = Base64.encode(bytes(output));
        string memory imageUri = string(abi.encodePacked("data:image/svg+xml;base64,", base64Svg));

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "Daypass #',
                        Strings.toString(tokenId),
                        '", "description": "A Daypass for your gas", "image": "',
                        imageUri,
                        '"}'
                    )
                )
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", json));
    }

    function getIsTransferable() public view returns (bool) {
        return isTransferable;
    }

    function getMintedAt(uint256 tokenId) public view returns (uint256) {
        return mintedAt[tokenId];
    }

    function _mintToken(uint256 quantity, address recipient) internal {
        for (uint256 i = 0; i < quantity; i++) {
            currentTokenId++;
            _mint(recipient, currentTokenId);
            mintedAt[currentTokenId] = block.timestamp;
        }
    }

    // Override
    function _beforeTokenTransfer(address from, address to, uint256 firstTokenId, uint256 batchSize)
        internal
        override
    {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);

        if (from != address(0x0) && !isTransferable) {
            revert NotTransferable();
        }
    }
}
