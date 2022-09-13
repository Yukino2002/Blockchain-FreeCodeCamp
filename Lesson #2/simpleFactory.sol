// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <=0.9.0;

import "../Lesson #1/simpleStorage.sol";

contract simpleFactory is simpleStorage {

    simpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        simpleStorage newSimpleStorage = new simpleStorage();
        simpleStorageArray.push(newSimpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _favouriteNumber) public {
        simpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(_favouriteNumber);
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns(uint256) {
        return simpleStorage(address(simpleStorageArray[_simpleStorageIndex])).retrieve();
    } 
}