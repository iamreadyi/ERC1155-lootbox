// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./GamiBox.sol";

/// @title Provable fair lootbox game
/// @dev tokensSeller should approve Loot contract.
// Lootbox fonksiyonuna direk sayılar girilebilir test öyle de çalışır?
contract SimpleLoot {
    GamiBox gamiBox;

    /// @dev Looted token id can be added to event.
    event LootBox(address indexed boxLooter, uint256 boxId, uint256 randomNum);

    //event HashedServerSeed(uint seed);

    /// @dev tokensSeller is token's owner address and should be changed to ERC1155 owner before deployment.
    address public tokensSeller = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    /// @dev server_seed should be private after testing.
    uint256 public server_seed;

    /// @dev boxKeys maps key tokens to box tokens.
    mapping(uint256 => uint256) public boxKeys;

    /// @dev boxItems maps relevant items to boxes.
    mapping(uint256 => uint256[]) public boxItems;

    /** @dev odds maps winning probability for every item in a box to relevant item in order,
     *  there are more than one items in the boxes' most class and algorithm needs to know every odd for every item
     *  even if they are in same class.
     */
    uint256[] public odds = [
        1200000,
        1200000,
        1200000,
        1200000,
        1200000,
        1992328,
        400000,
        400000,
        400000,
        398465,
        100000,
        100000,
        119693,
        30000,
        33939,
        25475,
        100
    ];

    /// @dev typeOdds maps winning probability for every class, dev can add new classes to box.
    //uint256[] public typeOdds = [7992328, 1598465, 319693, 63939, 25475, 100];
    uint256[] public typeOdds = [
        0,
        7992328,
        9590793,
        9910486,
        9974425,
        9999900,
        10000000
    ];

    /// @dev typeOdds maps winning probability for every item class, dev can add new classes to any box.
    uint256[] public typeCounts = [6, 4, 3, 2, 1, 1];
    uint256[] public nonTypeCounts = [0, 6, 10, 13, 15, 16, 17];

    //uint256[] public typeCounts = [6, 10, 13, 15, 16, 17];

    constructor(address _gamiBox) {
        server_seed = (block.timestamp + block.difficulty) % 10000000;
        gamiBox = GamiBox(_gamiBox);

        boxItems[3] = [
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            19,
            20,
            25,
            28
        ];
        boxKeys[3] = 1;

        boxItems[4] = [
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            21,
            22,
            26,
            28
        ];

        boxKeys[4] = 2;

        boxItems[5] = [
            6,
            7,
            8,
            9,
            10,
            11,
            12,
            13,
            14,
            15,
            16,
            17,
            18,
            23,
            24,
            27,
            29
        ];

        boxKeys[5] = 2;
    }

    /** @dev Requires relevant box and key to proceed. Selects correct gap between class odds with first if.
     *   With for, it finds correct item by controlling odd gap for every single item. It burns key and box.
     *   If you want to add new class to game, you should add a new else if block to lootTheBox function.
     */
    /// @param boxId The box id to loot. Provided by the end user.

    function lootTheBox(uint256 boxId, uint256 testSeed) public {
        require(gamiBox.balanceOf(msg.sender, boxId) >= 1);
        require(gamiBox.balanceOf(msg.sender, boxKeys[boxId]) >= 1);
        bool exit = false;

        server_seed =
            (block.difficulty + block.timestamp + server_seed) %
            10000000;

        for (uint256 k = 0; k < 6; k++) {
            if (
                typeOdds[k] <= testSeed && /* server_seed */
                testSeed < /* server_seed */
                typeOdds[k + 1]
            ) {
                uint256 initial = typeOdds[k];
                for (uint256 i = 0; i < typeCounts[k]; i++) {
                    if (
                        initial <= testSeed && /* server_seed */
                        testSeed < /* server_seed */
                        initial + odds[i + nonTypeCounts[k]]
                    ) {
                        //require(gamiBox.balanceOf(tokensSeller, boxItems[boxId][i]) >= 1);
                        gamiBox.safeTransferFrom(
                            tokensSeller,
                            msg.sender,
                            boxItems[boxId][i + nonTypeCounts[k]],
                            1,
                            ""
                        );
                        exit = true;
                        break;
                    } else {
                        initial += odds[i + nonTypeCounts[k]];
                    }
                }
            }
            if (exit == true) {
                break;
            }
        }
        gamiBox.burn(msg.sender, boxId, 1);
        gamiBox.burn(msg.sender, boxKeys[boxId], 1);

        emit LootBox(msg.sender, boxId, server_seed);
    }
}
