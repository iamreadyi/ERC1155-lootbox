// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "./GamiBox.sol";

//birinin çağırdığı fonksyion işlenmeden başkası o fonksiyonu çağırırsa ne oluyor, sanırım sırayla işlenir.
contract Loot {
    GamiBox gamiBox;
    address public tokensSeller = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    //private olcak servers seed
    uint256 public server_seed;
    //struct kaldırıp mappinglerden yürünebilir, ya da mapping yerine structa arrayi koymanın yolu buunur
    //strcutı yoruma al, mappinglerin uitnini boxid olarak kullanarak ilerle box[boxId] den kurtul
    /* struct Box {
        uint256 keyId;
        uint8[] items;
        uint24[] odds;
        uint24[] typeOdds;
        uint8[] typeCounts;
    } */

    //mapping(uint256 => Box) box;

    mapping(uint256 => uint256) boxKeys;
    mapping(uint256 => uint256[]) boxItems;
    mapping(uint256 => uint256[]) odds;
    mapping(uint256 => uint256[]) typeOdds;
    mapping(uint256 => uint256[]) typeCounts;

    //dışarıdan lootu approvelamam lazım
    constructor(address _gamiBox) {
        server_seed = (block.timestamp + block.difficulty) % 10000000;
        gamiBox = GamiBox(_gamiBox);

        /* uint8[16] memory boxItems;
        uint24[16] memory forOdds;
        uint24[5] memory forTypeOdds;
        uint8[5] memory forTypeCounts; */

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

        /*  uint8[17] memory boxItems0;
        uint24[17] memory forOdds0;
        uint24[6] memory forTypeOdds0;
        uint8[6] memory forTypeCounts0; */

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

        // type odds 7992328, 1598465, 319693, 63939, 25575
        /*3*/
        /* box[3] = Box(
            1,
            boxItems,
            forOdds,
            forTypeOdds,
            forTypeCounts
        );
       
        /*4
        box[4] = Box(
            1,
            boxItems[1],
            forOdds[1],
            forTypeOdds[1],
            forTypeCounts[1]
        );
        /*5
        box[5] = Box(
            2,
            boxItems[2],
            forOdds[2],
            forTypeOdds[2],
            forTypeCounts[2]
        ); */
    }

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
    }
}
