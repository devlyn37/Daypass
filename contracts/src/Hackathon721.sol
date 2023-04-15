// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract Hackathon721 is ERC721Enumerable, Ownable {
    uint256 public salePrice = 0 ether;
    uint256 public maxTokensPerTxn = 6;
    uint256 public currentTokenId;

    uint256 constant defaultValidPeriod = 3 * 24 * 60 * 60;

    string public uri = "https://gateway.pinata.cloud/ipfs/QmPux5QgyPHfxjuCBf1GL6bnbYRoDdzwh9UGdnz2UXx58D";

    mapping(uint256 => uint256) public mintedAt;
    mapping(uint256 => uint256) public validPeriod;

    // ERRORS & MODIFIERS

    error IncorrectValue();
    error TooManyTokens();
    error WithdrawTransfer();

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

    constructor() payable ERC721("Daypass", "DPASS") {}

    // PUBLIC

    // For Normal NFT minting
    function mint(uint256 quantity) external payable maxTokens(quantity) isCorrectPayment(quantity) {
        _mintMultiple(quantity, 0);
    }

    // For NFT Pass minting
    function mintWithPeriod(uint256 quantity, uint256 period) external payable maxTokens(quantity) isCorrectPayment(quantity) {
        _mintMultiple(quantity, period);
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

    // PRIVATE
    function _mintMultiple(uint256 quantity, uint256 period) private {
        for (uint256 i = 0; i < quantity; i++) {
            currentTokenId++;
            _safeMint(msg.sender, currentTokenId);

            mintedAt[currentTokenId] = block.timestamp;
            validPeriod[currentTokenId] = period;
        }
    }

    // VIEW

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return uri;
    }

    function getMintedAt(uint256 tokenId) public view returns (uint256) {
        return mintedAt[tokenId];
    }

    function getValidPeriod(uint256 tokenId) public view returns (uint256) {
        return validPeriod[tokenId];
    }
}
