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

contract FundMe {
    address public owner;

    // visiibilty of constructor is not needed by default
    constructor() {
        owner = msg.sender;
    }

    // amount of money sent to the smart contract
    mapping(address => uint256) public addressToAmountFunded;
    address[] public funders;

    // like decorator, pass as type with the function itself
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    // payable type function
    function fund() public payable {
        uint256 minimumUSD = 50 * 1e18;
        // sends a revert message showing error if requirement is not met
        require(
            getConversionRate(msg.value) >= minimumUSD,
            "You need to spend more ETH!"
        );
        // msg.sender and msg.value are keywords as
        addressToAmountFunded[msg.sender] += msg.value;
        funders.push(msg.sender);
    }

    function withdraw() public payable onlyOwner {
        // msg.sender is the address of the person who called the function
        address payable recipent = payable(msg.sender);
        recipent.transfer(address(this).balance);
        for (uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
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
        return uint256(answer * 1e10);
    }

    function getConversionRate(uint256 amount) public view returns (uint256) {
        uint256 price = getPrice();
        uint256 conversion = (amount * price) / 1e18;
        return conversion;
    }
}
