pragma solidity ^ 0.4.23;

import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/ownership/Ownable.sol";

contract toDo is Ownable {
    struct toDo {
        bool exist;
        bool complete;
        bool withdraw;
        uint64 id;
        string desctiption;
        uint64 deadline;
    }
    
    mapping(uint64 => toDo) public idtotodos;
    
    uint64 constant value = 10000000000000;
    address constant receiverAddress = 0x14723a09acff6d2a60dcdf7aa4aff308fddc160c;
    address constant senderAddress = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    string constant replyWord = "男に二言はねぇ";
    
    modifier onlysenderAddress() {
        require(msg.sender == senderAddress);
        _;
    }
    
    modifier onlyreceiverAddress() {
        require(msg.sender == receiverAddress);
        _;
    }
    
    function createToDo(string _desctiption, uint64 _deadline, uint64 _id) onlysenderAddress() payable{
        toDo memory _todo = toDo({
            exist: true,
            complete: false,
            withdraw: true,
            id: _id,
            desctiption: _desctiption,
            deadline: _deadline
        });
        idtotodos[_id] = _todo;
    }


    function completeToDo(uint64 _id) onlysenderAddress() {
        toDo storage todos = idtotodos[_id];
        require(todos.exist);
        require(!todos.complete);
        require(todos.withdraw);
        require(block.timestamp <= todos.deadline);
        
        senderAddress.transfer(this.balance);
        todos.complete = true;
    }
    
    function failToDo(uint64 _id) onlysenderAddress() {
        toDo storage todos = idtotodos[_id];
        require(todos.exist);
        require(!todos.complete);
        
        todos.complete = false;
        todos.withdraw = false;
        receiverAddress.transfer(this.balance);
    }
    
    function cancelToDo(uint64 _id) onlysenderAddress public view returns (string){
        toDo storage todos = idtotodos[_id];
        require(todos.exist);
        require(!todos.complete);
        require(block.timestamp <= todos.deadline);
        
        senderAddress.transfer(this.balance);
        return replyWord;
    }
    
    function getReword(uint64 _id) onlyreceiverAddress {
        toDo storage todos = idtotodos[_id];
        require(todos.exist);
        require(!todos.complete);
        require(block.timestamp >= todos.deadline);
        
        receiverAddress.transfer(this.balance);
        todos.
    }
    
    
    
    function getCurrentTimestamp() public view returns (uint64) {
        return uint64(block.timestamp);
    }





}
    
    