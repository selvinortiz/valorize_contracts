//SPDX-License-Identifier: Unlicense

pragma solidity 0.8.6;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
/**
 * @title ERC20TimedMint
 * @author Javier Gonzalez and Marco Huberts
 * @dev Implementation of minting functionality for a mintable token.
 * @notice ERC20TimedMint inherits the ERC20 functionality and prevents 
  *         minting within a timeframe.
  */
contract ERC20TimedMint is ERC20 {

    uint256 public timeUntilNextMint;
    uint256 public claimPeriod;
    uint256 private mintCap;

    event Claim(address claimant, uint256 amount);
    
    constructor (
        string memory name,
        string memory symbol,
        uint256 _mintCap,
        uint256 _timeDelay
    )   
        ERC20(name, symbol) 
    {
        timeUntilNextMint = block.timestamp + _timeDelay;
        mintCap = _mintCap;
    }

    function claimTokens (
        uint256 amount, 
        address _receiver
    ) 
        external 
    {
        require(_receiver == msg.sender); 
        _transfer(address(this), msg.sender, amount);
        emit Claim(msg.sender, amount);
    }

    function _mint(address to, uint256 amount)
        internal
        override(ERC20)
    {
        require(block.timestamp >= timeUntilNextMint, "ERC20: Cannot mint yet");
        require(amount <= mintCap, "ERC20: Mint exceeds maximum amount");
        super._mint(to, amount);
    }
}


