# ChainForgeToken (CFT) Presale Contract

This repository contains the smart contracts for the ChainForgeToken (CFT) on the Ethereum Sepolia Testnet, including the token creation, presale, and referral system.

## 1. CFT Token Creation

- **Token Name**: ChainForgeToken (CFT)
- **Total Supply**: 1,000,000 CFT
- **Decimals**: 18
- **Testnet Deployment**: BSC Testnet / Ethereum Goerli

## 2. Presale Details

- **Allocated Tokens for Presale**: 500,000 CFT (50% of total supply)
- **Price**: 1 CFT = 0.001 USDT
- **Currency Used**: USDT

## 3. Referral System

The presale contract includes a 5-level referral system that rewards users in USDT for successful referrals during the presale:

- **Level 1**: 10% of the referral's USDT contribution
- **Level 2**: 7% of the referral's USDT contribution
- **Level 3**: 5% of the referral's USDT contribution
- **Level 4**: 3% of the referral's USDT contribution
- **Level 5**: 1% of the referral's USDT contribution

## 4. Contract Functions

The contract implements the following key functions:

- **Refund Function**: If the presale does not meet the desired target or is unsuccessful, users can call this function to get a refund in USDT.
  
- **Withdraw Function**: After a successful presale, only the admin can call this function to withdraw the collected USDT from the presale.
  
- **Claim Function**: Users can claim their CFT tokens after the presale has concluded successfully.

## 5. Roles and Permissions

- **Admin**: The admin has the authority to:
  - Withdraw USDT post successful presale.
  - Monitor and manage the presale process.
  
- **Users**: Users can:
  - Participate in the presale by purchasing CFT using USDT.
  - Claim their purchased CFT tokens once the presale is complete.
  - Earn USDT rewards through the referral system.

