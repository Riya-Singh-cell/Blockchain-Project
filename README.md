# Blockchain-Project
#  MultiSig Wallet Smart Contract

A simple yet functional Multi-Signature Wallet written in Solidity. This contract allows multiple owners to collectively approve and execute transactions, enhancing security and decentralization.

---

##  Overview

This MultiSig Wallet contract allows:
- Multiple owners to be set at deployment.
- A defined number of confirmations required to approve a transaction.
- Transactions to be submitted, approved, and executed only after reaching the required number of approvals.

---

##  Features

- Add multiple wallet owners at deployment
- Submit new transactions
- Approve transactions individually by owners
- Execute transactions only after required approvals
- View transaction count and details

---

## How It Works

1. **Owners are initialized** via the constructor with a specified `required` number of approvals.
2. **A transaction** is submitted using `submitTransaction()`.
3. **Owners can approve** the transaction with `approveTransaction()`.
4. Once approvals reach the required threshold, anyone can call `executeTransaction()` to send the Ether and execute the data payload.

---

##  Functions

### `constructor(address[] _owners, uint _required)`
Initializes the contract with a list of owners and required approval count.

### `submitTransaction(address _to, uint _value, bytes memory _data)`
Adds a new transaction for approval.

### `approveTransaction(uint _txIndex)`
Approves a transaction by the caller (must be an owner).

### `executeTransaction(uint _txIndex)`
Executes a transaction once enough approvals are collected.

### `getTransactionCount()`
Returns the total number of transactions submitted.

### `getTransaction(uint _txIndex)`
Returns the details of a specific transaction.

---

##  Sample Deployment

```solidity
// Owners: [0x123..., 0x456...]
// Required approvals: 2
MultiSigWallet wallet = new MultiSigWallet([owner1, owner2, owner3], 2);
