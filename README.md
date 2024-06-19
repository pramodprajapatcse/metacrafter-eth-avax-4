# GamerTokens

A simple smart contract for managing an ERC20-like token with additional functionality for minting, burning, and redeeming rewards.

## Description

GamerTokens is a Solidity-based smart contract that enables the creation and management of an in-game token called "Degen" (DGN). This contract allows the owner to mint new tokens, users to transfer and burn tokens, check balances, and redeem tokens for predefined rewards. It is designed for use in gaming ecosystems where tokens can represent in-game currency or assets.

## Getting Started

### Installing

To install and deploy the GamerTokens contract, follow these steps:

1. **Download the Contract:**
   - Clone the repository to your local machine:
     ```
     git clone https://github.com/your-username/GamerTokens.git
     ```
   - Navigate to the contract directory:
     ```
     cd GamerTokens
     ```

2. **Modify Contract (if necessary):**
   - Open `GamerTokens.sol` and modify any parameters or initial values as needed.

### Executing program

To deploy and interact with the GamerTokens contract, follow these steps:

1. **Compile the Contract:**
   - Use a Solidity compiler (e.g., Remix, Hardhat, Truffle) to compile `GamerTokens.sol`.

2. **Deploy the Contract:**
   - Deploy the contract using a tool like Remix or via a script if using Hardhat or Truffle.
   - Ensure you have a funded Ethereum account for deployment.

3. **Interact with the Contract:**
   - Use the deployed contract's address to interact with it via your preferred Ethereum wallet or integration tool.
   
   Example commands for interacting with the contract:
   ```
   // Mint tokens (only owner)
   mintTokens(amount, recipient_address);

   // Transfer tokens
   transferTokens(amount, recipient_address);

   // Burn tokens
   burnTokens(amount);

   // Check balance
   checkBalance(address);

   // Redeem reward
   redeemReward(rewardId);
   ```

## Help

If you encounter any issues or have questions, here are some common troubleshooting steps:

- Ensure your Ethereum wallet is connected to the correct network.
- Verify that you have sufficient funds (ETH) for gas fees.
- Double-check the contract address and parameters used in transactions.

For detailed help, run:
```
help
```

## Authors

Contributors names and contact info:

- Pramod Prajapat

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.

```solidity
// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract GamerTokens {

    address public owner;
    
    // Token details
    string public tokenName = "Degen";
    string public symbol = "DGN";
    uint public totalSupply = 0;
   
    // Constructor to set the contract deployer as the owner and initialize some rewards
    constructor() {
        owner = msg.sender;
        rewards[0] = Reward("Platinum Shield", 10);
        rewards[1] = Reward("Magic Wand", 15);
        rewards[2] = Reward("Player Title", 20);
    }
    
    // Modifier to allow only the owner to perform certain actions
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the contract owner can perform this action");
        _;
    }
    
    // Mapping addresses to their token balances and reward structures
    mapping(address => uint256) private balances;
    mapping(uint256 => Reward) public rewards;
    
    struct Reward {
        string name;
        uint256 cost;
    }

    // Functions for minting, transferring, burning tokens, checking balance, and redeeming rewards
    
    // Function to mint new tokens, only accessible by the owner
    function mintTokens(uint256 amount, address to) external onlyOwner {
        require(amount > 0, "Minting amount must be greater than zero");
        totalSupply += amount;
        balances[to] += amount;
    }

    // Function to transfer tokens from the sender to another address
    function transferTokens(uint256 amount, address to) external {
        require(amount <= balances[msg.sender], "Insufficient balance for transfer");
        balances[to] += amount;
        balances[msg.sender] -= amount;
    }

    // Function to burn tokens, reducing the sender's balance
    function burnTokens(uint256 amount) external {
        require(amount <= balances[msg.sender], "Insufficient balance to burn");
        balances[msg.sender] -= amount;
        totalSupply -= amount;
    }

    // Function to check the token balance of a given address
    function checkBalance(address account) external view returns (uint256) {
        return balances[account];
    }

    // Function to redeem rewards using tokens, reducing the sender's balance
    function redeemReward(uint256 rewardId) external returns (string memory) {
        require(rewardId < 3, "Invalid reward ID");
        require(rewards[rewardId].cost <= balances[msg.sender], "Insufficient balance to redeem reward");
        balances[msg.sender] -= rewards[rewardId].cost;
        return rewards[rewardId].name;
    }
}
```
