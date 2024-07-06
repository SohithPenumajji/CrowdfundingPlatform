const { expect } = require("chai");
const { ethers } = require("hardhat");
describe("Crowdfund", function () {
  let CrowdFund;
  let Token;
  let crowdFund;
  let token;
  let owner;
  let addr1;
  let addr2;
  let addrs;

  beforeEach(async function () {
    [owner, addr1, addr2, ...addrs] = await ethers.getSigners();

    const initialSupply = ethers.utils.parseUnits("100000", 18);

    Token = await ethers.getContractFactory("MyToken");
    token = await Token.deploy(initialSupply);
    await token.deployed();

    CrowdFund = await ethers.getContractFactory("Crowdfund");
    crowdFund = await CrowdFund.deploy(token.address);
    await crowdFund.deployed();
  });

  describe("Deployment", function () {
    it("should set the right owner", async function () {
      expect(await crowdFund.owner()).to.equal(owner.address);
    });

    it("should have token address set correctly", async function () {
      expect(await crowdFund.token()).to.equal(token.address);
    });
  });

  describe("CrowdFund functions", function () {
    it("should allow launching a campaign", async function () {
      await crowdFund.launch(1000, 100, 200);
      const campaign = await crowdFund.campaigns(1);
      expect(campaign.creator).to.equal(owner.address);
      expect(campaign.goal).to.equal(1000);
      expect(campaign.startTime).to.equal(100);
      expect(campaign.endTime).to.equal(200);
      expect(campaign.claimed).to.equal(false);
    });

    it("should allow pledging to a campaign", async function () {
      await crowdFund.launch(1000, 100, 200);
      await crowdFund.connect(addr1).pledge(1, 500);
      const campaign = await crowdFund.campaigns(1);
      expect(campaign.pledged).to.equal(500);
    });
  });
});
