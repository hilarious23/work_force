
import web3 from './web3';
import TaskForce from './build/TaskForce.json';

export default address => {
  return new web3.eth.Contract(JSON.parse(TaskForce.interface), address);
};