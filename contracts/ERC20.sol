// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.8.0;

// ERC20 标准
contract ERC20Interface {
  // 获取发行总量
  function totalSupply() public constant returns (uint256);
  // 返回某个地址（账户）的账户余额
  function balanceOf(address _owner) public constant returns (uint256 balance);
  // 实现转账一定数量（_value)的代币到目标地址（_to),它会提供一个返回值来说明是否转账成功，并且会触发Transfer事件
  function transfer(address _to, uint256 _value) public returns (bool success);
  // 从一个地址（_from)转账一定数量（_value)代币到目标地址（_to),也会提供一个返回值来说明是否转账成功，同样也会触发Transfer事件
  function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
  // 允许_spender多次取回账户，最高达_value金额，如果再次调用此函数，它将以_value覆盖当前的余量
  function approve(address _spender, uint256 _value) public returns (bool success);
  // 返回_spender任然被允许从_owner提取金额
  function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
  // 代币被转移时触发的事件
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
  // 调用approve方法触发的事件
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
}

contract MiniToken is ERC2OInterface {
  string public constant symbol = "MT";
  string public constant name = "Mini Token";
  uint8 public constant decimals = 0;
  uint256 _totalSupply = 1000;
  // 定义这个合约的拥有者
  address public owner;
  // 定义各个地址余额的映射表
  mapping(address => mapping(address => uint256)) allowed;
  // 定义一个只能由所有者执行的修饰符
  modifier onlyOwner() {
    if (msg.sender != owner) {
      require(msg.sender == owner);
    }
    _;
  }
  // 初始化构造函数
  constructor () public {
    owner = msg.sender;
    balance[owner] = _totalSupply;
  }
  // 返回总发行量
  function totalSupply() public constant returns (uint256) {
    return _totalSupply;
  }
  // 返回对应账户余额
  function balanceOf(address _owner) public constant returns (uint256 balance) {
    return balances[_owner];
  }
  // 如果账户拥有的数量大于对账数量，就进行转账，否则返回失败
  function transfer(address _to, uint256 _amount) public returns (bool success) {
    if (balances[msg.sender] >= _amount
      && _amount > 0
      && balances[_to]+_amount > balances[_to]) {
      balances[msg.sender] -= _amount;
      balances[_to] += _amount;
      emit Transfer(msg.sender, _to, _amount);
      return true;
    } else {
      return false;
    }
  }
  /**
    * 从_from发送_value个令牌给to地址
    * 使用transferFrom()方法需要调用者得到_from地址的授权
    * 授权由F面的approve函数进行操作
   */
   function transferFrom(
     address _from,
     address _to,
     uint256 _amount
   ) public returns (bool success) {
     if (balances[_from] >= _amount
      && allowed[_from][msg.sender] >= _amount
      && _amount > 0
      && balances[_to] + _amount > balances[_to]) {
        balances[_from] -= _amount;
        allowed[_from][msg.sender] -= _amount;
        balances[_to] += _amount;
        emit Transfer(_from, _to, _amount);
        return true;
      } else {
        return false;
      }
   }

   /** ;
    * approve 授权第三方（_spender)从发送者账户转移一定量（最多为_value数量）的代币。
    * 第三方通常是某个只能合约，可以通过transferFrom函数来执行具体的转移操作
   */
   function approve(address _spender, uint256 _amount) public returns (bool success) {
     allowed[msg.sender][_spender] = _amount;
     emit Approval(msg.sender, _spender, _amount);
     return true;
   } 
   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
     return allowed[_owner][_spender];
   }
}