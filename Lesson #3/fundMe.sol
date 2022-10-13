// SPDX-License-Identifier: MIT

pragma solidity >=0.6.6 <=0.9.0;

// import "@chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol"
interface AggregatorV3Interface {
    // interfaces compile down to an ABI, defines how solidity can interact with the contract
    // provides a minimalistic view of an external contract
    function decimals() external view returns (uint8);

    function description() external view returns (string memory);

    function version() external view returns (uint256);

    function getRoundData(uint80 _roundId)
        external
        view
        returns (
            uint80 roundId,
            int256 answer,
            uint256 startedAt,
            uint256 updatedAt,
            uint80 answeredInRound
        );

    function latestRoundData()
        external
        view
        returns (
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
        // goerli testnet address
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );
        return priceFeed.version();
    }

    function getPrice() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e
        );

        // use commas to ignore values you don't need
        (, int256 answer, , , ) = priceFeed.latestRoundData();

        // type casting to approviate type
        return uint256(answer);
    }
}
