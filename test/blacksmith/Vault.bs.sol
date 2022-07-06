// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/Vault.sol";
contract VaultBS {
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
        return Vault(proxiedContract).execute{value: msg.value}(_target, _data, _proof);
    }

	function init() public  startPrank stop  {
        Vault(proxiedContract).init();
    }

	function install(bytes4[] memory _selectors, address[] memory _plugins) public  startPrank stop  {
        Vault(proxiedContract).install(_selectors, _plugins);
    }

	function merkleRoot() public  startPrank stop returns (bytes32) {
        return Vault(proxiedContract).merkleRoot();
    }

	function methods(bytes4 arg0) public  startPrank stop returns (address) {
        return Vault(proxiedContract).methods(arg0);
    }

	function nonce() public  startPrank stop returns (uint256) {
        return Vault(proxiedContract).nonce();
    }

	function onERC1155BatchReceived(address arg0, address arg1, uint256[] memory arg2, uint256[] memory arg3, bytes memory arg4) public  startPrank stop returns (bytes4) {
        return Vault(proxiedContract).onERC1155BatchReceived(arg0, arg1, arg2, arg3, arg4);
    }

	function onERC1155Received(address arg0, address arg1, uint256 arg2, uint256 arg3, bytes memory arg4) public  startPrank stop returns (bytes4) {
        return Vault(proxiedContract).onERC1155Received(arg0, arg1, arg2, arg3, arg4);
    }

	function onERC721Received(address arg0, address arg1, uint256 arg2, bytes memory arg3) public  startPrank stop returns (bytes4) {
        return Vault(proxiedContract).onERC721Received(arg0, arg1, arg2, arg3);
    }

	function owner() public  startPrank stop returns (address) {
        return Vault(proxiedContract).owner();
    }

	function setMerkleRoot(bytes32 _rootHash) public  startPrank stop  {
        Vault(proxiedContract).setMerkleRoot(_rootHash);
    }

	function transferOwnership(address _newOwner) public  startPrank stop  {
        Vault(proxiedContract).transferOwnership(_newOwner);
    }

	function uninstall(bytes4[] memory _selectors) public  startPrank stop  {
        Vault(proxiedContract).uninstall(_selectors);
    }
}
