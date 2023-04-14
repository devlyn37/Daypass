// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import "../lib/solmate/src/tokens/ERC1155.sol";
import "../lib/openzeppelin-contracts/contracts/access/Ownable.sol";

contract Hackathon1155 is ERC1155, Ownable {
    uint256 public salePrice = 0.0001 ether;
    uint256 public maxTokensPerTxn = 6;
    string public simpleURI = "https://gateway.pinata.cloud/ipfs/QmPux5QgyPHfxjuCBf1GL6bnbYRoDdzwh9UGdnz2UXx58D";

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

    constructor() payable ERC1155() {}

    // PUBLIC

    function mint(uint256 quantity, uint256 id) external payable maxTokens(quantity) isCorrectPayment(quantity) {
        _mint(msg.sender, id, quantity, "");
    }

    // ADMIN

    function setBaseURI(string calldata baseURI) external onlyOwner {
        simpleURI = baseURI;
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

    function uri(uint256 id) public view override returns (string memory) {
        return simpleURI;
    }
}
