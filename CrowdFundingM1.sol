// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract CrowdFunding{
    mapping(address=>uint) public Contributors;
    address public Manager;
    uint public MinimumContribution;
    uint public Deadline;
    uint public Target;
    uint public TotalContribution;                                                                  //But this is the same as ContractBalance() fucntion
    uint public NumberOfContributors;

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
        TotalContribution += msg.value;                                                             //the total amount contributed by this particular address (denoted by msg.sender)
    }

    function ContractBalance() public view returns(uint){
        return address(this).balance;
    }

    function Refund() public{
        require(block.timestamp >= Deadline && TotalContribution < Target ,"You cannot avail refund as of now");
        require(Contributors[msg.sender]>0);
        address payable user = payable(msg.sender);                                                 //making the user's address payable explicitly
        user.transfer(Contributors[msg.sender]);
    }


}