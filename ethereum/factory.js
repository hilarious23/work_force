import web3 from './web3';
import Factory from './build/Factory.json';

const instance = new web3.eth.Contract(
  JSON.parse(Factory.interface),
  '0x26690a9328C015308A2e5E6b97960A167F4dE2b1'
);

export default instance;