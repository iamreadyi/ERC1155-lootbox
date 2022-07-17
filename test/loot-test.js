const { expect } = require("chai");
const { ethers } = require("hardhat");
//will add for every class
const seeds = [
  9782161, 4874274, 7842479, 7974989, 6506055, 5519859, 5098306, 598171,
  3705049, 3390772, 8072675, 8875890, 6302128, 9858398, 6974471, 1101433,
  741096, 3655304, 1630588, 4303434, 3835112, 5280898, 398753, 3277979, 9515516,
  4193025, 9819844, 3501221, 1868224, 6632546, 9999999,
];

describe("Loot contract", function () {
  let owner,
    user1,
    user2,
    user3,
    user4,
    user5,
    user6,
    user7,
    user8,
    user9,
    user10,
    user11,
    user12,
    user13,
    user14,
    user15,
    user16,
    user17,
    user18,
    user19;

  let ERC_Con, MarketCon, LootCon, erc1155, market, loot;

  it("", async function () {
    ERC_Con = await ethers.getContractFactory("GamiBox");
    MarketCon = await ethers.getContractFactory("Market");
    LootCon = await ethers.getContractFactory("SimpleLoot");

    [
      owner,
      user1,
      user2,
      user3,
      user4,
      user5,
      user6,
      user7,
      user8,
      user9,
      user10,
      user11,
      user12,
      user13,
      user14,
      user15,
      user16,
      user17,
      user18,
      user19,
    ] = await ethers.getSigners();
    // console.log(owner.address);
    erc1155 = await ERC_Con.connect(owner).deploy();
    expect(await erc1155.connect(owner).balanceOf(owner.address, 17)).to.equal(
      1000
    );

    market = await MarketCon.connect(owner).deploy(erc1155.address);
    loot = await LootCon.connect(owner).deploy(erc1155.address);

    await erc1155.connect(owner).setApprovalForAll(market.address, 1);
    await erc1155.connect(owner).setApprovalForAll(loot.address, 1);
  });

  describe("Loots with different boxes", function () {
    it("Key => 1 Box => 3", async function () {
      let testCount = 0;
      await erc1155.connect(user1).setApprovalForAll(loot.address, 1);
      await market.connect(user1).buyToken(1);
      await market.connect(user1).buyToken(3);

      expect(await erc1155.connect(user1).balanceOf(user1.address, 1)).to.equal(
        1
      );
      expect(await erc1155.connect(user1).balanceOf(user1.address, 3)).to.equal(
        1
      );

      await loot.connect(user1).lootTheBox(3, seeds[testCount]); //17 gelmesi lazım id
      expect(
        await erc1155.connect(user1).balanceOf(user1.address, 17)
      ).to.equal(1);

      expect(await erc1155.connect(user1).balanceOf(user1.address, 1)).to.equal(
        0
      );
      expect(await erc1155.connect(user1).balanceOf(user1.address, 3)).to.equal(
        0
      );
    });

    it("Key => 2 Box => 4", async function () {
      let testCount = 30;
      await erc1155.connect(user2).setApprovalForAll(loot.address, 1);
      await market.connect(user2).buyToken(2);
      await market.connect(user2).buyToken(4);

      expect(await erc1155.connect(user2).balanceOf(user2.address, 2)).to.equal(
        1
      );
      expect(await erc1155.connect(user2).balanceOf(user2.address, 4)).to.equal(
        1
      );

      await loot.connect(user2).lootTheBox(4, seeds[testCount]); //28 gelmesi lazım id
      expect(
        await erc1155.connect(user2).balanceOf(user2.address, 28)
      ).to.equal(1);

      expect(await erc1155.connect(user2).balanceOf(user2.address, 2)).to.equal(
        0
      );
      expect(await erc1155.connect(user2).balanceOf(user2.address, 4)).to.equal(
        0
      );
    });
  });
});
