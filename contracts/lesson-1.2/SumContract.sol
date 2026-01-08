// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SumContract {

    //memory测试
    function getSumMemory(uint[] memory data) public pure returns (uint) {
        uint sum = 0;
        uint length = data.length;
        for(uint i = 0; i < length; i++) {
            sum += data[i];
        }
        return sum;
    }

    //calldata测试
    function getSumCalldata(uint[] calldata data) public pure returns (uint) {
        uint sum = 0;
        uint length = data.length;
        for(uint i = 0; i < length; i++) {
            sum += data[i];
        }
        return sum;
    }
}