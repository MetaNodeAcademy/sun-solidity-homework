// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MergeSortedArray {
    
    /**
     * @dev 合并两个有序数组 (升序)
     * @param arr1 第一个有序数组
     * @param arr2 第二个有序数组
     * @return 合并后的有序数组
     */
    function merge(uint256[] memory arr1, uint256[] memory arr2) public pure returns (uint256[] memory) {
        uint256 len1 = arr1.length;
        uint256 len2 = arr2.length;
        
        // 1. Gas 优化关键点：
        // 提前申请好精确大小的内存空间 (len1 + len2)
        // 避免在循环中使用 push()，因为 push() 会触发多次内存扩容，非常昂贵
        uint256[] memory result = new uint256[](len1 + len2);
        
        uint256 i = 0; // arr1 的指针
        uint256 j = 0; // arr2 的指针
        uint256 k = 0; // result 的指针

        // 2. 双指针遍历比较
        // 只要两个数组都还有元素，就进行比较
        while (i < len1 && j < len2) {
            if (arr1[i] <= arr2[j]) {
                result[k] = arr1[i];
                i++;
            } else {
                result[k] = arr2[j];
                j++;
            }
            k++;
        }

        // 3. 处理剩余元素
        // 如果 arr1 还有剩余元素，直接复制过去
        while (i < len1) {
            result[k] = arr1[i];
            i++;
            k++;
        }

        // 如果 arr2 还有剩余元素，直接复制过去
        while (j < len2) {
            result[k] = arr2[j];
            j++;
            k++;
        }

        return result;
    }
}
