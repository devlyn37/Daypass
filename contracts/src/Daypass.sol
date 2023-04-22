// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Base64.sol";
import "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

error NotTransferable();

contract Daypass is ERC721Enumerable, Ownable {
    uint256 public currentTokenId;
    uint256 public duration;
    bool public isTransferable;

    // TODO we should consider storing this in the paymaster to avoid staking
    mapping(uint256 => uint256) public validUntil;

    constructor(string memory name, string memory symbol, bool _isTransferable, uint256 _duration)
        payable
        ERC721(name, symbol)
    {
        duration = _duration;
        isTransferable = _isTransferable;
    }

    // PUBLIC
    function mintTo(uint256 quantity, address recipient) external onlyOwner {
        for (uint256 i = 0; i < quantity; i++) {
            currentTokenId++;
            _mint(recipient, currentTokenId); // using unsafe mint right now for smart accounts that aren't 721 receivers
            validUntil[currentTokenId] = block.timestamp + this.duration();
        }
    }

    // A user may have more than one pass, this function finds the one that's valid
    // for the longest and returns that timestamp.
    function hasGasCoveredUntil(address user) public view returns (uint256) {
        uint256 tokenCount = balanceOf(user);
        uint256 coveredUntil = block.timestamp - 1;

        for (uint256 i = 0; i < tokenCount; i++) {
            uint256 tokenId = tokenOfOwnerByIndex(user, i);
            uint256 curr = validUntil[tokenId];
            if (curr > coveredUntil) {
                coveredUntil = curr;
            }
        }

        return coveredUntil;
    }

    // VIEW
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        uint256 remainingTime;
        if (block.timestamp < validUntil[tokenId]) {
            remainingTime = validUntil[tokenId] - block.timestamp;
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
