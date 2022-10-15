// SPDX-License-Identifier: MIT

pragma solidity >=0.6.0 <=0.9.0;

// import other created contracts
import "../Lesson #1/simpleStorage.sol";

// 'is' keyword is used to inherit from other contracts
contract SimpleFactory is SimpleStorage {
    SimpleStorage[] public simpleStorageArray;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorage = new SimpleStorage();
        simpleStorageArray.push(newSimpleStorage);
    }

    function sfStore(uint256 _simpleStorageIndex, uint256 _favouriteNumber)
        public
    {
        // we need to the address of the contract we want to interact with
        // ABI: Application Binary Interface
        SimpleStorage(address(simpleStorageArray[_simpleStorageIndex])).store(
            _favouriteNumber
        );
    }

    function sfGet(uint256 _simpleStorageIndex) public view returns (uint256) {
        return
            SimpleStorage(address(simpleStorageArray[_simpleStorageIndex]))
                .retrieve();
    }
}
