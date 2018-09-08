import web3 from './web3';
import CampaignFactory from './build/Factory.json';

const instance = new web3.eth.Contract(
  JSON.parse(Factory.interface),
  '0xd4A8E021aeaF4a5A1723B52821aE0F32194e0874'
);

export default instance;