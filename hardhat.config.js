require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.20",
  networks: {
    mumbai: {
      url: `https://polygon-mumbai.g.alchemy.com/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.ACCOUNT_PRIVATE_KEY],
    },
  },
  defaultNetwork: "mumbai",
  etherscan: {
    apiKey: process.env.SCANNER_API_KEY,
  },
};
