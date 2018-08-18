pragma solidity ^ 0.4.23;

contract taskFacory {
    
}


contract task {
    struct toDo {
        bool exist;
        bool complete;
        uint64 id;
        string desctiption;
        uint64 deadline;
        uint128 value;
    }
    toDo[] public todos;
    mapping(uint64 => toDo) public idtotodos;
    mapping(address => address) public linkAddress;
    uint128 public completeTaskCounts;
    uint128 public cancelTaskCounts;
    uint128 public failTaskCounts;
    
    address public receiverAddress;
    address constant senderAddress = 0xca35b7d915458ef540ade6068dfe2f44e8fa733c;
    
    modifier onlysenderAddress() {
        require(msg.sender == senderAddress);
        _;
    }
    
    modifier onlyreceiverAddress() {
        require(msg.sender == receiverAddress);
        _;
    }
    
    function setReceiverAddress(address _receiverAddress) public onlysenderAddress(){
        linkAddress[msg.sender] = _receiverAddress;
        receiverAddress = linkAddress[msg.sender];
    }
    
    function createToDo(string _desctiption, uint64 _deadline, uint64 _id) onlysenderAddress() payable{
        require(msg.value > 1);
        toDo memory _todo = toDo({
            exist: true,
            complete: false,
            id: _id,
            desctiption: _desctiption,
            deadline: _deadline,
            value: uint128(msg.value)
        });
        idtotodos[_id] = _todo;
        todos.push(_todo);
    }
    

    function completeToDo(uint64 _id) onlysenderAddress() {
        toDo storage todos = idtotodos[_id];
        require(todos.exist);
        require(!todos.complete);
        require(block.timestamp <= todos.deadline);
        
        senderAddress.transfer(todos.value);
        todos.complete = true;
        completeTaskCounts++;
    }
    
    
    function cancelToDo(uint64 _id) onlysenderAddress public{
        toDo storage todos = idtotodos[_id];
        require(todos.exist);
        require(!todos.complete);
        require(block.timestamp <= todos.deadline);
        
        senderAddress.transfer(todos.value);
        
        todos.complete = true;
        cancelTaskCounts++;
    }
    
    function getReward(uint64 _id) onlyreceiverAddress {
        toDo storage todos = idtotodos[_id];
        require(todos.exist);
        require(!todos.complete);
        require(block.timestamp > todos.deadline);
        
        receiverAddress.transfer(todos.value);
        todos.complete = true;
        failTaskCounts++;
    }
    
    
    function getInfo() public view returns (uint64 timestampNow, uint256 taskcounts) {
        return (
            uint64(block.timestamp),
            todos.length
        );
    }

}
    
    