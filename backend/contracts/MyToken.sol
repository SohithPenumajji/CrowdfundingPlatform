// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// this is the erc20 token from openzeppelin
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract MyToken is ERC20 {
    constructor(uint256 initalSupply) ERC20("MyToken","MTK") {
        _mint(msg.sender,initalSupply);
    }
}
