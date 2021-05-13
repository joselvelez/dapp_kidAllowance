// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import 'hardhat/console.sol';

contract Allowance {

    struct familyMember {
        string familyName;
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
    constructor(string memory _name, string memory _familyName) {
        familyMember memory newFamilyMember;
        newFamilyMember.familyName = _familyName;
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
    function addFamilyMember(address _address, string memory _name) external {
        // only a parent can add a family member
        require(familyMembers[msg.sender].isParent == true, "You are not a parent!");
        // name must be provided
        require(bytes(_name).length > 0, "Cannot leave name blank!");

        familyMember memory newFamilyMember;
        newFamilyMember.isParent = false;
        newFamilyMember.name = _name;
        newFamilyMember.familyName = familyMembers[msg.sender].familyName;
        newFamilyMember.balance = 0;
        newFamilyMember.active = true;
        newFamilyMember.spendLimit = 100;
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

    // set family name
    function setFamilyName(string memory _familyName) external {
        // only a parent can set the family name
        require(familyMembers[msg.sender].isParent == true, "You are not a parent!");

        familyMember storage selectedFamilyMember = familyMembers[msg.sender];
        selectedFamilyMember.familyName = _familyName;

        for (uint i=0; i < familyMemberAccounts.length; i++) {
            // this is not gas efficient, but this is just for experimenting
            familyMembers[familyMemberAccounts[i]].familyName = _familyName;
        }
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

    // check account status
    function getAccountStatus(address _address) external view returns (bool) {
        // account must be in the family
        require(checkFamilyMember(_address), "This address is not in the family!");

        familyMember storage selectedFamilyMember = familyMembers[_address];
        return selectedFamilyMember.active;
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

    // check spending limit
    function getSpendLimit(address _address) external view returns (uint) {
        // account must be in the family
        require(checkFamilyMember(_address), "This address is not in the family!");

        familyMember storage selectedFamilyMember = familyMembers[_address];
        return selectedFamilyMember.spendLimit;
    }

    // check account balance
    function checkBalance(address _address) external view returns (uint) {
        // account must be in the family
        require(checkFamilyMember(_address), "This address is not in the family!");

        familyMember storage selectedFamilyMember = familyMembers[_address];
        return selectedFamilyMember.balance;
    }

    // get family name
    function getFamilyName(address _address) public view returns (string memory) {
        if (bytes(familyMembers[_address].familyName).length > 0) {
            return familyMembers[_address].familyName;
        } else {
            return "no family found!";
        }
    }
}