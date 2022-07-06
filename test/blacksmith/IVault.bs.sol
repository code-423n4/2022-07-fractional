// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/IVault.sol";
contract IVaultBS {
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
    function execute(address _target, bytes memory _data, bytes32[] memory _proof) public payable  startPrank stop returns (bool, bytes memory) {
        return IVault(proxiedContract).execute{value: msg.value}(_target, _data, _proof);
    }

	function init() public  startPrank stop  {
        IVault(proxiedContract).init();
    }

	function install(bytes4[] memory _selectors, address[] memory _plugins) public  startPrank stop  {
        IVault(proxiedContract).install(_selectors, _plugins);
    }

	function merkleRoot() public  startPrank stop returns (bytes32) {
        return IVault(proxiedContract).merkleRoot();
    }

	function methods(bytes4 arg0) public  startPrank stop returns (address) {
        return IVault(proxiedContract).methods(arg0);
    }

	function nonce() public  startPrank stop returns (uint256) {
        return IVault(proxiedContract).nonce();
    }

	function owner() public  startPrank stop returns (address) {
        return IVault(proxiedContract).owner();
    }

	function setMerkleRoot(bytes32 _rootHash) public  startPrank stop  {
        IVault(proxiedContract).setMerkleRoot(_rootHash);
    }

	function transferOwnership(address _newOwner) public  startPrank stop  {
        IVault(proxiedContract).transferOwnership(_newOwner);
    }

	function uninstall(bytes4[] memory _selectors) public  startPrank stop  {
        IVault(proxiedContract).uninstall(_selectors);
    }
}
