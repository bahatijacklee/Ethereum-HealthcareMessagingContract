// contracts/HealthcareMessaging.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract HealthcareMessaging {
    enum Role { None, Patient, Doctor, Admin }

    struct User {
        address userAddress;
        Role role;
    }

    struct Message {
        address sender;
        address receiver;
        string content; // This should be encrypted off-chain and only decrypted client-side.
        uint256 timestamp;
    }

    mapping(address => User) public users;
    mapping(address => Message[]) public messages;

    address public admin;

    event UserRegistered(address indexed userAddress, Role role);
    event MessageSent(address indexed from, address indexed to, uint256 timestamp);

    modifier onlyAdmin() {
        require(users[msg.sender].role == Role.Admin, "Only admin can perform this action");
        _;
    }

    modifier onlyRegistered() {
        require(users[msg.sender].role != Role.None, "You must be a registered user");
        _;
    }

    constructor() {
        admin = msg.sender;
        users[admin] = User(admin, Role.Admin);
        emit UserRegistered(admin, Role.Admin);
    }

    function registerUser(address userAddress, Role role) public onlyAdmin {
        require(role != Role.None, "Invalid role");
        users[userAddress] = User(userAddress, role);
        emit UserRegistered(userAddress, role);
    }

    function sendMessage(address receiver, string memory content) public onlyRegistered {
        require(users[receiver].role != Role.None, "Receiver must be a registered user");
        messages[receiver].push(Message(msg.sender, receiver, content, block.timestamp));
        emit MessageSent(msg.sender, receiver, block.timestamp);
    }

    function getMessages() public view onlyRegistered returns (Message[] memory) {
        return messages[msg.sender];
    }
}
