// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'hardhat/console.sol';

contract Allowance {

    struct familyMember {
        bool isParent;
        string name;
        uint balance;
        bool active;
        uint spendLimit;
        address accountNumber;
    }

    mapping (address => familyMember) familyMembers;
    address[] public familyMemberAccounts;

    // Initialize the contract, set deploying address as a parent
    constructor(string memory _name) {
        familyMember memory newFamilyMember;
        newFamilyMember.isParent = true;
        newFamilyMember.name = _name;
        newFamilyMember.balance = 0;
        newFamilyMember.active = true;
        newFamilyMember.spendLimit = 0;
        newFamilyMember.accountNumber = msg.sender;

        familyMembers[msg.sender] = newFamilyMember;
        familyMemberAccounts.push(msg.sender);
    }

    // add a family member
    function addFamilyMember(address _address, string memory _name, bool _isParent, uint _balance, bool _active, uint _spendLimit) external {
        // only a parent can add a family member
        require(familyMembers[msg.sender].isParent == true, "You are not a parent!");

        familyMember memory newFamilyMember;
        newFamilyMember.isParent = _isParent;
        newFamilyMember.name = _name;
        newFamilyMember.balance = _balance;
        newFamilyMember.active = _active;
        newFamilyMember.spendLimit = _spendLimit;
        newFamilyMember.accountNumber = _address;

        familyMembers[_address] = newFamilyMember;
        familyMemberAccounts.push(_address);
    }

    // helper function to check if a family member is mapped (exists)
    function checkFamilyMember(address _address) private view returns (bool) {
        bool familyMemberExists = false;
        if (bytes(familyMembers[_address].name).length != 0) {
            familyMemberExists = true;
        }
        return familyMemberExists;
    }

    // set family member as a parent
    function setParent(address _address) external {
        // only a parent can set another parent
        require(familyMembers[msg.sender].isParent == true, "You are not a parent!");
        // must be in family
        require(checkFamilyMember(_address), "This address is not in the family!");

        familyMember storage selectedFamilyMember = familyMembers[_address];
        selectedFamilyMember.isParent = true;
    }

    // add funds to account
    function addFunds(address _address, uint _amount) public {
        // only a parent can add funds to kid accounts
        require(familyMembers[msg.sender].isParent == true, "You are not a parent!");
        // account must be in family
        require(checkFamilyMember(_address), "This address is not in the family!");

        familyMember storage selectedFamilyMember = familyMembers[_address];
        uint newBalance = selectedFamilyMember.balance + _amount;
        selectedFamilyMember.balance = newBalance;
        
    }

    // send funds to family member
    function sendFunds(address _address, uint _amount) external {
        // make sure account is not frozen
        bool isActive = familyMembers[msg.sender].active;
        require(isActive, "Your account is frozen!");

        // check sender's spend limit
        uint sendSpendLimit = familyMembers[msg.sender].spendLimit;
        require(sendSpendLimit >= _amount, "Your spend limit is too low!");

        // make sure sender has enough funds
        uint senderBalance = familyMembers[msg.sender].balance;
        require(senderBalance >= _amount, "You do not have enough funds!");

        // update receiver's balance
        familyMember storage receivingAccount = familyMembers[_address];
        uint newReceiverBalance = receivingAccount.balance + _amount;
        receivingAccount.balance = newReceiverBalance;

        // update sender's balance
        familyMember storage senderAccount = familyMembers[_address];
        uint newSenderBalance = senderAccount.balance - _amount;
        senderAccount.balance = newSenderBalance;
    }

    // freeze account (get grounded)
    function freezeAccount(address _address) private {
        // only a parent can freeze and account
        require(familyMembers[msg.sender].isParent == true, "You are not a parent!");
        // account to freeze must be in family
        require(checkFamilyMember(_address), "This address is not in the family!");

        familyMember storage selectedFamilyMember = familyMembers[_address];
        selectedFamilyMember.active = false;
    }

    // spending limit for any single transaction
    function setSpendLimit(address _address, uint _amount) external {
        // only a parent can set the spend limit
        require(familyMembers[msg.sender].isParent == true, "You are not a parent!");
        // account must be in family
        require(checkFamilyMember(_address), "This address is not in the family!");

        familyMember storage selectedFamilyMember = familyMembers[_address];
        selectedFamilyMember.spendLimit = _amount;
    }

    // check account balance
    function checkBalance(address _address) external view returns (uint) {
        // account must be in the family
        require(checkFamilyMember(_address), "This address is not in the family!");

        familyMember storage selectedFamilyMember = familyMembers[_address];
        return selectedFamilyMember.balance;
    }
}