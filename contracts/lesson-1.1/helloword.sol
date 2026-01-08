// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0 <0.9.0;

contract HelloWorld {

    string public message;
    address public owner; // 添加状态变量

    constructor() {
        message = "Hello, Solidity!";
        owner = msg.sender; // 在构造函数中初始化
    }

    function updateMessage(string memory _newMessage) public {
        message = _newMessage;
    }

    function getMessage() public view returns (string memory) {
        return message;
    }

    function getOwner() public view returns (address) { // 添加函数
        return owner;
    }
}