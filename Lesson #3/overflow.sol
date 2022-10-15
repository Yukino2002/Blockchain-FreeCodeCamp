// SPDX-License-Identifier: MIT

pragma solidity 0.6.0;

// prior to version 0.8 integer overflow could not be handled
// the integer wraps around itself
contract Overflow {
    function overflow() public pure returns (uint8) {
        uint8 max = 255 + uint8(1);
        // this returns 0
        return max;
    }
}
