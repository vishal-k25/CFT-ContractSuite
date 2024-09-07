// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ChainForgeToken is ERC20, Ownable {
    uint256 public constant INITIAL_SUPPLY = 1000000 * 10**18; // 1,000,000 tokens with 18 decimals

    constructor() ERC20("ChainForgeToken", "CFT") Ownable(msg.sender) {
        _mint(msg.sender, INITIAL_SUPPLY); // Mint 1,000,000 CFT to the owner (deployer)
    }
}
