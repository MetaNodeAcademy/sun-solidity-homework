// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; // 0.8+自带溢出检查，无需额外处理

/**
 * @title IntegerToRoman
 * @dev 实现1~3999范围内的整数转罗马数字，包含输入验证、Gas优化
 */
contract IntegerToRoman {
 

    function intToRoman(uint256 num) public pure returns (string memory) {
        require(num > 0 && num <= 3999, "Number out of range");

        uint256[13] memory values = [
            uint256(1000),
            900,
            500,
            400,
            100,
            90,
            50,
            40,
            10,
            9,
            5,
            4,
            1
        ];

        string[13] memory symbols = [
            "M",
            "CM",
            "D",
            "CD",
            "C",
            "XC",
            "L",
            "XL",
            "X",
            "IX",
            "V",
            "IV",
            "I"
        ];

        bytes memory result;

        for (uint256 i = 0; i < values.length; i++) {
            while (num >= values[i]) {
                num -= values[i];
                result = abi.encodePacked(result, symbols[i]);
            }
        }

        return string(result);
    }


}