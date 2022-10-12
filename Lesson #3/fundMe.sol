// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <=0.9.0;

// import "@chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"
interface AggregatorV3Interface {
    // interfaces compile down to an ABI, defines how solidity can iteract with the contract
    // which functions it can use and call
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    function getRoundData(uint80 _roundId) external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );

    function latestRoundData() external view returns (
        uint80 roundId,
        int256 answer,
        uint256 startedAt,
        uint256 updatedAt,
        uint80 answeredInRound
    );
}

contract fundMe {
    // amount of money sent to the smart contract
    mapping(address => uint256) public addressToAmountFunded;

    // payable type function
    function fund() public payable {
        // msg.sender and msg.value are keywords as
        addressToAmountFunded[msg.sender] += msg.value;
    }

    // USD as currency, ETH -> USD conversion rate, using Oracles
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);
        priceFeed.version();
    }
}
