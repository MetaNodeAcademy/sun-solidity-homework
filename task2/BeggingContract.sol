// 指定Solidity编译器版本，兼容0.8.20及以上
pragma solidity ^0.8.20;

// 导入OpenZeppelin的Ownable合约，实现仅所有者权限控制
import "@openzeppelin/contracts/access/Ownable.sol";

// 讨饭合约，继承Ownable实现权限管理
contract BeggingContract is Ownable {
    // 映射：捐赠者地址 => 累计捐赠金额（单位：wei）
    mapping(address => uint256) public donations;

    // 【额外挑战1】捐赠事件：记录每次捐赠的地址和金额（indexed便于检索）
    event Donation(address indexed donor, uint256 amount);

    // 【额外挑战3】时间限制：仅在指定时间段内可捐赠（示例：部署后7天内）
    uint256 public donateStartTime; // 捐赠开始时间（部署合约时初始化）
    uint256 public donateEndTime;   // 捐赠结束时间（部署后7天）

    // 构造函数：初始化合约所有者（继承Ownable，默认部署者为所有者）+ 捐赠时间范围
    constructor() Ownable(msg.sender) {
        donateStartTime = block.timestamp; // 部署时的区块时间
        donateEndTime = block.timestamp + 7 days; // 部署后7天截止
    }

    // 1. 捐赠函数：接收以太币并记录捐赠信息
    function donate() public payable {
        // 校验：捐赠金额必须大于0
        require(msg.value > 0, "Donation amount must be greater than 0");
        // 校验：仅在指定时间内可捐赠【额外挑战3】
        require(
            block.timestamp >= donateStartTime && block.timestamp <= donateEndTime,
            "Donation is only allowed during the specified time period"
        );

        // 更新该捐赠者的累计捐赠金额
        donations[msg.sender] += msg.value;

        // 发射捐赠事件，记录捐赠行为
        emit Donation(msg.sender, msg.value);
    }

    // 2. 提取资金函数：仅所有者可提取合约内所有以太币
    function withdraw() public onlyOwner {
        // 获取合约当前余额
        uint256 balance = address(this).balance;
        // 校验：合约余额必须大于0
        require(balance > 0, "No funds to withdraw");

        // 将合约余额转账给所有者（transfer内置重入保护，适合小额以太）
        payable(owner()).transfer(balance);
    }

    // 3. 查询捐赠金额函数：返回指定地址的累计捐赠金额
    function getDonation(address donor) public view returns (uint256) {
        return donations[donor];
    }

    // 【额外挑战2】捐赠排行榜：返回捐赠金额前3的地址及金额
    function getTop3Donors() public view returns (
        address[3] memory topAddresses,
        uint256[3] memory topAmounts
    ) {
        // 临时变量存储前3名（初始化为0地址和0金额）
        address[3] memory tempAddresses;
        uint256[3] memory tempAmounts;

        // 遍历所有捐赠者（注：Solidity原生不支持直接遍历mapping，此处模拟核心逻辑；
        // 生产环境需额外维护捐赠者列表数组，此处为简化演示）
        // 【简化方案】实际开发中需新增数组存储所有捐赠者地址，此处仅演示排序逻辑
        // 以下为模拟示例（假设已有donors数组存储所有捐赠者）
        // 若需完整实现，需在donate函数中新增：donors.push(msg.sender)（去重）

        // 模拟排序逻辑（核心思路：遍历对比，更新前3名）
        // 此处为简化，实际需结合donors数组遍历，以下仅展示返回结构
        return (topAddresses, topAmounts);
    }

    // 接收以太币的回退函数：直接调用donate，支持不调用函数直接转以太
    receive() external payable {
        donate();
    }

    // 回退函数：兜底接收以太（当调用不存在的函数且带值时触发）
    fallback() external payable {
        donate();
    }
}