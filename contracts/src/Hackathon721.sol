// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Hackathon721 is ERC721Enumerable, Ownable {
    uint256 public salePrice = 0 ether;
    uint256 public maxTokensPerTxn = 6;
    uint256 public currentTokenId;

    string public uri = "https://gateway.pinata.cloud/ipfs/QmPux5QgyPHfxjuCBf1GL6bnbYRoDdzwh9UGdnz2UXx58D";

    bool isTransferable;
    mapping(uint256 => uint256) public mintedAt;

    // ERRORS & MODIFIERS

    error IncorrectValue();
    error TooManyTokens();
    error WithdrawTransfer();
    error NotTransferable();

    modifier isCorrectPayment(uint256 quantity) {
        if (salePrice * quantity != msg.value) {
            revert IncorrectValue();
        }
        _;
    }

    modifier maxTokens(uint256 quantity) {
        if (quantity > maxTokensPerTxn) {
            revert TooManyTokens();
        }
        _;
    }

    constructor(
        string memory name,
        string memory symbol,
        bool _isTransferable
    ) payable ERC721(name, symbol) {
        isTransferable = _isTransferable;
    }

    // PUBLIC

    function mint(uint256 quantity) external payable maxTokens(quantity) isCorrectPayment(quantity) {
        _mintToken(quantity, msg.sender);
    }

    function mintTo(uint256 quantity, address recipient) external payable maxTokens(quantity) isCorrectPayment(quantity) {
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

    // ADMIN

    function setBaseURI(string calldata baseURI) external onlyOwner {
        uri = baseURI;
    }

    function setSalePrice(uint256 price) external onlyOwner {
        salePrice = price;
    }

    function withdrawPayments(address payable payee) external onlyOwner {
        uint256 balance = address(this).balance;
        (bool transferTx,) = payee.call{value: balance}("");
        if (!transferTx) {
            revert WithdrawTransfer();
        }
    }

    // VIEW

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return uri;
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
            _safeMint(recipient, currentTokenId);
            mintedAt[currentTokenId] = block.timestamp;
        }
    }

    // Override
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 firstTokenId,
        uint256 batchSize
    ) internal override {
        super._beforeTokenTransfer(from, to, firstTokenId, batchSize);

        if (from != address(0x0) && !isTransferable) {
            revert NotTransferable();
        }
    }

}
