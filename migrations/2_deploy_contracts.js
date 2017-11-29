
var KaioTokenCrowdsale = artifacts.require("KaioTokenCrowdsale");
var moment = require('moment');

function latestTime() {
  return web3.eth.getBlock('latest').timestamp;
}

const duration = {
  seconds: function (val) { return val },
  minutes: function (val) { return val * this.seconds(60) },
  hours: function (val) { return val * this.minutes(60) },
  days: function (val) { return val * this.hours(24) },
  weeks: function (val) { return val * this.days(7) },
  years: function (val) { return val * this.days(365) }
};

module.exports = function (deployer, network, accounts) {
  // Use the accounts within your migrations.

  console.log('deploying...');

  //return ;// if run test 

  // var startTime = moment().add(1,'m').toDate().getTime();
  // var endTime = moment().add(1,'M').toDate().getTime();
  const rate = 1000; // 1eth = 1000 token
  //const address = '0x627306090abaB3A6e1400e9345bC60c78a8BEf57';//'0x00a8d3eb87ca1bd6719c543fd389e6411394103b';
  const address = '0x00a8d3eb87ca1bd6719c543fd389e6411394103b';  

  const startTime = latestTime() + duration.minutes(1);
  const endTime = startTime + duration.hours(6);


  // const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1; // one second in the future
  // const endTime = startTime + (86400 * 20); // 20 days
  // const rate = new web3.BigNumber(1000);
  // const wallet = accounts[0];

  return deployer.deploy(KaioTokenCrowdsale, startTime, endTime, rate, address).then(async () => {
    const instance = await KaioTokenCrowdsale.deployed();
    const token = await instance.token.call();

    console.log("params: ", JSON.stringify([startTime, endTime, rate, address]));
    console.log("start at: ", moment.unix(startTime).format('YYYY-MM-DD hh:mm:ss A'));
    console.log("end at: ", moment.unix(endTime).format('YYYY-MM-DD hh:mm:ss A'));
    console.log('token:', token);
  });


  // return deployer.deploy(KaioTokenCrowdsale, startTime, endTime, rate, goal, cap, address).then(async () => {
  //   const instance = await KaioTokenCrowdsale.deployed();
  //   const token = await instance.token.call();

  //   console.log("params: ", JSON.stringify([startTime, endTime, rate, goal, cap, address]));
  //   console.log("start at: ", moment.unix(startTime).format('YYYY-MM-DD hh:mm:ss A'));
  //   console.log("end at: ", moment.unix(endTime).format('YYYY-MM-DD hh:mm:ss A'));
  //   console.log('token:', token);
  // });



};

