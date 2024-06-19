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

