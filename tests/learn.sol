

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ArrayQuickDelete {
    // 定义一个uint类型的数组（初始值设为[1,2,3,4,5]）
    uint[] public arr = [1, 2, 3, 4, 5];

    // 快速删除：参数是要删除的元素索引
    function deleteByQuick(uint index) public {
        // 先校验索引合法性（避免越界）
        require(index < arr.length, "Index out of bounds");
        
        // 步骤1：将“要删除的索引位置”替换为“数组最后一个元素”
        arr[index] = arr[arr.length - 1];
        // 步骤2：删除数组最后一个元素（pop）
        arr.pop();
    }

    // 辅助函数：获取当前数组（方便查看结果）
    function getArray() public view returns (uint[] memory) {
        return arr;
    }
}