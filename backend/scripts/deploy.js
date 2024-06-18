const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("deployed to contract to this account",deployer.address);


  const Token = await ethers.getContractFactory("IERC20");
  const token = await Token.deploy();
  await token.deployed();

  console.log("Token deployed to:",token.address);

  const CrowdFund = await ethers.getContractFactory("Crowdfund");
  const crowfund = await CrowdFund.deploy(token.address);
  await crowfund.deployed();


  console.log("CrowdFund deployed to:",crowfund.address);




} 

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
});