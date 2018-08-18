var Factory = artifacts.require("./TaskForce.sol");
var TaskForce = artifacts.require("./TaskForce.sol");

module.exports = function(deployer) {
    deployer.deploy(Factory);
};
