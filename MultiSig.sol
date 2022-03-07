// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.7.5;
pragma abicoder v2;

import "./ownersOnly.sol";

contract wallet is ownersOnly {

    uint approvalsNeeded;

    struct Transfer {
        uint id;
        uint amount;
        address payable _to;
        bool isApproved;
        uint signatures;
    }

    Transfer[] transferRequests;
    
    mapping(address => uint) balance;
    mapping(address => mapping(uint=> bool)) approvals;
    
    event depositMade(uint amount, address indexed account);
    event transferSuccesful(address from, address to, uint amount);
    event transferCreated(address from, address to, uint amount);
    event transferApproved(address from, address to, uint amount, uint signaturesStillRequired);

    constructor (address[] memory _owners, uint _approvals) {
        owners = _owners;
        approvalsNeeded = _approvals;
    }

    function deposit() public payable returns (uint) {
        balance[msg.sender] += msg.value;
        emit depositMade(msg.value, msg.sender);
        return balance[msg.sender];
    }
    
    function transferRequest(uint _amount, address payable _receiver) public onlyOwners {
        require(balance[msg.sender] >= _amount, "you don't have enough balance");
        transferRequests.push(
            Transfer(transferRequests.length, _amount, _receiver, false, 0)
        );
        emit transferCreated (msg.sender, _receiver, _amount);
    }

    function getTransferRequests() public view returns (Transfer[] memory) {
        return (transferRequests);
    }

    function approveTransfer(uint _id) public onlyOwners {
        require (transferRequests[_id].isApproved == false, "transaction already approved");
        require (approvals[msg.sender][_id] == false, "you already approved this transaction");

        transferRequests[_id].signatures ++;
        approvals[msg.sender][_id] == true;
        emit transferApproved (msg.sender, transferRequests[_id]._to, transferRequests[_id].amount, (approvalsNeeded - transferRequests[_id].signatures));
        
        if (transferRequests[_id].signatures >= approvalsNeeded) {
            transferRequests[_id].isApproved == true;
            transferRequests[_id]._to.transfer(transferRequests[_id].amount);
            balance[msg.sender] -= transferRequests[_id].amount;
            emit transferSuccesful(msg.sender, transferRequests[_id]._to, transferRequests[_id].amount);
        }
    }

    function getBalance() public view returns(uint) {
        return balance[msg.sender];
    }

    function contractBalance() public view returns (uint) {
        return address(this).balance;
    }
    
}
