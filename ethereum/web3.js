import Web3 from 'web3';

//  window is a global variable that is available only inside the browser
//  window is not available on node.js
let web3;

if (typeof window !== 'undefined' && window.web3 !== 'undefined') {
  //  we are in the browser and metamask is running
  web3 = new Web3(window.web3.currentProvider);
} else {
  //  we are on the server or the user is not running metamask
  const provider = new Web3.providers.HttpProvider(
    'https://rinkeby.infura.io/Qlob2SIdBPJlTyJH5YYC'
  );
  web3 = new Web3(provider);
}

export default web3;