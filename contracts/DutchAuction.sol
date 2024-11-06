// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DutchAuction {
    uint private constant DURATION = 1 days;
    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable endsAt;
    uint public immutable discountRate;
    string public item;
    bool public stoped;

    constructor(
        uint _startingPrice,
        uint _discountRate,
        string memory _item
    ) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        discountRate = _discountRate;
        startAt = block.timestamp;
        endsAt = block.timestamp + DURATION;

        require(
            startingPrice >= _discountRate * DURATION,
            "starting price and discount is incorrect "
        );

        item = _item;
    }

    modifier notStoped() {
        require(!stoped, "stoped");
        _;
    }

    function getPrice() public view notStoped returns (uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;

        return startingPrice - discount;
    }

    function buy() external payable notStoped {
        require(block.timestamp < endsAt, "ended");

        uint price = getPrice();

        require(msg.value >= price, "not enough founds");

        uint refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }

        seller.transfer(address(this).balance);
        stoped = true;
    }
}