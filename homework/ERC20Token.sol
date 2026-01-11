
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ERC20Token {
    // --- 代币元数据 ---
    string public name;
    string public symbol;
    uint8 public decimals = 18; // 标准的小数位数
    uint256 public totalSupply;

    // --- 状态变量 ---
    // 1. 存储账户余额的 mapping
    mapping(address => uint256) public balanceOf;

    // 2. 存储授权信息的 mapping (所有者 -> 授权者 -> 额度)
    mapping(address => mapping(address => uint256)) public allowance;

    // 合约拥有者，用于增发代币
    address public owner;

    // --- 事件 ---
    // 记录转账操作
    event Transfer(address indexed from, address indexed to, uint256 value);
    // 记录授权操作
    event Approval(address indexed owner, address indexed spender, uint256 value);
    // 记录增发操作 (可选，方便追踪)
    event Mint(address indexed to, uint256 amount);

    // --- 修饰符 ---
    // 限制只有所有者可以调用增发函数
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can mint");
        _;
    }

    // --- 构造函数 ---
    constructor(string memory _name, string memory _symbol, uint256 _initialSupply) {
        name = _name;
        symbol = _symbol;
        owner = msg.sender;
        // 将初始供应量铸造给部署者
        if (_initialSupply > 0) {
            _mint(msg.sender, _initialSupply);
        }
    }

    // --- 核心功能实现 ---

    // // 查询余额 (对应题目要求)
    // function balanceOf(address account) public view returns (uint256) {
    //     return balanceOf[account];
    // }

    // 转账 (对应题目要求)
    function transfer(address to, uint256 amount) public returns (bool) {

        require(to != address(0), "ERC20: transfer to zero address");
        require(balanceOf[msg.sender] >= amount, "ERC20: insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[to] += amount;

        emit Transfer(msg.sender, to, amount);
        return true;
    }

    // 授权 (对应题目要求)
    function approve(address spender, uint256 amount) public returns (bool) {
        require(spender != address(0), "ERC20: approve to zero address");

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);
        return true;
    }

    // 代扣转账 (对应题目要求)
    function transferFrom(address from, address to, uint256 amount) public returns (bool) {
        require(to != address(0), "ERC20: transfer to zero address");
        require(balanceOf[from] >= amount, "ERC20: insufficient balance");
        
        // 检查授权额度
        uint256 currentAllowance = allowance[from][msg.sender];
        require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");

        // 执行扣除和转账
        allowance[from][msg.sender] = currentAllowance - amount;
        balanceOf[from] -= amount;
        balanceOf[to] += amount;

        emit Transfer(from, to, amount);
        return true;
    }

    // 增发代币 (对应题目要求)
    function mint(address to, uint256 amount) public onlyOwner {
        _mint(to, amount);
    }

    // --- 内部函数 ---
    
    function _mint(address to, uint256 amount) internal {
        require(to != address(0), "ERC20: mint to zero address");

        totalSupply += amount;
        balanceOf[to] += amount;

        // 铸造也是一种转账，from 地址为 0x0
        emit Transfer(address(0), to, amount);
        emit Mint(to, amount);
    }
}
