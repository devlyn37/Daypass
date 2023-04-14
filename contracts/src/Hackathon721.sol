// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "../lib/solmate/src/tokens/ERC721.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Hackathon721 is ERC721, Ownable {
    uint256 public salePrice = 0 ether;
    uint256 public maxTokensPerTxn = 6;
    uint256 public currentTokenId;

    string public uri = "https://gateway.pinata.cloud/ipfs/QmPux5QgyPHfxjuCBf1GL6bnbYRoDdzwh9UGdnz2UXx58D";

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

    constructor() payable ERC721("Testing Tokens", "XMTEST") {}

    // PUBLIC

    function mint(uint256 quantity) external payable maxTokens(quantity) isCorrectPayment(quantity) {
        for (uint256 i = 0; i < quantity; i++) {
            _mint(msg.sender, ++currentTokenId);
        }
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
}
