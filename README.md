## 1.code
```js
git clone https://github.com/nasa8x/ethereum-ico.git ico

cd ico 

npm install
```

## 2.truffle
```js
npm install -g truffle
```

## 3.parity
```js
brew install parity
```
## create or import account
```js
parity --chain kovan ui
```

## 4.unlock account
```js
parity --geth --chain kovan --force-ui --jsonrpc-cors http://127.0.0.1:8180 --unlock 0x00a8d3eb87ca1bd6719c543fd389e6411394103b --author 0x00a8d3eb87ca1bd6719c543fd389e6411394103b --password "password.txt"
```
```js
enter address in browser: http://127.0.0.1:8180
```
## 5.deploy
```js
truffle migrate --reset
```

```js
// reseult 
Using network 'development'.

Running migration: 1_initial_migration.js
  Deploying Migrations...
  ... 0xcdc41c59220524f1e9d58bfb27b08cdd35dec44f320fd4edcfd556a258bf4901
  Migrations: 0x432d645b36faa418713cce8f3ef84f53b663d089
Saving artifacts...
Running migration: 2_deploy_contracts.js
deploying...
  Deploying KaioTokenCrowdsale...
  ... 0xf450d0901dc54f2d17b8ec2e08be9141f2cab986513d72c0afecea987986fe67
  KaioTokenCrowdsale: 0x4d4f42ef44be2d6104399e7840b8ef1d7be026e8
params:  [1511928792,1511950392,1000,"0x00a8d3eb87ca1bd6719c543fd389e6411394103b"]
start at:  2017-11-29 11:13:12 AM
end at:  2017-11-29 05:13:12 PM
token: 0x1b2ed60ec06edeecd14e8f4e6f85b8e6b5ff869a
Saving artifacts...
```

## 6.verify code

```js
// run node 

var Web3 = require('web3');

var web3 = new Web3('http://localhost:8545');

web3.eth.abi.encodeParameters(
    ['uint256', 'uint256', 'uint256', 'address'],
    [1511928792,1511950392,1000,"0x00a8d3eb87ca1bd6719c543fd389e6411394103b"]
);

// result: '0x000000000000000000000000000000000000000000000000000000005a1e33d8000000000000000000000000000000000000000000000000000000005a1e883800000000000000000000000000000000000000000000000000000000000003e800000000000000000000000000a8d3eb87ca1bd6719c543fd389e6411394103b'

```

Combine solidity project to flat file:
https://github.com/oraclesorg/oracles-combine-solidity

then... copy source code and encode param for verify

https://kovan.etherscan.io/address/0x4d4f42ef44be2d6104399e7840b8ef1d7be026e8#code

## 7.done 

send eth to contract address
