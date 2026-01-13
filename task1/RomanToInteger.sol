

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RomanToInteger
 * @dev 实现标准罗马数字（1~3999）转整数，包含输入校验、Gas优化、非法字符过滤
 */
contract RomanToInteger {

    
    function romanToInt(string memory s) public pure returns (uint256) {
        bytes memory str = bytes(s);
        require(str.length > 0, "Empty string");

        uint256 total = 0;
        uint256 prev = 0;

        for (uint256 i = str.length; i > 0; i--) {
            uint256 curr = _romanValue(str[i - 1]);
            require(curr > 0, "Invalid Roman character");

            if (curr < prev) {
                total -= curr;
            } else {
                total += curr;
            }
            prev = curr;
        }

        require(total > 0 && total <= 3999, "Result out of range");
        return total;
    }

    function _romanValue(bytes1 c) internal pure returns (uint256) {
        if (c == "I") return 1;
        if (c == "V") return 5;
        if (c == "X") return 10;
        if (c == "L") return 50;
        if (c == "C") return 100;
        if (c == "D") return 500;
        if (c == "M") return 1000;
        return 0;
    }

}