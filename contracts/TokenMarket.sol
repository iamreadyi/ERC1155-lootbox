//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./GamiBox.sol";

/// @title Market for ERC1155 tokens, for testing
/// @dev tokensSeller should approve Market contract.

contract Market {
    GamiBox gamiBox;

    address public tokensSeller = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;

    constructor(address _gamiBox) {
        gamiBox = GamiBox(_gamiBox);
    }

    function buyToken(uint256 id) public {
        gamiBox.safeTransferFrom(tokensSeller, msg.sender, id, 1, "");
    }
}
