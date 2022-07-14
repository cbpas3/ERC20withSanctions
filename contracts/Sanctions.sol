// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;


interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address receipient, uint amount) external returns (bool);

    function allowance(address owner, address spender)
        external
        view
        returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint amount);

    event Approval(address indexed owner, address indexed spender, uint amount);
}

contract Sanctions is IERC20 {
    uint public totalSupply;
    mapping(address => uint) public balanceOf;
    mapping(address => mapping(address => uint)) public allowance;
    mapping(address => bool) private _blacklist;

    string public name = "Test";
    string public symbol = "TEST";
    uint8 public decimals = 18; // how many zeros are used to represent one token
    address private specialAddress = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    function transfer(address recipient, uint amount) external returns (bool){
        require(! _blacklist[msg.sender] && ! _blacklist[recipient], "You or the address you are sending to are or is blacklisted");
        balanceOf[msg.sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }



    function approve(address spender, uint amount) external returns (bool){
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender,spender,amount);
        return true;
    }

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool){
        allowance[sender][msg.sender] -= amount;
        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
        return true;
    }

    function addToBlackList(
        address toBeBlacklisted
    ) external returns (bool){
        require(msg.sender == specialAddress, "Not authorized address");
        _blacklist[toBeBlacklisted] = true;
        return true;
    }

    function removeFromBlackList(
        address toBeBlacklisted
    ) external returns (bool){
        require(msg.sender == specialAddress, "Not authorized address");
        _blacklist[toBeBlacklisted] = false;
        return true;
    }




}