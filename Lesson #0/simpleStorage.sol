// SPDX-License-Identifier: MIT

// define solidity version
// implement a range, a specific version, or a set of versions(^)
pragma solidity >=0.6.0 <0.9.0;

// define a contract
contract simpleStorage {
    // variable types: bool, string, int256, address, bytes32 etc.
    // initialization by default sets variable to 0 
    uint256 favouriteNumber;

    // access modifiers: public, internal, external private, default state internal
    function store(uint256 _favouriteNumber) public {
        favouriteNumber = _favouriteNumber; 
    }

    // function type: view: do not make a state change, pure
    function retrieve() public view returns(uint256) {
        return favouriteNumber;
    }

    // structures
    // storing variables is always done in a numeric indexed manner
    struct People {
        uint256 favouriteNumber;
        string name;
    }

    // dynamic arrays, static: specify size in square brackets
    People[] public people;

    // maps
    mapping(string => uint256) public nameToFavouriteNumber;

    function addPerson(string memory _name, uint256 _favouriteNumber) public {
        people.push(People(_favouriteNumber, _name));
        nameToFavouriteNumber[_name] = _favouriteNumber;
    }
}