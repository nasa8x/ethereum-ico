var Web3 = require('web3');

var web3 = new Web3('http://localhost:8545');

web3.eth.abi.encodeParameters(
    ['uint256', 'uint256', 'uint256', 'address'],
    [1511928792,1511950392,1000,"0x00a8d3eb87ca1bd6719c543fd389e6411394103b"]
);