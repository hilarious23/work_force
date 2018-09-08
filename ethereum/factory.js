import web3 from './web3';
import Factory from './build/Factory.json';

const instance = new web3.eth.Contract(
  JSON.parse(Factory.interface),
  '0xA1d099ef85a7442d82220E22038AAb209feCd8d6'
);

export default instance;