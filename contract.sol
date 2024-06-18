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

interface IERC20 {
  function transfer(address,uint256) external returns (bool);
  function transferFrom(address,address,uint256) external returns (bool);

}




contract crowdFund {


  event launch(uint256 id,address creator,uint256 goal,uint32 startTime,uint256 endTime);

  event cancel(uint256 _id);

  event pledge(uint256 id,address caller,uint256 amount);

  //event unpledge(uint256 id,address caller,uint256 amount);

  event claim(uint256 id);

  event refund(uint256 id,address caller,uint256 amount);



  // our campain have a struct

  struct campaign 
  {
    //we have a creator

    address creator;

    // amount of tokens to raise

    uint256 goal;

    // amount pledged
  
  
    uint32 startTime;
  
    uint32 endTime;

    bool claimed;
   }

  IERC20 public immutable token;

  uint256 public count;

  mapping(uint256 => campaign) public campaigns;

  mapping(uint256 => mapping(address => uint256)) public pledgedAmount;

 
   constructor(address _token) {
      token = IERC20(_token);
   }




   // the functions we need to code

  
   function launch(uint256 _goal,uint32 _starttime,uint32 _endtime) external {
    require(_starttime >= block.timestamp,"start time is in the past i wont allow");
    require(_endtime >= _starttime,"we cannot end in the past right");
  
    // we can also put a max duration of the endtime

    count = count + 1;

    campaigns[count] = campaign({
      creator: msg.sender,
      goal: _goal ,
      startTime: _starttime,
      endTime: _endtime,
      claimed: false

    });

  emit launch(count,msg.sender,_goal,_starttime,_endtime);
   


   }




   function cancel(uint256 _id) external {
   campain memory campaign = campaigns[_id];

   require(campaign.creator == msg.sender,"not creator");
   require(block.timestamp < campaign.startTime,"Already started");

   delete campain[_id];

   emit cancel(_id);



   }



   
   function Pledge(uint256 _id,uint256 _amount) external {
    campaign storage campaign = campaigns[_id];

    require(block.timestamp >= campaign.startTime,"not started at");
    require(block.timestamp <= campaign.endTime,"ended");
    

    campaign.pledged += _amount;
    pledgedAmount[_id][msg.sender] += _amount;
    token.transferFrom(msg.sender, address(this),_amount);

    emit pledge(_id,msg.sender,_amount);

   }

   //function Unpledge();

  function Claim(uint256 _id) external {
    campaign storage campaign = campaigns[_id];
    require(campaign.creator == msg.sender,"not creator");
    require(block.timestamp > campaign.endTime,"the campain not ended");
    require(campaign.pledged >= campaign.goal,"pledeged < goal");
    require(!campain.claimed,"claimed");

    campain.claimed = true;
    token.transfer(campaign.creator,campaign.pledged);


  }

  


  function refund(uint256 _id, address _caller,uint256 _amount) external {
    
    campaign memory campain = campaigns[_id];
    require(block.timestamp > campaign.endAt,"not ended");
    require(campaign.pledged < campaign.goal,"pledged >= goal");

   uint256 bal = pledgedAmount[_id][msg.sender];
   pledgedAmount[_id][msg.sender] = 0;
   token.transfer(msg.sender,bal);
  }



  }







