// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
// diğer seçenekleri de not ederim buraya
import "./GamiBox.sol";
import "hardhat/console.sol";

/// @title Provable fair server seed storage

contract Storage {
    GamiBox gamiBox;
    event HashedServerSeed(bytes32 indexed hashedServerSeed, uint256 nonce);
    event ServerSeed(
        string indexed serverSeed,
        string indexed clientSeed,
        uint256 nonce
    );

    struct Seed {
        string serverSeed;
        bytes32 hashedServerSeed;
        bool isUsed;
        uint256 nonce;
    }
    ///@dev Pre-assigned seeds
    mapping(uint256 => Seed) private seeds;
    uint256 lastSeedsIndex;

    uint256 availableSeedIndex = 0;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    constructor() /* address _gamiBox */
    {
        /*  gamiBox = GamiBox(_gamiBox); */
        owner = msg.sender;
        seeds[0] = Seed(
            "293d5d2ddd365f54759283a8097ab2640cbe6f8864adc2b1b31e65c14c999f04",
            keccak256(
                abi.encodePacked(
                    "293d5d2ddd365f54759283a8097ab2640cbe6f8864adc2b1b31e65c14c999f04"
                )
            ),
            false,
            1
        );
        seeds[1] = Seed(
            "92e0859afc2cea2bd2a8cf924e2c1e1df348fdb784af0f608ce782584b645090",
            keccak256(
                abi.encodePacked(
                    "92e0859afc2cea2bd2a8cf924e2c1e1df348fdb784af0f608ce782584b645090"
                )
            ),
            false,
            2
        );
        lastSeedsIndex = 1;
    }

    ///@dev There could be better ways to add new seeds than passing a struct array into a function
    function addSeed(Seed[] memory _seeds) public onlyOwner {
        for (uint256 i = 0; i < _seeds.length; i++) {
            seeds[lastSeedsIndex + 1] = _seeds[i];
            lastSeedsIndex++;
        }
    }

    /// @dev Boxes will have hashedSeed
    mapping(address => mapping(uint256 => Seed)) boxSeeds;

    /// @dev For gas optimization, batch assign can be implemented. availableSeedIndex++; should be
    //uncommented to deploymet or good testing with enough seeds.
    function assignSeed(uint256 boxId) public {
        //require(gamiBox.balanceOf(msg.sender, boxId) >= 1);

        boxSeeds[msg.sender][boxId] = seeds[availableSeedIndex];
        //availableSeedIndex++;
        emit HashedServerSeed(
            seeds[availableSeedIndex].hashedServerSeed,
            seeds[availableSeedIndex].nonce
        );
    }

    ///@param clientSeed It can be adjusted by client arbitrarily
    ///@param boxId Box id to use random number on
    /**@dev useSeed function combines server and client seed with keccak256, first 3 bytes of variables hash
     * is used to generate a 7 digit random integer, to prevent colission abi.encode used.
     * On deployment or for rigorous testing  boxSeeds[msg.sender][boxId].isUsed = true; and events should be enabled and
     * view should be removed . To see return value view should be there until finding a solution on hardhat
     */
    function useSeed(
        string memory clientSeed,
        uint256 boxId //testing için view diğer türlü transactionı veriyo return yerine sonra true yaparım remix oynarken
    ) public view returns (uint256) {
        //require(gamiBox.balanceOf(msg.sender, boxId) >= 1);
        require(boxSeeds[msg.sender][boxId].nonce >= 1); //nonce boş olduğunda 0 dan başlayacağı için nonce 1 den başlar
        require(boxSeeds[msg.sender][boxId].isUsed == false);
        //boxSeeds[msg.sender][boxId].isUsed = true; remixte açılır
        bytes32 rawRandom = keccak256(
            abi.encode(
                boxSeeds[msg.sender][boxId].serverSeed,
                clientSeed,
                boxSeeds[msg.sender][boxId].nonce
            )
        );

        uint256 loop = uint256(uint24(bytes3(rawRandom)));
        uint256 count;
        while (loop != 0) {
            loop = loop / 10;
            count++;
        }

        if (count == 8) {
            /* emit ServerSeed(
                boxSeeds[msg.sender][boxId].serverSeed,
                clientSeed,
                boxSeeds[msg.sender][boxId].nonce
            ); */

            return uint256(uint24(bytes3(rawRandom))) % 10000000;
        } else if (
            count == 7 ||
            count == 6 ||
            count == 5 ||
            count == 4 ||
            count == 3 ||
            count == 2 ||
            count == 1 ||
            count == 0
        ) {
            /*  emit ServerSeed(
                boxSeeds[msg.sender][boxId].serverSeed,
                clientSeed,
                boxSeeds[msg.sender][boxId].nonce
            ); */
            return uint256(uint24(bytes3(rawRandom))); /* * 10**(7 - count) */
        }
        return 0;
    }

    ///@dev Verifying should be off chain step 1 and step 2 included, this function is experimental

    function verifyHashedSeed(string memory serverSeed, uint256 boxId)
        public
        view
        returns (bytes32, bytes32)
    {
        return (
            keccak256(abi.encodePacked(serverSeed)),
            boxSeeds[msg.sender][boxId].hashedServerSeed
        );
    }
}
