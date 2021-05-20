// SPDX-License-Identifier: GPL-3.0
// The ERC20 Smart Contract

pragma solidity ^0.6.0;

//ERC20 Interface
interface IERC20 {

    function rtotalSupply() external view returns (uint256);
    function rbalanceOf(address account) external view returns (uint256);
    function rallowance(address owner, address spender) external view returns (uint256);

    function rtransfer(address recipient, uint256 amount) external returns (bool);
    function rapprove(address spender, uint256 amount) external returns (bool);
    function rtransferFrom(address sender, address recipient, uint256 amount) external returns (bool);


    event rTransfer(address indexed from, address indexed to, uint256 value);
    event rApproval(address indexed owner, address indexed spender, uint256 value);
}

//MyToken Contract - Rishikesh
contract Rishikesh is IERC20 {

    string public constant rname = "Rishikesh";
    string public constant rsymbol = "RK";
    uint8 public constant rdecimals = 18;


    event rApproval(address indexed tokenOwner, address indexed spender, uint tokens);
    event rTransfer(address indexed from, address indexed to, uint tokens);


    mapping(address => uint256) rbalances;

    mapping(address => mapping (address => uint256)) rallowed;

    uint256 rtotalSupply_ = 1000;

   constructor() public {
    rbalances[msg.sender] = rtotalSupply_;
    }

    function rtotalSupply() public override view returns (uint256) {
    return rtotalSupply_;
    }

    function rbalanceOf(address tokenOwner) public override view returns (uint256) {
        return rbalances[tokenOwner];
    }

    function rtransfer(address receiver, uint256 numTokens) public override returns (bool) {
        require(numTokens <= rbalances[msg.sender]);
        rbalances[msg.sender] = rbalances[msg.sender] - numTokens;
        rbalances[receiver] = rbalances[receiver] + numTokens;
        emit rTransfer(msg.sender, receiver, numTokens);
        return true;
    }

    function rapprove(address delegate, uint256 numTokens) public override returns (bool) {
        rallowed[msg.sender][delegate] = numTokens;
        emit rApproval(msg.sender, delegate, numTokens);
        return true;
    }

    function rallowance(address owner, address delegate) public override view returns (uint) {
        return rallowed[owner][delegate];
    }

    function rtransferFrom(address owner, address buyer, uint256 numTokens) public override returns (bool) {
        require(numTokens <= rbalances[owner]);
        require(numTokens <= rallowed[owner][msg.sender]);

        rbalances[owner] = rbalances[owner] - numTokens;
        rallowed[owner][msg.sender] = rallowed[owner][msg.sender] - numTokens;
        rbalances[buyer] = rbalances[buyer] + numTokens;
        emit rTransfer(owner, buyer, numTokens);
        return true;
    }
}







