// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {console} from "../lib/forge-std/src/Test.sol";

error MyERC20__transferFailedForInsufficientFund();
error MyERC20__transferFailedforLackOfAllowance();

contract MyERC20 {
    address immutable s_owner;
    mapping(address => uint256) s_balance;
    mapping(address => mapping(address => uint256)) s_allowance;

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );

    constructor() {
        s_owner = msg.sender;
        s_balance[s_owner] = totalSupply();
        console.log("MyERC20 deployed by", s_owner);
    }

    function mint(uint256 _value) public {
        s_balance[msg.sender] += _value;
    }

    function name() public pure returns (string memory) {
        return "myERC20";
    }

    function symbol() public pure returns (string memory) {
        return "myERC20";
    }

    function decimals() public pure returns (uint8) {
        return 18;
    }

    function totalSupply() public pure returns (uint256) {
        return 1000 ether;
    }

    function balanceOf(address _owner) public view returns (uint256 balance) {
        return s_balance[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public returns (bool success) {
        if (s_balance[msg.sender] < _value) {
            revert MyERC20__transferFailedForInsufficientFund();
        }
        s_balance[msg.sender] -= _value;
        s_balance[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public returns (bool success) {
        if (s_allowance[_from][msg.sender] < _value) {
            revert MyERC20__transferFailedforLackOfAllowance();
        }
        if (s_balance[_from] < _value) {
            revert MyERC20__transferFailedForInsufficientFund();
        }
        s_balance[_from] -= _value;
        s_balance[_to] += _value;
        s_allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public returns (bool success) {
        s_allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function increaseAllowance(
        address _spender,
        uint256 _addedValue
    ) public returns (bool success) {
        s_allowance[msg.sender][_spender] += _addedValue;
        emit Approval(msg.sender, _spender, s_allowance[msg.sender][_spender]);
        return true;
    }

    function decreaseAllowance(
        address _spender,
        uint256 _subtractedValue
    ) public returns (bool success) {
        if (s_allowance[msg.sender][_spender] < _subtractedValue) {
            s_allowance[msg.sender][_spender] = 0;
        } else {
            s_allowance[msg.sender][_spender] -= _subtractedValue;
        }
        emit Approval(msg.sender, _spender, s_allowance[msg.sender][_spender]);
        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view returns (uint256 remaining) {
        return s_allowance[_owner][_spender];
    }
}
