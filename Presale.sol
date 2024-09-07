// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Presale is Ownable {
    IERC20 public token; // ChainForgeToken (CFT)
    IERC20 public usdt;  // USDT token contract
    uint256 public constant TOKEN_PRICE = 0.001 * 10**18; // 0.001 USDT per CFT
    uint256 public constant TOKENS_FOR_SALE = 500000 * 10**18; // 500,000 CFT for presale

    bool public presaleActive = true;
    mapping(address => uint256) public contributions;
    mapping(address => uint256) public claimedTokens;

    // Referral system reward percentages
    uint8[] public referralRewards = [10, 7, 5, 3, 1]; // Level 1 to Level 5

    // Keep track of referrals
    mapping(address => address) public referrerOf;

    event TokensPurchased(address indexed buyer, uint256 amount, address indexed referrer);
    event RefundIssued(address indexed user, uint256 amount);
    event TokensClaimed(address indexed user, uint256 amount);

    // Constructor that takes in the addresses of the CFT and USDT contracts
    constructor(IERC20 _token, IERC20 _usdt) Ownable(msg.sender) {
        token = _token;
        usdt = _usdt;
    }

    function buyTokens(uint256 usdtAmount, address referrer) external {
        require(presaleActive, "Presale is not active");
        uint256 tokenAmount = usdtAmount / TOKEN_PRICE; // Calculate how many tokens the user is buying
        require(tokenAmount > 0 && tokenAmount <= TOKENS_FOR_SALE, "Invalid token amount");

        // Transfer USDT from the buyer to the contract
        require(usdt.transferFrom(msg.sender, address(this), usdtAmount), "USDT transfer failed");

        // Record the contribution
        contributions[msg.sender] += tokenAmount;

        // Handle referrals
        if (referrer != address(0) && referrer != msg.sender) {
            referrerOf[msg.sender] = referrer;
            _handleReferralRewards(usdtAmount, referrer);
        }

        emit TokensPurchased(msg.sender, tokenAmount, referrer);
    }

    function _handleReferralRewards(uint256 usdtAmount, address referrer) internal {
        for (uint8 i = 0; i < referralRewards.length; i++) {
            if (referrer == address(0)) break; // Stop if there is no more referrer in the chain
            uint256 reward = (usdtAmount * referralRewards[i]) / 100; // Calculate the reward in USDT
            usdt.transfer(referrer, reward); // Send reward
            referrer = referrerOf[referrer]; // Move up the chain
        }
    }

    // Refund Function if presale fails
    function refund() external {
        require(!presaleActive, "Presale is still active");
        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No contribution to refund");

        contributions[msg.sender] = 0; // Reset contribution
        usdt.transfer(msg.sender, amount * TOKEN_PRICE); // Refund USDT to the user
        emit RefundIssued(msg.sender, amount);
    }

    // Withdraw USDT (admin-only)
    function withdrawUSDT() external onlyOwner {
        require(!presaleActive, "Presale is still active");
        uint256 balance = usdt.balanceOf(address(this));
        require(balance > 0, "No USDT to withdraw");
        usdt.transfer(owner(), balance); // Admin withdraws all USDT
    }

    // Claim CFT tokens after presale
    function claimTokens() external {
        require(!presaleActive, "Presale is still active");
        uint256 amount = contributions[msg.sender];
        require(amount > 0, "No tokens to claim");

        contributions[msg.sender] = 0; // Reset contribution after claiming
        claimedTokens[msg.sender] += amount; // Record claimed tokens
        token.transfer(msg.sender, amount); // Transfer CFT tokens to the user

        emit TokensClaimed(msg.sender, amount);
    }

    // End the presale
    function endPresale() external onlyOwner {
        presaleActive = false;
    }
}
