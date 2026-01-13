// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ReverseString {


    function reverse(string memory input) public pure  returns (string memory resereStr) {
        bytes memory strBytes = bytes(input);
        uint len = strBytes.length;
        if (len == 0) {
            return "";            
        }

        bytes memory reversed = new bytes(len);

        for (uint i = 0; i < len; i++) {
            reversed[i] = strBytes[len - 1 - i];
        }

        return string(reversed);
    }

    
}