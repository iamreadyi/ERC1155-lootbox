// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

/// @title Lootbox tokens

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";

contract GamiBox is ERC1155, Ownable, ERC1155Burnable {
    string public name;
    string public symbol;

    /// @dev Stores token ids to map them to token classes.
    mapping(uint256 => uint256[]) public tokenTypes;

    uint256 gamiToken = 1000 * 10**18;
    uint256 key = 10**6;
    uint256 box = 10**6;
    uint256 standard = 10**5;
    uint256 common = 10**4;
    uint256 rare = 10**3;
    uint256 epic = 10**2;
    uint256 legendary = 10;
    uint256 founders = 1;

    /// @dev Stores token classes for batch mint.
    uint256[] public _amounts = [
        gamiToken,
        key,
        key,
        box,
        box,
        box,
        standard,
        standard,
        standard,
        standard,
        standard,
        standard,
        common,
        common,
        common,
        common,
        rare,
        rare,
        rare,
        epic,
        epic,
        epic,
        epic,
        epic,
        epic,
        legendary,
        legendary,
        legendary,
        founders,
        founders
    ];

    uint256 public hold = 0;

    /// @dev Mints first batch of tokens and assigns token's uri.

    constructor() ERC1155("https://game.example/api/item/{id}.json") {
        name = "Gami Box";
        symbol = "GAMI";

        tokenTypes[0] = [0]; //1000 * 10 ** 18 gamiToken
        tokenTypes[1] = [1, 2]; //10 ** 6 key
        tokenTypes[2] = [3, 4, 5]; //10 ** 6 box
        tokenTypes[3] = [6, 7, 8, 9, 10, 11]; //10 ** 5 standard
        tokenTypes[4] = [12, 13, 14, 15]; //10 ** 4 common
        tokenTypes[5] = [16, 17, 18]; //10 ** 3 rare
        //standard, common, rare her box'ta var, diğerleri her boxa özel
        tokenTypes[6] = [19, 20, 21, 22, 23, 24]; //10 ** 2 epic
        tokenTypes[7] = [25, 26, 27]; //10 legendary
        tokenTypes[8] = [28, 29]; //1 founders

        uint256[] memory _ids = new uint256[](30);

        /// @dev Fills _id memory array with token id's of every class to pass into mintBatch.

        for (uint256 i = 0; i < 9; i++) {
            for (uint256 j = 0; j < tokenTypes[i].length; j++) {
                _ids[hold] = tokenTypes[i][j];
                hold++;
            }
        }

        _mintBatch(msg.sender, _ids, _amounts, "");
    }

    /// @dev Gives owner to chance to assign different uri to tokens.

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    /// @dev Gives owner to chance to mint new tokens.
    function mint(
        address account,
        uint256 id,
        uint256 amount,
        bytes memory data
    ) public onlyOwner {
        _mint(account, id, amount, data);
    }

    function mintBatch(
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) public onlyOwner {
        _mintBatch(to, ids, amounts, data);
    }
}
