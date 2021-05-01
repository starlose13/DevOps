// SPDX-License-Identifier: GPL-3.0
pragma experimental ABIEncoderV2;
pragma solidity >=0.6.0 <0.8.0;
import "./ERC20.sol";
// Initiate Biobit Token With 200M Total Supply And Set Name, Symbol

contract sharetx is ERC20 {
    IERC20 private token;
    address payable public owner;
    constructor(IERC20 BioBit)ERC20("BioBit","BBit")  public {
        owner = msg.sender;
        _totalSupply = 200000000;
        _balances[owner] = _totalSupply;
        token = BioBit;
    }
    address payable[] public contributers;
    uint[]public values;
    uint date =  block.timestamp;
    struct user{
        address user_address;
        string EEG_Signal;
        uint value_tx_in_ether;
    }
    mapping (uint => user)public user_map;
    function ConnectToZarela(string memory EEG ,uint how_much_tx_fee)public payable {
        require(msg.value == how_much_tx_fee/10);
        contributers.push(msg.sender);
        uint id = contributers.length - 1;
        user_map[id].user_address = msg.sender;
        user_map[id].EEG_Signal =  EEG;
        user_map[id].value_tx_in_ether = how_much_tx_fee;
        values.push(how_much_tx_fee/10);
        if(id == 2){
           AverageTxFee(); 
        }
    }
    function AverageTxFee()internal{
        uint sum ;
        for(uint i; i< values.length;i++){
            sum = values[i] + sum;
        }
        uint average =  (sum / values.length);
        reward(average);
    }
    
    function reward(uint averages)internal{
        require(_balances[address(this)]>=averages);
        _balances[address(this)] = _balances[address(this)] - averages;
        
        for (uint i ; i<contributers.length;i++){
            _balances[contributers[i]] = _balances[contributers[i]] + (averages/contributers.length);
        }            
        
        for(uint i; i< contributers.length;i++){
            contributers[i].transfer(values[i]);
        }
        delete(contributers);
        delete(values);
    }
    
   
}