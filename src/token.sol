// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TokenSimple {
    // Token Identity
    string public title;
    string public emblem;
    uint8 public points;
    uint256 public totalAmount;

    // Holder balances and permissions
    mapping(address => uint256) public quantityOfTokens;
    mapping(address => mapping(address => uint256)) public grantPermission;

    // Occurrences for transactions and status alterations
    event Relocation(address indexed startingPoint, address indexed destination, uint256 amount);
    event PermissionGranted(address indexed holder, address indexed recipient, uint256 amount);
    event Elimination(address indexed startingPoint, uint256 amountEliminated);
    event CashOut(address indexed startingPoint, uint256 amountCashOut);
    event Ingress(address indexed destination, uint256 amountIngressed);

    // Builder for initiating the token
    constructor(
        string memory _title,
        string memory _emblem,
        uint8 _points,
        uint256 _commencementSupply
    ) {
        title = _title;
        emblem = _emblem;
        points = _points;
        totalAmount = _commencementSupply * (10**uint256(points));

        // Set the opening balance for the progenitor of the contract
        quantityOfTokens[msg.sender] = totalAmount;

        // Emit a Relocation event to document the initial supply transfer
        emit Relocation(address(0), msg.sender, totalAmount);
    }

    // Transmit tokens to a designated location
    function send(address to, uint256 amount) public returns (bool accomplishment) {
        require(quantityOfTokens[msg.sender] >= amount, "Insufficient balance");

        // Adjust balances accordingly
        quantityOfTokens[msg.sender] -= amount;
        quantityOfTokens[to] += amount;

        // Emit a Relocation event to denote the relocation
        emit Relocation(msg.sender, to, amount);

        return true;
    }

    // Accord spending approval to another address
    function authorize(address recipient, uint256 amount) public returns (bool accomplishment) {
        // Set the spending sanction for the specified address
        grantPermission[msg.sender][recipient] = amount;

        // Emit a PermissionGranted event to document the approval
        emit PermissionGranted(msg.sender, recipient, amount);

        return true;
    }

    // Transfer tokens from one address to another using a formerly authorized sanction
    function sendFrom(address startingPoint, address destination, uint256 amount) public returns (bool accomplishment) {
        require(quantityOfTokens[startingPoint] >= amount, "Insufficient balance");
        require(grantPermission[startingPoint][msg.sender] >= amount, "Insufficient approval");

        // Update balances and diminish the spending approval
        quantityOfTokens[startingPoint] -= amount;
        quantityOfTokens[destination] += amount;
        grantPermission[startingPoint][msg.sender] -= amount;

        // Emit a Relocation event to signify the transfer
        emit Relocation(startingPoint, destination, amount);

        return true;
    }

    // Eradicate a specified quantity of tokens
    function eliminate(uint256 amount) public returns (bool accomplishment) {
        require(quantityOfTokens[msg.sender] >= amount, "Insufficient balance");

        // Diminish the balance and the total supply
        quantityOfTokens[msg.sender] -= amount;
        totalAmount -= amount;

        // Emit an Elimination event to denote the token elimination
        emit Elimination(msg.sender, amount);

        return true;
    }

    // Extract tokens from the contract
    function cashOut(uint256 amount) public returns (bool accomplishment) {
        require(quantityOfTokens[msg.sender] >= amount, "Insufficient balance for withdrawal");

        // Diminish the balance and emit a CashOut event
        quantityOfTokens[msg.sender] -= amount;
        emit CashOut(msg.sender, amount);

        return true;
    }

    // Ingress tokens into the contract
    function ingress(uint256 amount) public returns (bool accomplishment) {
        // Augment the balance and emit an Ingress event
        quantityOfTokens[msg.sender] += amount;
        emit Ingress(msg.sender, amount);

        return true;
    }
}
