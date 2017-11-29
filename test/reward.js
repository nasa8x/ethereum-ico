
var Web3 = require('web3');
var web3 = new Web3('http://localhost:8545');

const abi = require('./abi.json');
const UNLOCKED_ACCOUNT = '0x00a8d3eb87ca1bd6719c543fd389e6411394103b';
const CONTRACT_ADDRESS = '0x4D4f42EF44Be2D6104399e7840B8ef1D7Be026e8';

const myContract = new web3.eth.Contract(abi, CONTRACT_ADDRESS, {
    from: UNLOCKED_ACCOUNT, // default from address
    gasPrice: '20000000000' // default gas price in wei ~20gwei
});

myContract.methods.reward('0xf17f52151EbEF6C7334FAD080c5704D77216b732', 50000000000).estimateGas().then((gasNeeded) => {
    myContract.methods.reward('0xf17f52151EbEF6C7334FAD080c5704D77216b732', 50000000000).send({
        gas: gasNeeded
    }).then((receipt) => {       
        console.log(receipt);       
    })
});