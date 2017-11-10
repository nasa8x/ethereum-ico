require('babel-register');
require('babel-polyfill');

var provider;
var HDWalletProvider = require('truffle-hdwallet-provider');
var mnemonic = '[REDACTED]';

if (!process.env.SOLIDITY_COVERAGE) {
  provider = new HDWalletProvider(mnemonic, 'https://ropsten.infura.io/')
}

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
      port: 8545,
      network_id: "*", // Match any network id,
      gas: 4700036,
     
      from: "0x00a8d3eb87ca1bd6719c543fd389e6411394103b"
    },
    ropsten: {
      provider: provider,
      //from: "0x00abe9f9becfb2eced5ebe59fd1102d56ba53626",
      network_id: 3 // official id of the ropsten network
    }
    

  }
};
