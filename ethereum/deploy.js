require("dotenv").config();
const HDWalletProvider = require('truffle-hdwallet-provider');
const Web3 = require('web3');
const compiledFactory = require('./build/Factory.json');

const provider = new HDWalletProvider(
  process.env.METAMASK_MNEMONIC,
  'https://rinkeby.infura.io/Qlob2SIdBPJlTyJH5YYC'
);
const web3 = new Web3(provider);

const deploy = async () => {
  const accounts = await web3.eth.getAccounts();

  console.log('Attempting to deploy from account', accounts[0]);

  const result = await new web3.eth.Contract(
    JSON.parse(compiledFactory.interface)
  )
    .deploy({ data: "0x" + compiledFactory.bytecode })
    .send({ gas: '7001000', gasPrice: 90000000000, from: accounts[0] });

  console.log('Contract deployed to', result.options.address);
};
deploy();