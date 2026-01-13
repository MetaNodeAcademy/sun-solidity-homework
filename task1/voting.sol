// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; // 选用稳定版本，自带溢出检查

contract Voting {
    // --- 状态变量 ---

    // Gas 优化: immutable 变量部署后不再存储，省 Gas
    address public immutable owner;

    // 使用 string 存储候选人名单
    string[] public candidateList;
    
    // 使用 string 作为 key 存储票数
    mapping(string => uint256) public votesReceived;

    // 核心优化: 使用 "轮次" 机制
    uint256 public currentRound;
    
    // 记录用户在第几轮投了票 (记录轮次号比记录 bool 更灵活，且便于重置)
    mapping(address => uint256) public voterRound;

    // --- 事件 ---
    event Voted(address indexed voter, string candidate, uint256 round);
    event Reset(uint256 newRound);

    // --- 修饰符 ---
    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized: Only owner");
        _;
    }

    // 构造函数：初始化候选人
    constructor(string[] memory candidateNames) {
        owner = msg.sender;
        currentRound = 1; // 从第一轮开始
        candidateList = candidateNames;
    }

    // --- 核心功能 ---

    /// @notice 用户投票
    /// @param candidate 候选人名字 (字符串)
    function vote(string memory candidate) external {
        // 1. 检查候选人是否存在
        require(validCandidate(candidate), "Candidate does not exist.");

        // 2. 安全检查: 防止重复投票
        // 只有当用户记录的轮次号 小于 当前轮次号时，才允许投票
        require(voterRound[msg.sender] < currentRound, "You have already voted in this round.");

        // 3. 增加票数
        votesReceived[candidate]++;

        // 4. 更新用户状态为当前轮次
        voterRound[msg.sender] = currentRound;

        emit Voted(msg.sender, candidate, currentRound);
    }

    /// @notice 查询票数
    function getVotes(string memory candidate) external view returns (uint256) {
        return votesReceived[candidate];
    }

    /// @notice 重置投票 (仅管理员)
    function resetVotes() external onlyOwner {
        // 1. 遍历候选人列表，将票数归零
        for (uint256 i = 0; i < candidateList.length; i++) {
            votesReceived[candidateList[i]] = 0;
        }

        // 2. 轮次 +1 (这会让所有之前投过票的用户，自动变成"未投票"状态)
        // 这个操作比遍历所有用户地址要便宜得多，且逻辑更安全
        currentRound++;

        emit Reset(currentRound);
    }

    // --- 内部辅助函数 ---

    /// @notice 检查候选人是否在名单中
    function validCandidate(string memory candidate) private view returns (bool) {
        for (uint256 i = 0; i < candidateList.length; i++) {
            // Solidity 中 string 必须转换成 hash 才能进行比较
            if (keccak256(bytes(candidateList[i])) == keccak256(bytes(candidate))) {
                return true;
            }
        }
        return false;
    }
}

