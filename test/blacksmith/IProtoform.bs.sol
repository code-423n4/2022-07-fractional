// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/IProtoform.sol";
contract IProtoformBS {
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
    function deployVault(uint256 _fAmount, address[] memory _modules, address[] memory _plugins, bytes4[] memory _selectors, bytes32[] memory _proof) public  startPrank stop returns (address) {
        return IProtoform(proxiedContract).deployVault(_fAmount, _modules, _plugins, _selectors, _proof);
    }

	function generateMerkleTree(address[] memory _modules) public  startPrank stop returns (bytes32[] memory) {
        return IProtoform(proxiedContract).generateMerkleTree(_modules);
    }
}
