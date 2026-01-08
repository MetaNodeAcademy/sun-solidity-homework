// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20; // 选用稳定版本，自带溢出检查

// 导入OpenZeppelin的Ownable（行业标准权限控制库，比手写更安全）
import "@openzeppelin/contracts/access/Ownable.sol";


/**
 * @title Voting
 * @dev 安全的投票合约，支持投票、查票、重置票数，防重复投票+权限控制
 */
contract Voting is Ownable {
    // ========== 核心状态变量（private保证数据隐私，仅通过函数访问） ==========
    /// 候选人地址 => 得票数
    mapping(address => uint256) public  _candidateVotes;
    /// 投票人地址 => 候选人地址 => 是否已投票（防重复投票给同一候选人）
    mapping(address => mapping(address => bool)) private _hasVoted;
    /// 存储所有有得票的候选人地址（用于批量重置票数，解决mapping无法遍历的问题）
    address[] private _candidates;
    /// 标记候选人是否已在列表中（避免重复添加，节省Gas）
    mapping(address => bool) private _isCandidateInList;

    // ========== 事件（方便前端/链下监听投票、重置行为） ==========
    /// @dev 投票成功事件
    event Voted(address indexed voter, address indexed candidate, uint256 newVoteCount);
    /// @dev 票数重置事件
    event VotesReset(address indexed owner);

    // ========== 构造函数（初始化合约所有者） ==========
    constructor() Ownable(msg.sender) {
        
    }

    // ========== 核心功能函数 ==========
    /**
     * @dev 投票给指定候选人
     * @param candidate 候选人地址（不能是0地址）
     * 安全措施：
     * 1. 验证候选人地址非0
     * 2. 防止同一地址重复投票给同一候选人
     * 3. Solidity 0.8+ 自带溢出检查，无需额外处理
     */
    function vote(address candidate) external {
        // 1. 输入验证：候选人地址不能是0地址（无效地址）
        require(candidate != address(0), "Voting: candidate cannot be zero address");
        // 2. 防重复投票：当前用户未给该候选人投过票
        require(!_hasVoted[msg.sender][candidate], "Voting: you have already voted for this candidate");

        // 3. 标记该用户已给该候选人投票
        _hasVoted[msg.sender][candidate] = true;
        // 4. 候选人得票数+1
        _candidateVotes[candidate] += 1;

        // 5. 若候选人未在列表中，添加到列表（用于后续重置）
        if (!_isCandidateInList[candidate]) {
            _candidates.push(candidate);
            _isCandidateInList[candidate] = true;
        }

        // 触发投票事件，方便链下跟踪
        emit Voted(msg.sender, candidate, _candidateVotes[candidate]);
    }

    /**
     * @dev 获取指定候选人的得票数
     * @param candidate 候选人地址
     * @return 该候选人的得票数
     * 安全措施：验证候选人地址非0，避免无效查询
     */
    function getVotes(address candidate) external view returns (uint256) {
        require(candidate != address(0), "Voting: candidate cannot be zero address");
        return _candidateVotes[candidate];
    }

    /**
     * @dev 重置所有候选人的得票数（仅合约所有者可调用）
     * 安全措施：
     * 1. 权限控制（onlyOwner）：防止任意用户恶意重置
     * 2. 批量重置：高效清空票数，避免遍历所有映射（Gas优化）
     */
    function resetVotes() external onlyOwner {
        // 1. 遍历候选人列表，重置得票数+清空标记
        uint256 candidateCount = _candidates.length;
        
        for (uint256 i = 0; i < candidateCount; i++) {
            address candidate = _candidates[i];
            _candidateVotes[candidate] = 0;
            _isCandidateInList[candidate] = false;
        }
        

        // 2. 清空候选人列表（直接重置长度为0，比delete更省Gas）
        delete _candidates;

        // 触发重置事件
        emit VotesReset(msg.sender);

        // 注意：_hasVoted映射无法直接清空，若需完全重置投票记录（允许用户重新投票），
        // 推荐添加「投票轮次」变量（见下方优化方案），而非遍历清空（Gas成本极高）
    }


}