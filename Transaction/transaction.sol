// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MultiSigWallet {
    address[] public owners;
    uint public required;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint approvalCount;
    }

    mapping(address => bool) public isOwner;
    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) public approvals;

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier txExists(uint _txIndex) {
        require(_txIndex < transactions.length, "Transaction does not exist");
        _;
    }

    modifier notApproved(uint _txIndex) {
        require(!approvals[_txIndex][msg.sender], "Transaction already approved by you");
        _;
    }

    modifier notExecuted(uint _txIndex) {
        require(!transactions[_txIndex].executed, "Transaction already executed");
        _;
    }

    constructor(address[] memory _owners, uint _required) {
        require(_owners.length > 0, "Owners required");
        require(_required > 0 && _required <= _owners.length, "Invalid required number");

        for (uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];
            require(owner != address(0), "Invalid owner");
            require(!isOwner[owner], "Owner is not unique");

            isOwner[owner] = true;
            owners.push(owner);
        }

        required = _required;
    }

    receive() external payable {}

    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        transactions.push(Transaction({
            to: _to,
            value: _value,
            data: _data,
            executed: false,
            approvalCount: 0
        }));
    }

    function approveTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notApproved(_txIndex) notExecuted(_txIndex){
        approvals[_txIndex][msg.sender] = true;
        transactions[_txIndex].approvalCount += 1;
    }

    function executeTransaction(uint _txIndex) public onlyOwner txExists(_txIndex) notExecuted(_txIndex){
        Transaction storage txn = transactions[_txIndex];
        require(txn.approvalCount >= required, "Not enough approvals");

        txn.executed = true;

        (bool success, ) = txn.to.call{value: txn.value}(txn.data);
        require(success, "Transaction failed");
    }

    function getTransactionCount() public view returns (uint) {
        return transactions.length;
    }

    function getTransaction(uint _txIndex) public view returns (
            address to,
            uint value,
            bytes memory data,
            bool executed,
            uint approvalCount
        )
    {
        Transaction memory txn = transactions[_txIndex];
        return (txn.to, txn.value, txn.data, txn.executed, txn.approvalCount);
    }
}
