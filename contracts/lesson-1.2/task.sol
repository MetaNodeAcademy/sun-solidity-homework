// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0 <0.9.0;

contract Task {
    uint[] public data;

    // 这个函数有很多优化空间
    // function processData(uint[] memory input) public {
    //     delete data;  // 清空数组
    //     for(uint i = 0; i < input.length; i++) {
    //         data.push(input[i] * 2);
    //     }
    // }


    //优化后
    function processData(uint[] memory input) public {
        delete data;  // 清空数组
        uint length = input.length;
        uint[] memory tempData = new uint[](length);
        for(uint i = 0; i < length; i++) {
            // data.push(input[i] * 2);
            // tempData.push(input[i]);
            tempData[i] = input[i];
        }
        data = tempData;
    }

    // 这个函数也可以优化
    // function getSum() public view returns (uint) {
    //     uint sum = 0;
    //     for(uint i = 0; i < data.length; i++) {
    //         sum += data[i];
    //     }
    //     return sum;
    // }


    // // 优化后的
    function getSum() public view returns (uint) {
        uint  sum = 0;
        uint256 length=data.length;
        for(uint i = 0; i < length; i++) {
            sum += data[i];
        }
        return sum;
    }
}