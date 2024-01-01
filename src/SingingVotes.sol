// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SingingVotes {
    mapping (bytes32 => uint8) public votesReceived;
    bytes32[] public singerList;

    constructor(bytes32[] memory _singerNames) {
        singerList = _singerNames;
    }

    function totalVotesFor(bytes32 _singer) external view returns (uint8) {
        require(isValidSinger(_singer), "Invalid singer");
        return votesReceived[_singer];
    }

    function voteForSinger(bytes32 _singer) external {
        require(isValidSinger(_singer), "Invalid singer");
        votesReceived[_singer]++;
    }

    function isValidSinger(bytes32 _singer) public view returns (bool) {
        for(uint i = 0; i < singerList.length; i++) {
            if (singerList[i] == _singer) {
                return true;
            }
        }
        return false;
    }
}
