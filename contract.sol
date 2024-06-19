// users creates a camppaign
// users can pledge,
// 

// is total amount is pledged more than the campaign goal

// if the total amount pledged is less the users can withdraww their pledge. 


// we need a event for lauching the process

///// the launch consists of id,creator address,startTime,endTime,goal


/// need to take IERC20 transfer and transferFrom functions

/// then we need events like cancel.pledge ,unpledge,refund



/// the campaign consists of creator goal and startTime and endTime  and a boolean for claimed

// mapping id to campaign

// mapping campingId to pledger to amount pledged



//code starts

// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

interface IERC20 {
    function transfer(address, uint256) external returns (bool);
    function transferFrom(address, address, uint256) external returns (bool);
}

contract crowdFund {

    event Launch(uint256 id, address creator, uint256 goal, uint32 startTime, uint32 endTime);
    event Cancel(uint256 id);
    event Pledge(uint256 id, address caller, uint256 amount);
    event Unpledge(uint256 id, address caller, uint256 amount);
    event Claim(uint256 id);
    event Refund(uint256 id, address caller, uint256 amount);

    struct Campaign {
        address creator;
        uint256 goal;
        uint256 pledged;
        uint32 startTime;
        uint32 endTime;
        bool claimed;
    }

    IERC20 public immutable token;
    uint256 public count;

    mapping(uint256 => Campaign) public campaigns;
    mapping(uint256 => mapping(address => uint256)) public pledgedAmount;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint256 _goal, uint32 _startTime, uint32 _endTime) external {
        require(_startTime >= block.timestamp, "start time is in the past");
        require(_endTime >= _startTime, "end time is befor  e start time");

        count += 1;

        campaigns[count] = Campaign({
            creator: msg.sender,
            goal: _goal,
            pledged: 0,
            startTime: _startTime,
            endTime: _endTime,
            claimed: false
        });

        emit Launch(count, msg.sender, _goal, _startTime, _endTime);
    }

    function cancel(uint256 _id) external {
        Campaign memory campaign = campaigns[_id];

        require(campaign.creator == msg.sender, "not creator");
        require(block.timestamp < campaign.startTime, "already started");

        delete campaigns[_id];

        emit Cancel(_id);
    }

    function pledge(uint256 _id, uint256 _amount) external {
        Campaign storage campaign = campaigns[_id];

        require(block.timestamp >= campaign.startTime, "not started yet");
        require(block.timestamp <= campaign.endTime, "already ended");

        campaign.pledged += _amount;
        pledgedAmount[_id][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_id, msg.sender, _amount);
    }

    function unpledge(uint256 _id, uint256 _amount) external {
        Campaign storage campaign = campaigns[_id];

        require(block.timestamp >= campaign.startTime, "not started yet");
        require(block.timestamp <= campaign.endTime, "already ended");

        campaign.pledged -= _amount;
        pledgedAmount[_id][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledge(_id, msg.sender, _amount);
    }

    function claim(uint256 _id) external {
        Campaign storage campaign = campaigns[_id];

        require(campaign.creator == msg.sender, "not creator");
        require(block.timestamp > campaign.endTime, "campaign not ended");
        require(campaign.pledged >= campaign.goal, "pledged amount less than goal");
        require(!campaign.claimed, "already claimed");

        campaign.claimed = true;
        token.transfer(campaign.creator, campaign.pledged);

        emit Claim(_id);
    }

    function refund(uint256 _id) external {
        Campaign memory campaign = campaigns[_id];
        require(block.timestamp > campaign.endTime, "not ended");
        require(campaign.pledged < campaign.goal, "pledged amount meets goal");

        uint256 bal = pledgedAmount[_id][msg.sender];
        pledgedAmount[_id][msg.sender] = 0;
        token.transfer(msg.sender, bal);

        emit Refund(_id, msg.sender, bal);
    }
}







