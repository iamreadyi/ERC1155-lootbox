const { expect } = require("chai");
const { ethers } = require("hardhat");
// Every class can be added with every item and odd
const seeds = [
  1000000, 9782161, 4874274, 7842479, 7974989, 6506055, 5519859, 5098306,
  598171, 3705049, 3390772, 8072675, 8875890, 6302128, 9858398, 6974471,
  1101433, 741096, 3655304, 1630588, 4303434, 3835112, 5280898, 398753, 3277979,
  9515516, 4193025, 9819844, 3501221, 1868224, 6632546, 9999999, 7992329,
  9920486, 9994425,
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
    it("Key => 1 Box => 3 RARE", async function () {
      let testCount = 1; //9782161
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

    it("Key => 2 Box => 4 FOUNDERS", async function () {
      let testCount = 31; //9999999
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

    it("Key => 2 Box => 5 STANDARD", async function () {
      let testCount = 0; //1000000
      await erc1155.connect(user3).setApprovalForAll(loot.address, 1);
      await market.connect(user3).buyToken(2);
      await market.connect(user3).buyToken(5);

      expect(await erc1155.connect(user3).balanceOf(user3.address, 2)).to.equal(
        1
      );
      expect(await erc1155.connect(user3).balanceOf(user3.address, 5)).to.equal(
        1
      );

      await loot.connect(user3).lootTheBox(5, seeds[testCount]); //6 gelmesi lazım id
      expect(await erc1155.connect(user3).balanceOf(user3.address, 6)).to.equal(
        1
      );

      expect(await erc1155.connect(user3).balanceOf(user3.address, 2)).to.equal(
        0
      );
      expect(await erc1155.connect(user3).balanceOf(user3.address, 5)).to.equal(
        0
      );
    });

    it("Key => 2 Box => 5 COMMON", async function () {
      let testCount = 32; //7992329
      await erc1155.connect(user4).setApprovalForAll(loot.address, 1);
      await market.connect(user4).buyToken(2);
      await market.connect(user4).buyToken(5);

      expect(await erc1155.connect(user4).balanceOf(user4.address, 2)).to.equal(
        1
      );
      expect(await erc1155.connect(user4).balanceOf(user4.address, 5)).to.equal(
        1
      );

      await loot.connect(user4).lootTheBox(5, seeds[testCount]); //12 gelmesi lazım id
      expect(
        await erc1155.connect(user4).balanceOf(user4.address, 12)
      ).to.equal(1);

      expect(await erc1155.connect(user4).balanceOf(user4.address, 2)).to.equal(
        0
      );
      expect(await erc1155.connect(user4).balanceOf(user4.address, 5)).to.equal(
        0
      );
    });

    it("Key => 2 Box => 5 EPIC", async function () {
      let testCount = 33; //9920486
      await erc1155.connect(user5).setApprovalForAll(loot.address, 1);
      await market.connect(user5).buyToken(2);
      await market.connect(user5).buyToken(5);

      expect(await erc1155.connect(user5).balanceOf(user5.address, 2)).to.equal(
        1
      );
      expect(await erc1155.connect(user5).balanceOf(user5.address, 5)).to.equal(
        1
      );

      await loot.connect(user5).lootTheBox(5, seeds[testCount]); //23 gelmesi lazım id
      expect(
        await erc1155.connect(user5).balanceOf(user5.address, 23)
      ).to.equal(1);

      expect(await erc1155.connect(user5).balanceOf(user5.address, 2)).to.equal(
        0
      );
      expect(await erc1155.connect(user5).balanceOf(user5.address, 5)).to.equal(
        0
      );
    });

    it("Key => 1 Box => 3 LEGENDARY(EPIC PLAYER)", async function () {
      let testCount = 34; //9994425
      await erc1155.connect(user5).setApprovalForAll(loot.address, 1);
      await market.connect(user5).buyToken(1);
      await market.connect(user5).buyToken(3);

      expect(await erc1155.connect(user5).balanceOf(user5.address, 1)).to.equal(
        1
      );
      expect(await erc1155.connect(user5).balanceOf(user5.address, 3)).to.equal(
        1
      );

      await loot.connect(user5).lootTheBox(3, seeds[testCount]); //25 gelmesi lazım id
      expect(
        await erc1155.connect(user5).balanceOf(user5.address, 25)
      ).to.equal(1);

      expect(await erc1155.connect(user5).balanceOf(user5.address, 1)).to.equal(
        0
      );
      expect(await erc1155.connect(user5).balanceOf(user5.address, 3)).to.equal(
        0
      );
    });
  });
});
