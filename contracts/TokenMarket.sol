//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./GamiBox.sol";

/// @title Market for ERC1155 tokens, for testing
/// @dev tokensSeller should approve Market contract.

contract Market {
    GamiBox gamiBox;

    address public tokensSeller = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;

    constructor(address _gamiBox) {
        gamiBox = GamiBox(_gamiBox);
    }

    function buyToken(uint256 id) public {
        gamiBox.safeTransferFrom(tokensSeller, msg.sender, id, 1, "");
    }
}
