// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Lottery{
    address public manager;
    address payable[] public participants;

    constructor() {
        manager = msg.sender;                  //Global variable
    }

    receive() external payable{                //Special type of function , usable only once
        require(msg.value==2 ether);           //Minimum this much needed for the parfticipant to be pushed into the array
        participants.push(payable(msg.sender));
    } 
    
    function getBalance() public view returns(uint){
        require(msg.sender==manager);          //Account(address)(in DEPLOY & RUN TRANSACTIONS SECTION) shoould be admin to view balance. If you are viewing this contract from a participant's account then you can't
        return address(this).balance;
    } 
    function generateRandom() public view returns(uint){
        return uint(keccak256(abi.encodePacked(block.difficulty,block.timestamp,participants.length)));
    }  

    function SelectWinner() public {
        require(msg.sender==manager);
        require(participants.length>=3);
        uint r = generateRandom();
        uint i = r%participants.length;
        address payable winner = participants[i];
        winner.transfer(getBalance());
        participants = new address payable[](0); //Resetting participants array
    }
}