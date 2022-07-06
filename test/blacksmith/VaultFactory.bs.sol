// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/VaultFactory.sol";
contract VaultFactoryBS {
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
    function deploy() public  startPrank stop returns (address payable) {
        return VaultFactory(proxiedContract).deploy();
    }

	function deployFor(address _owner) public  startPrank stop returns (address payable) {
        return VaultFactory(proxiedContract).deployFor(_owner);
    }

	function getNextAddress(address _deployer) public  startPrank stop returns (address) {
        return VaultFactory(proxiedContract).getNextAddress(_deployer);
    }

	function getNextSeed(address _deployer) public  startPrank stop returns (bytes32) {
        return VaultFactory(proxiedContract).getNextSeed(_deployer);
    }

	function implementation() public  startPrank stop returns (address) {
        return VaultFactory(proxiedContract).implementation();
    }
}
