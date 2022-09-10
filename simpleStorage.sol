// SPDX-License-Identifier: MIT

// define solidity version
// implement a range, a specific version, or a set of versions(^)
pragma solidity >=0.6.0 <0.9.0;

// define a contract
contract simpleStorage {
    // different variable types, bool, string, int256, address, bytes32 etc.
    // initialization by default sets variable to 0 
    uint256 favouriteNumber;

    // public, internal, external private, default state internal
    function store(uint256 _favouriteNumber) public {
        favouriteNumber = _favouriteNumber; 
    }

    // view, pure
    function retrieve() public view returns(uint256) {
        return favouriteNumber;
    }
}