// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/modules/protoforms/BaseVault.sol";
contract BaseVaultBS {
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
    function batchDepositERC1155(address _from, address _to, address[] memory _tokens, uint256[] memory _ids, uint256[] memory _amounts, bytes[] memory _datas) public  startPrank stop  {
        BaseVault(proxiedContract).batchDepositERC1155(_from, _to, _tokens, _ids, _amounts, _datas);
    }

	function batchDepositERC20(address _from, address _to, address[] memory _tokens, uint256[] memory _amounts) public  startPrank stop  {
        BaseVault(proxiedContract).batchDepositERC20(_from, _to, _tokens, _amounts);
    }

	function batchDepositERC721(address _from, address _to, address[] memory _tokens, uint256[] memory _ids) public  startPrank stop  {
        BaseVault(proxiedContract).batchDepositERC721(_from, _to, _tokens, _ids);
    }

	function deployVault(uint256 _fractionSupply, address[] memory _modules, address[] memory _plugins, bytes4[] memory _selectors, bytes32[] memory _mintProof) public  startPrank stop returns (address) {
        return BaseVault(proxiedContract).deployVault(_fractionSupply, _modules, _plugins, _selectors, _mintProof);
    }

	function generateMerkleTree(address[] memory _modules) public  startPrank stop returns (bytes32[] memory) {
        return BaseVault(proxiedContract).generateMerkleTree(_modules);
    }

	function getLeafNodes() public  startPrank stop returns (bytes32[] memory) {
        return BaseVault(proxiedContract).getLeafNodes();
    }

	function getPermissions() public  startPrank stop returns (Permission[] memory) {
        return BaseVault(proxiedContract).getPermissions();
    }

	function getProof(bytes32[] memory _data, uint256 _node) public  startPrank stop returns (bytes32[] memory) {
        return BaseVault(proxiedContract).getProof(_data, _node);
    }

	function getRoot(bytes32[] memory _data) public  startPrank stop returns (bytes32) {
        return BaseVault(proxiedContract).getRoot(_data);
    }

	function hashLeafPairs(bytes32 _left, bytes32 _right) public  startPrank stop returns (bytes32) {
        return BaseVault(proxiedContract).hashLeafPairs(_left, _right);
    }

	function log2ceil_naive(uint256 x) public  startPrank stop returns (uint256) {
        return BaseVault(proxiedContract).log2ceil_naive(x);
    }

	function multicall(bytes[] memory _data) public  startPrank stop returns (bytes[] memory) {
        return BaseVault(proxiedContract).multicall(_data);
    }

	function registry() public  startPrank stop returns (address) {
        return BaseVault(proxiedContract).registry();
    }

	function supply() public  startPrank stop returns (address) {
        return BaseVault(proxiedContract).supply();
    }

	function verifyProof(bytes32 _root, bytes32[] memory _proof, bytes32 _valueToProve) public  startPrank stop returns (bool) {
        return BaseVault(proxiedContract).verifyProof(_root, _proof, _valueToProve);
    }
}
