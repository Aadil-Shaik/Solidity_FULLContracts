    // SPDX-License-Identifier: GPL-3.0

    pragma solidity >=0.5.0 <0.9.0;

    contract DecentralizedElection{
        
        address organiser=msg.sender;
        mapping(address=>uint) voters;
        uint registrationTimePeriod;
        uint votingTimePeriod;

        constructor(uint _registrationTimePeriod,uint _votingTimePeriod){                               //you give registration timeperiod and voting timeperiod in seconds with a comma
            registrationTimePeriod = block.timestamp + _registrationTimePeriod;
            votingTimePeriod = block.timestamp + _registrationTimePeriod + _votingTimePeriod;
        }

        struct Candidate{
            string name;
            uint noOfVotes;
        }
        mapping(uint=>Candidate) public candidates;
        uint public NumberOfTheLastCandidate;



        function registerAsCandidate(string memory _name) public{
            require(block.timestamp< registrationTimePeriod , "Registration Time's up");
            Candidate storage newcandidate = candidates[NumberOfTheLastCandidate];
            NumberOfTheLastCandidate++;

            newcandidate.name = _name;
        }

        function showCandidates(uint _number) public view returns(string memory){
            string memory nameofcandidate= candidates[_number].name;
            return nameofcandidate;
        }
    
        function voteNow(uint _number) public payable returns(string memory){
            require(block.timestamp > registrationTimePeriod , "Voting has not yet started" );
            require(block.timestamp < votingTimePeriod , "Voting has already completed");
            require(voters[msg.sender]==0 , "You have already voted !");
            Candidate storage newcandidate = candidates[_number];
            newcandidate.noOfVotes++;
            voters[msg.sender]=1;
            return "Voting successful";
        }

        function declareResult() public view returns(string memory) {
            require(block.timestamp > votingTimePeriod , "Voting is still goingon.Please wait until voting finishes");
            uint i;
            Candidate storage newcandidate = candidates[i];
            uint max;
            string memory winnerName;
            for(i ; i < NumberOfTheLastCandidate ; i++){
                Candidate storage newcandidate = candidates[i];
                if(newcandidate.noOfVotes > max){
                    max = newcandidate.noOfVotes;
                }
                if(newcandidate.noOfVotes == max){
                    winnerName= newcandidate.name;
                }
            }
            return winnerName;
        }

    }