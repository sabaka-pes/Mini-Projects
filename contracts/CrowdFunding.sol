// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IERC20.sol";

contract Crowd {
    struct Campaign {
        address owner;
        uint goal;
        uint pledged;
        uint startAt;
        uint endAt;
        bool claimed;
    }

    IERC20 public immutable token;
    mapping(uint => Campaign) public campaigns;
    uint public currentId;
    mapping(uint => mapping(address => uint)) public pledges;
    uint public constant MAX_DURATION = 100 days;
    uint public constant MIN_DURATION = 10;

    event Launched(uint indexed id, address indexed owner, uint goal, uint startAt, uint endAt);
    event Cancel(uint indexed id);
    event Pledged(uint indexed id, address indexed pledger, uint amount);
    event Unpledged(uint indexed id, address indexed pledger, uint amount);
    event Claimed(uint indexed id);
    event Refunded(uint indexed id, address indexed refundee, uint amount);

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint _goal, uint _startAt, uint _endAt) external {
        require(_startAt >= block.timestamp, "incorrect start at");
        require(_endAt >= _startAt + MIN_DURATION, "incorrect end at");
        require(_endAt <= _startAt + MAX_DURATION, "too long");

        campaigns[currentId] = Campaign({
            owner: msg.sender,
            goal: _goal,
            pledged: 0,
            startAt: _startAt,
            endAt: _endAt,
            claimed: false
        });

        emit Launched(currentId, msg.sender, _goal, _startAt, _endAt);
        currentId += 1;
    }

    function cancel(uint _id) external {
        Campaign memory campaign = campaigns[_id];
        require(msg.sender == campaign.owner, "not an owner");
        require(block.timestamp < campaign.startAt, "already started");

        delete campaigns[_id];
        emit Cancel(_id);
    }

    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp >= campaign.startAt, "not started");
        require(block.timestamp < campaign.endAt, "ended");

        campaign.pledged += _amount;
        pledges[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledged(_id, msg.sender, _amount);
    }

    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp < campaign.endAt, "ended");

        campaign.pledged -= _amount;
        pledges[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledged(_id, msg.sender, _amount);
    }

    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.owner, "not an owner");
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged >= campaign.goal, "pledged is too low");
        require(!campaign.claimed, "already claimed");

        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledged);
        emit Claimed(_id);
    }

    function refund(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        require(block.timestamp > campaign.endAt, "not ended");
        require(campaign.pledged < campaign.goal, "reached goal");
    
        uint pledgedAmount = pledges[_id][msg.sender];
        pledges[_id][msg.sender] = 0;
        
        token.transfer(msg.sender, pledgedAmount);

        emit Refunded(_id, msg.sender, pledgedAmount);
    }
}