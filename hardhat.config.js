require('hardhat/config');

const { ethers } = require('ethers');
const { task } = require('hardhat/config');
// Private dapp config parameters
const { private_key, endpoint } = require('./src/dappConfig');

task('accounts', 'Prints a list of accounts', async () => {
  const accounts = await ethers.getSigners();

  for (const account of accounts) {
    console.log(account.address);
  }
});

/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.3",
  networks: {
    hardhat: {
      chainId: 1337
    },
    rinkeby: {
      url: endpoint,
      accounts: [`0x${private_key}`]
    }
  },
  paths: {
    artifacts: './src/artifacts',
  }
};
