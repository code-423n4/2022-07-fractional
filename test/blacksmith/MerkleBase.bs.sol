// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/utils/MerkleBase.sol";
contract MerkleBaseBS {
    Bsvm constant bsvm = Bsvm(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);
    address addr;
    uint256 privateKey;
    address payable proxiedContract;

    constructor( address _addr, uint256 _privateKey, address _target) {
        addr = _privateKey == 0 ? _addr : bsvm.addr(_privateKey);
        privateKey = _privateKey;
        proxiedContract = payable(_target);
    }
    modifier prank() {
        bsvm.prank(addr,addr);
        _;
    }
    modifier startPrank() {
        bsvm.startPrank(addr,addr);
        _;
    }
    modifier stop(){
        _;
        bsvm.stopPrank();
    }
    function proxyContract() external view returns (address) {
        return proxiedContract;
    }
    function getProof(bytes32[] memory _data, uint256 _node) public  startPrank stop returns (bytes32[] memory) {
        return MerkleBase(proxiedContract).getProof(_data, _node);
    }

	function getRoot(bytes32[] memory _data) public  startPrank stop returns (bytes32) {
        return MerkleBase(proxiedContract).getRoot(_data);
    }

	function hashLeafPairs(bytes32 _left, bytes32 _right) public  startPrank stop returns (bytes32) {
        return MerkleBase(proxiedContract).hashLeafPairs(_left, _right);
    }

	function log2ceil_naive(uint256 x) public  startPrank stop returns (uint256) {
        return MerkleBase(proxiedContract).log2ceil_naive(x);
    }

	function verifyProof(bytes32 _root, bytes32[] memory _proof, bytes32 _valueToProve) public  startPrank stop returns (bool) {
        return MerkleBase(proxiedContract).verifyProof(_root, _proof, _valueToProve);
    }
}
