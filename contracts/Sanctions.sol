// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.0/token/ERC20/ERC20.sol";

contract CysToken is ERC20 {
    address _admin;
    mapping(address => bool) public _blacklist; 

    modifier onlyAdmin {
      require(msg.sender == _admin, "CysToken: Not authorized to call this function.");
      _;
    }

    constructor() ERC20("CysToken", "CYT") {
        _mint(msg.sender, 100000 * 10 ** decimals());
        _admin = msg.sender;
    }

    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal virtual override
    {
        super._beforeTokenTransfer(from, to, amount);

        require(! _blacklist[msg.sender] && ! _blacklist[to], "CysToken: You or the address you are sending to are or is blacklisted");
    }


    function addToBlackList(
        address toBeBlacklisted
    ) external onlyAdmin returns (bool){
        _blacklist[toBeBlacklisted] = true;
        return true;
    }

    function removeFromBlackList(
        address toBeBlacklisted
    ) external onlyAdmin returns (bool){
        _blacklist[toBeBlacklisted] = false;
        return true;
    }

}
