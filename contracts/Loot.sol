// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./GamiBox.sol";

/// @title Provable fair lootbox game
/// @dev tokensSeller should approve Loot contract.

contract Loot {
    GamiBox gamiBox;

    /// @dev Looted token id can be added to event.
    event LootBox(address indexed boxLooter, uint256 boxId, uint256 randomNum);

    /// @dev tokensSeller is token's owner address and should be change.d to ERC1155 owner before deployment.
    address public tokensSeller = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

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
    mapping(uint256 => uint256[]) public odds;

    /// @dev typeOdds maps winning probability for every class, dev can add new classes to box.
    mapping(uint256 => uint256[]) public typeOdds;

    /// @dev typeOdds maps winning probability for every item class, dev can add new classes to any box.
    mapping(uint256 => uint256[]) public typeCounts;

    constructor(address _gamiBox) {
        server_seed = (block.timestamp + block.difficulty) % 10000000;
        gamiBox = GamiBox(_gamiBox);

        /** @dev To test, i created 3 box with different keys, tokens and unique odds for classes.
         *  To optimize gas, it can be reduced to fixed variables with fixed class count and
         *  simple odds.
         */

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
            25
        ];
        odds[3] = [
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
            25575
        ];
        typeOdds[3] = [7992328, 1598465, 319693, 63939, 25575];
        typeCounts[3] = [6, 4, 3, 2, 1];
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
        odds[4] = [
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
        typeOdds[4] = [7992328, 1598465, 319693, 63939, 25475, 100];
        typeCounts[4] = [6, 4, 3, 2, 1, 1];
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
        odds[5] = [
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
            24575,
            1000
        ];
        typeOdds[5] = [7992328, 1598465, 319693, 63939, 24575, 1000];
        typeCounts[5] = [6, 4, 3, 2, 1, 1];
        boxKeys[5] = 2;
    }

    /** @dev Requires relevant box and key to proceed. Selects correct gap between class odds with first if.
     *   With for, it finds correct item by controlling odd gap for every single item. It burns key and box.
     *   If you want to add new class to game, you should add a new else if block to lootTheBox function.
     */
    /// @param boxId The box id to loot. Provided by the end user.

    function lootTheBox(uint256 boxId) public {
        require(gamiBox.balanceOf(msg.sender, boxId) >= 1);
        require(gamiBox.balanceOf(msg.sender, boxKeys[boxId]) >= 1);

        server_seed =
            (block.difficulty + block.timestamp + server_seed) %
            10000000;

        if (0 <= server_seed && server_seed < typeOdds[boxId][0]) {
            uint256 initial = 0;
            for (uint256 i = 0; i < typeCounts[boxId][0]; i++) {
                if (
                    initial <= server_seed &&
                    server_seed < initial + odds[boxId][i]
                ) {
                    gamiBox.safeTransferFrom(
                        tokensSeller,
                        msg.sender,
                        boxItems[boxId][i],
                        1,
                        ""
                    );
                    break;
                } else {
                    initial += odds[boxId][i];
                }
            }
        } else if (
            typeOdds[boxId][0] <= server_seed &&
            server_seed < typeOdds[boxId][0] + typeOdds[boxId][1]
        ) {
            uint256 initial = typeOdds[boxId][0];
            for (uint256 i = 0; i < typeCounts[boxId][1]; i++) {
                if (
                    initial <= server_seed &&
                    server_seed <
                    initial + odds[boxId][typeCounts[boxId][0] + i] /* box[boxId].odds[box[boxId].typeCounts[0] + i] */
                ) {
                    gamiBox.safeTransferFrom(
                        tokensSeller,
                        msg.sender,
                        boxItems[boxId][typeCounts[boxId][0] + i], /* box[boxId].items[box[boxId].typeCounts[0] + i] */
                        1,
                        ""
                    );
                    break;
                } else {
                    initial += odds[boxId][typeCounts[boxId][0] + i];
                }
            }
        } else if (
            typeOdds[boxId][0] + typeOdds[boxId][1] <= server_seed &&
            server_seed <
            typeOdds[boxId][0] + typeOdds[boxId][1] + typeOdds[boxId][2]
        ) {
            uint256 initial = typeOdds[boxId][0] + typeOdds[boxId][1];
            for (uint256 i = 0; i < typeCounts[boxId][2]; i++) {
                if (
                    initial <= server_seed &&
                    server_seed <
                    initial +
                        odds[boxId][
                            typeCounts[boxId][0] + typeCounts[boxId][1] + i
                        ] /* box[boxId].odds[box[boxId].typeCounts[0] + i] */
                ) {
                    gamiBox.safeTransferFrom(
                        tokensSeller,
                        msg.sender,
                        boxItems[boxId][
                            typeCounts[boxId][0] + typeCounts[boxId][1] + i
                        ], /* box[boxId].items[box[boxId].typeCounts[0] + i] */
                        1,
                        ""
                    );
                    break;
                } else {
                    initial += odds[boxId][
                        typeCounts[boxId][0] + typeCounts[boxId][1] + i
                    ];
                }
            }
        } else if (
            typeOdds[boxId][0] + typeOdds[boxId][1] + typeOdds[boxId][2] <=
            server_seed &&
            server_seed <
            typeOdds[boxId][0] +
                typeOdds[boxId][1] +
                typeOdds[boxId][2] +
                typeOdds[boxId][3]
        ) {
            uint256 initial = typeOdds[boxId][0] +
                typeOdds[boxId][1] +
                typeOdds[boxId][2];
            for (uint256 i = 0; i < typeCounts[boxId][3]; i++) {
                if (
                    initial <= server_seed &&
                    server_seed <
                    initial +
                        odds[boxId][
                            typeCounts[boxId][0] +
                                typeCounts[boxId][1] +
                                typeCounts[boxId][2] +
                                i
                        ] /* box[boxId].odds[box[boxId].typeCounts[0] + i] */
                ) {
                    gamiBox.safeTransferFrom(
                        tokensSeller,
                        msg.sender,
                        boxItems[boxId][
                            typeCounts[boxId][0] +
                                typeCounts[boxId][1] +
                                typeCounts[boxId][2] +
                                i
                        ], /* box[boxId].items[box[boxId].typeCounts[0] + i] */
                        1,
                        ""
                    );
                    break;
                } else {
                    initial += odds[boxId][
                        typeCounts[boxId][0] +
                            typeCounts[boxId][1] +
                            typeCounts[boxId][2] +
                            i
                    ];
                }
            }
        } else if (
            typeOdds[boxId][0] +
                typeOdds[boxId][1] +
                typeOdds[boxId][2] +
                typeOdds[boxId][3] <=
            server_seed &&
            server_seed <
            typeOdds[boxId][0] +
                typeOdds[boxId][1] +
                typeOdds[boxId][2] +
                typeOdds[boxId][3] +
                typeOdds[boxId][4]
        ) {
            uint256 initial = typeOdds[boxId][0] +
                typeOdds[boxId][1] +
                typeOdds[boxId][2] +
                typeOdds[boxId][3];
            for (uint256 i = 0; i < typeCounts[boxId][4]; i++) {
                if (
                    initial <= server_seed &&
                    server_seed <
                    initial +
                        odds[boxId][
                            typeCounts[boxId][0] +
                                typeCounts[boxId][1] +
                                typeCounts[boxId][2] +
                                typeCounts[boxId][3] +
                                i
                        ] /* box[boxId].odds[box[boxId].typeCounts[0] + i] */
                ) {
                    gamiBox.safeTransferFrom(
                        tokensSeller,
                        msg.sender,
                        boxItems[boxId][
                            typeCounts[boxId][0] +
                                typeCounts[boxId][1] +
                                typeCounts[boxId][2] +
                                typeCounts[boxId][3] +
                                i
                        ], /* box[boxId].items[box[boxId].typeCounts[0] + i] */
                        1,
                        ""
                    );
                    break;
                } else {
                    initial += odds[boxId][
                        typeCounts[boxId][0] +
                            typeCounts[boxId][1] +
                            typeCounts[boxId][2] +
                            typeCounts[boxId][3] +
                            i
                    ];
                }
            }
        } else if (
            typeOdds[boxId][0] +
                typeOdds[boxId][1] +
                typeOdds[boxId][2] +
                typeOdds[boxId][3] +
                typeOdds[boxId][4] <=
            server_seed &&
            server_seed <
            typeOdds[boxId][0] +
                typeOdds[boxId][1] +
                typeOdds[boxId][2] +
                typeOdds[boxId][3] +
                typeOdds[boxId][4] +
                typeOdds[boxId][5]
        ) {
            uint256 initial = typeOdds[boxId][0] +
                typeOdds[boxId][1] +
                typeOdds[boxId][2] +
                typeOdds[boxId][3] +
                typeOdds[boxId][4];
            for (uint256 i = 0; i < typeCounts[boxId][5]; i++) {
                if (
                    initial <= server_seed &&
                    server_seed <
                    initial +
                        odds[boxId][
                            typeCounts[boxId][0] +
                                typeCounts[boxId][1] +
                                typeCounts[boxId][2] +
                                typeCounts[boxId][3] +
                                typeCounts[boxId][4] +
                                i
                        ] /* box[boxId].odds[box[boxId].typeCounts[0] + i] */
                ) {
                    gamiBox.safeTransferFrom(
                        tokensSeller,
                        msg.sender,
                        boxItems[boxId][
                            typeCounts[boxId][0] +
                                typeCounts[boxId][1] +
                                typeCounts[boxId][2] +
                                typeCounts[boxId][3] +
                                typeCounts[boxId][4] +
                                i
                        ], /* box[boxId].items[box[boxId].typeCounts[0] + i] */
                        1,
                        ""
                    );
                    break;
                } else {
                    initial += odds[boxId][
                        typeCounts[boxId][0] +
                            typeCounts[boxId][1] +
                            typeCounts[boxId][2] +
                            typeCounts[boxId][3] +
                            typeCounts[boxId][4] +
                            i
                    ];
                }
            }
        }

        gamiBox.burn(msg.sender, boxId, 1);
        gamiBox.burn(msg.sender, boxKeys[boxId], 1);

        emit LootBox(msg.sender, boxId, server_seed);
    }
}
