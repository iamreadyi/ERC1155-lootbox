const { expect } = require("chai");
const { ethers } = require("hardhat");
const hre = require("hardhat");

async function main() {
  const Storage = await hre.ethers.getContractFactory("Storage");
  const storage = await Storage.deploy();

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

  let countData = [];
  let sevenDigits = [];
  async function testfunc(testcount) {
    for (let i = 0; i < testcount; i++) {
      /*  let randomUser =
        "user" + Math.floor(getRandomArbitrary(1, 20)).toString(); */
      await storage.connect(user1).assignSeed(3);

      let sevendigit = await storage
        .connect(user1)
        .useSeed((Math.random() * 10 ** 20).toString(), 3);
      //console.log(sevendigit);
      sevenDigits.push(sevendigit);
      let count = 0;
      while (sevendigit != 0) {
        sevendigit = Math.floor(sevendigit / 10);
        count++;
      }
      countData.push(count);
    }
  }

  function getRandomArbitrary(min, max) {
    return Math.random() * (max - min) + min;
  }
  typeOdds = [0, 7992328, 9590793, 9910486, 9974425, 9999900, 10000000];

  function control(countArray, testCount, rawData) {
    let countsObject = {
      "1count": 0,
      "2count": 0,
      "3count": 0,
      "4count": 0,
      "5count": 0,
      "6count": 0,
      "7count": 0,
    };
    for (let i = 0; i < testCount; i++) {
      countsObject[countArray[i].toString() + "count"]++;
    }
    console.log(countsObject);

    let classesObject = {
      "1class": 0, //1standard
      "2class": 0, //2common
      "3class": 0, //3rare
      "4class": 0, //4epic
      "5class": 0, //5legendary
      "6class": 0, //6founders
    };

    for (let k = 0; k < testCount; k++) {
      for (let x = 0; x < 6; x++) {
        if (typeOdds[x] <= rawData[k] && rawData[k] < typeOdds[x + 1]) {
          classesObject[(x + 1).toString() + "class"]++;
        }
      }
    }

    console.log(classesObject);
  }

  await testfunc(1000);
  control(countData, 1000, sevenDigits);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });

//some test data
/*{
  '1count': 0,
  '2count': 0,
  '3count': 0,
  '4count': 3,
  '5count': 13,
  '6count': 104,
  '7count': 880
}
{
  '1class': 892,
  '2class': 87,
  '3class': 15,
  '4class': 5,
  '5class': 1,
  '6class': 0
}
{
  '1count': 0,
  '2count': 0,
  '3count': 0,
  '4count': 4,
  '5count': 8,
  '6count': 114,
  '7count': 874
}
{
  '1class': 895,
  '2class': 78,
  '3class': 23,
  '4class': 4,
  '5class': 0,
  '6class': 0
}

{
  '1count': 0,
  '2count': 0,
  '3count': 0,
  '4count': 0,
  '5count': 2,
  '6count': 9,
  '7count': 89
}
{
  '1class': 87,
  '2class': 11,
  '3class': 1,
  '4class': 0,
  '5class': 1,
  '6class': 0
}*/
