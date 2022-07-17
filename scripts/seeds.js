seedsArray = [];

function getRandomArbitrary(min, max) {
  return Math.random() * (max - min) + min;
}

function generateSeed() {
  for (let i = 0; i < 30; i++) {
    seedsArray.push(Math.floor(getRandomArbitrary(0, 10000000)));
  }
}

generateSeed();
console.log(seedsArray);
