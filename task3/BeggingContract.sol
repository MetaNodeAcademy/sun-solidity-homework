// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BeggingContract {
    address public owner;
    // 记录每个捐赠者的捐赠金额
    mapping(address => uint256) public donations;

    // --- 优化点 1: 事件 ---
    // 使用 Event 记录数据比使用 Storage (存储变量) 便宜得多。
    // 同时 Event 方便在 Etherscan 等链上浏览器追踪。
    event DonationReceived(address indexed donor, uint256 amount);
    event Withdrawn(address indexed to, uint256 amount);

    constructor() {
        owner = msg.sender;
    }

    // --- 安全点 1: 修饰符优化 ---
    // 使用 _; 占位符，确保只有 owner 才能执行后续逻辑
    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthorized: Not the owner");
        _;
    }

    // --- 优化点 2: external vs public ---
    // 使用 external 代替 public。
    // public 函数可以被内部或外部调用，会生成额外的代码以适配内部调用。
    // external 只能被外部调用，省去了这步适配，Gas 更省。
    function donate() external payable {
        require(msg.value > 0, "Send some ETH");

        // 更新状态变量
        donations[msg.sender] += msg.value;

        // 触发事件记录日志
        emit DonationReceived(msg.sender, msg.value);
    }

    // --- 安全点 2: 提款安全优化 ---
    // 不再使用 transfer()，改用 call()。
    // 原因：transfer() 固定 2300 gas，如果 receiver 是合约且 fallback 耗费较高，交易会失败。
    // call() 提供所有可用 gas，是目前的推荐做法。
    function withdraw() external onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "No balance to withdraw");

        // 使用 call 进行低级调用，并检查返回值
        (bool success, ) = payable(owner).call{value: balance}("");
        
        // 安全检查：必须转账成功，否则回滚
        require(success, "ETH transfer failed");

        emit Withdrawn(owner, balance);
    }

    // 查询函数不需要修改状态，使用 view，无 Gas 消耗（除了调用费）
    function getDonation(address _donor) external view returns (uint256) {
        return donations[_donor];
    }
}
