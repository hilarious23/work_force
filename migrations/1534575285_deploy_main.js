var Factory = artifacts.require("./Factory.sol");
var TaskForce = artifacts.require("./Factory.sol");

module.exports = function(deployer) {
    deployer.deploy(Factory);
    deployer.deploy(TaskForce);
};
