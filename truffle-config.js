require("dotenv").config();
const { readFileSync } = require('fs');
const HDWalletProvider = require("truffle-hdwallet-provider");
const mnemonic = process.env.MNEMONIC;
const accessToken = process.env.INFURA;

module.exports = {
    solc: {
        optimizer: {
            enabled: true,
            runs: 200
        }
    },

    networks: {
        development: {
            host: "localhost",
            port: 7545,
            network_id: "*"
        },

        rinkeby: {
            provider: function() {
              return new HDWalletProvider(
                mnemonic,
                "https://rinkeby.infura.io/" +　accessToken,
              );
            },
            network_id: 4,
            gas: 7000000, // Gas limit used for deploys
            gasPrice: 90000000000,
        },

        Ropsten: {
            provider: function() {
              return new HDWalletProvider(
                mnemonic,
                "https://Ropsten.infura.io/" +　accessToken,
              );
            },
            network_id: 3,
            gas: 4700000, // Gas limit used for deploys
            gasPrice: 29000000,
        }

    }
};
