// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding{
    mapping(address=>uint) public Contributors;
    address public Manager;
    uint public MinimumContribution;
    uint public Deadline;
    uint public Target;
    uint public RaisedAmount;                                                                  //But this is the same as ContractBalance() fucntion
    uint public NumberOfContributors;

    //-----------------------------------------------------------------------------------------------------------
    
    struct Request{
        string Description;
        address payable Recipient;
        uint value;
        bool CompletionStatus;
        uint NumberOfVoters;
        mapping(address=>bool) Voters;
    }

    mapping(uint=>Request) public Requests;
    uint public NumberOfTheRequest;

    modifier onlyManager(){
        require(msg.sender==Manager,"Only the manager can call this function");
        _;
    }

    function CreateRequests(string memory _Description,address payable _Recipient,uint _value) public onlyManager{
        Request storage newRequest = Requests[NumberOfTheRequest];                                    //a new variable of type Request(structure) and to use that we use storage keyword becz you can't use memory keyword
        NumberOfTheRequest++;                                                                         // storage is used because you want to store the values of newRequest directly in Request not temporarily as in memory

        newRequest.Description = _Description;
        newRequest.Recipient = _Recipient;
        newRequest.value = _value;
        newRequest.CompletionStatus = false;
        newRequest.NumberOfVoters = 0;
    }

    function voteRequest(uint _requestNumber) public{
        require(Contributors[msg.sender]>0,"You must be a Contributor");
        Request storage thisRequest =  Requests[_requestNumber];
        require(thisRequest.Voters[msg.sender]==false,"You have already voted");
        thisRequest.Voters[msg.sender]=true;
        thisRequest.NumberOfVoters++;   
    }

    function makePayment(uint _NumberOfTheRequest) public onlyManager{
        require(RaisedAmount >= Target);
        Request storage thisRequest = Requests[_NumberOfTheRequest];
        require(thisRequest.CompletionStatus == false, "The Donation request has already been completed");
        require(thisRequest.NumberOfVoters > NumberOfContributors/2,"Majority votes needed");
        thisRequest.Recipient.transfer(thisRequest.value);
        thisRequest.CompletionStatus = true ;
    }

    //-----------------------------------------------------------------------------------------------------------

    constructor(uint _Target,uint _Deadline){
        Target = _Target;
        Deadline = block.timestamp+_Deadline;                                                       //add time in seconds e.g: 1hr = 3600 sec
        MinimumContribution = 1000 wei;
        Manager = msg.sender;
    }

    function Contribute() public payable{
        require(block.timestamp < Deadline ,"Deadline has passed");
        require(msg.value >= MinimumContribution ,"Minimum amount to Contribute is 1000 wei");      //msg.value

        if(Contributors[msg.sender]==0){                                                            //checking if its the same contributor contributing more amoutnt
                                                                                                    //if not then increase the number of contributors by one
            NumberOfContributors++;
        }

        Contributors[msg.sender] += msg.value;                                                      //Regardless of how many'th time he is contributing, We increase-
        RaisedAmount += msg.value;                                                             //the total amount contributed by this particular address (denoted by msg.sender)
    }

    function ContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function Refund() public{
        require(block.timestamp >= Deadline && RaisedAmount < Target ,"You cannot avail refund as of now");
        require(Contributors[msg.sender]>0);
        address payable user = payable(msg.sender);                                                 //making the user's address payable explicitly
        user.transfer(Contributors[msg.sender]);
    }


}