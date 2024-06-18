require("@nomicfoundation/hardhat-toolbox");

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
   hardhat: {},
   sepolia: {
    url: process.env.URL,
    accounts: [process.env.PRIVATE_KEY]
   } 
  }

};
