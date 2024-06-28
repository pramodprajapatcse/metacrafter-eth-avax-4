// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract Degen_Gaming{

    address public commandCenter;
    
    //token details
    string public TokenName ="Degen";
    string public Symbol ="DGN";
    uint public Supply =0;
    
    //Initiate a constructor
    constructor(){
       commandCenter =msg.sender;
       Reward[0]=NFT("Emerald Boots",2);
       Reward[1]=NFT("Emerald Sword",3);
       Reward[2]=NFT("Identity Change Card",5);
    }
    
    //Modifier to allow only owner to mint the tokens
    modifier ownerOnly() {
        require(msg.sender == commandCenter, "Command center has rights to mint new token");
        _;
    }
    
    //Mapping the address with their respective balance and NFT with the reward
    mapping(address => uint256) private balance;
    mapping(uint256 => NFT) public Reward;
    mapping(address => string[]) public redeemedItems;
    
    struct NFT {
        string name;
        uint256 price;
    }

    //Functions to mint, transfer, burn, Check balance and for redeem rewards
    //For extra functionality, in this smart contract I add require statements.

    function mint(uint amount , address receiver_address) ownerOnly external {
        require(amount>0,"Minting amount should be greater than 0");
        Supply=Supply+amount;
        balance[receiver_address]=balance[receiver_address]+amount;
    }


    function transfer(uint amount, address receiver_address) external{
        require(amount<=balance[msg.sender],"Amount should be less than the sender's balance");
        balance[receiver_address] = balance[receiver_address]+amount;
        balance[msg.sender]=balance[msg.sender]-amount;
    }


    function burn(uint amount) external{
        require(amount<=balance[msg.sender],"Amount should not exceed balance");

        balance[msg.sender]=balance[msg.sender]-amount;
    }


    function Check_Balanace(address user_address) external view returns(uint){
        return(balance[user_address]);
    }


    function redeem(uint reward_ID) external returns (string memory){
        require(Reward[reward_ID].price <= balance[msg.sender],"Insufficient Balance");
        if(reward_ID != 0 && reward_ID != 1 && reward_ID != 2){
        revert("Invalid reward ID");
    }
        redeemedItems[msg.sender].push(Reward[reward_ID].name);
        balance[msg.sender]= balance[msg.sender]-Reward[reward_ID].price;
        return Reward[reward_ID].name;
    }

     function getRedeemedItems(address user) external view returns (string[] memory) {
        return redeemedItems[user];
    }
}
      
