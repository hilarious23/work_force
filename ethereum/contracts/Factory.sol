pragma solidity ^ 0.4.24;


contract Factory {


    address[] deployedTaskForces;

    function createTaskForce() external {
        address newTaskForce = new TaskForce(msg.sender);
        deployedTaskForces.push(newTaskForce);
    }

    function getDeployedTaskForces() external view returns(address[]) {
        return deployedTaskForces;
    }
 }


contract TaskForce {


    struct task {
        bool exist;
        bool complete;
        string desctiption;
        uint64 deadline;
        uint128 value;
    }

    mapping(address => task[]) public addresstotasks;
    uint128 public completeTaskCounts;
    uint128 public cancelTaskCounts;
    uint128 public failTaskCounts;
    uint128 public taskCounts;
    uint256 public lostValue;

    address public receiverAddress;
    address public manager;

    modifier onlysenderAddress() {
        require(msg.sender == manager);
        _;
    }

    modifier onlyreceiverAddress() {
        require(msg.sender == receiverAddress);
        _;
    }

    constructor(address creater) public {
      manager = creater;
    }

    function getInfo() external view returns (
        uint64 timestampNow, uint256 taskcounts, uint128 completeTask, uint128 cancelTask, uint128 failTask
        ) {
        return (
            uint64(block.timestamp),
            taskCounts,
            completeTaskCounts,
            cancelTaskCounts,
            failTaskCounts
        );
    }

    function setReceiverAddress(address _receiverAddress) external onlysenderAddress(){
        require(_receiverAddress != msg.sender);
        receiverAddress = _receiverAddress;
    }

    function createTask(string _desctiption, uint64 _deadline) external onlysenderAddress() payable{
        require(msg.value >= 1);
        require(uint64(block.timestamp) + 100 < _deadline);
        task memory newtask = task({
            exist: true,
            complete: false,
            desctiption: _desctiption,
            deadline: _deadline,
            value: uint128(msg.value)
        });
        addresstotasks[msg.sender].push(newtask);
        taskCounts++;
    }

    function completeTask(uint256 index) external onlysenderAddress() {
        task storage tasks = addresstotasks[msg.sender][index];
        require(tasks.exist);
        require(!tasks.complete);
        require(block.timestamp <= tasks.deadline);

        manager.transfer(tasks.value);
        tasks.complete = true;
        completeTaskCounts++;
    }

    function cancelTask(uint64 index) external onlysenderAddress() {
        task storage tasks = addresstotasks[msg.sender][index];
        require(tasks.exist);
        require(!tasks.complete);
        require(block.timestamp <= tasks.deadline);

        manager.transfer(tasks.value);

        tasks.complete = true;
        cancelTaskCounts++;
    }

    function getReward(uint64 index) external onlyreceiverAddress() {
        task storage tasks = addresstotasks[manager][index];
        require(tasks.exist);
        require(!tasks.complete);
        require(block.timestamp > tasks.deadline);

        receiverAddress.transfer(tasks.value);
        tasks.complete = true;
        lostValue = lostValue + tasks.value;
        failTaskCounts++;
    }

}
