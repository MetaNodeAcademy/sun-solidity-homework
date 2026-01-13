// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BinarySearch {
    
    /**
     * @notice 在有序数组中查找目标值是否存在
     * @dev 使用 memory 参数，避免昂贵的存储读写
     * @param arr 升序排列的无符号整数数组
     * @param target 要查找的目标值
     * @return 如果找到返回 true，否则返回 false
     */
    function binarySearch(uint256[] memory arr, uint256 target) public pure returns (bool) {
        // 1. 安全性检查：空数组直接返回
        if (arr.length == 0) {
            return false;
        }

        uint256 left = 0;
        uint256 right = arr.length - 1;

        while (left <= right) {
            // 2. 安全性优化：计算中间值
            // 使用 left + (right - left) / 2 而不是 (left + right) / 2
            // 虽然在 Solidity 0.8.0+ 中加法溢出会自动 revert，但前者是业界标准安全写法，且在某些老版本或特定上下文更安全
            uint256 mid = left + (right - left) / 2;

            if (arr[mid] == target) {
                return true; // 找到目标
            }

            if (arr[mid] > target) {
                // 3. 安全性处理：防止 uint256 下溢
                // 在 Solidity 0.8.0+ 中，mid = 0 时执行 mid - 1 会触发 Panic 错误（算术下溢）
                // 逻辑上，如果 mid 为 0 且 arr[0] > target，说明 target 比数组最小值还小，直接结束查找即可
                if (mid == 0) {
                    return false;
                }
                right = mid - 1;
            } else {
                left = mid + 1;
            }
        }

        return false;
    }
}
