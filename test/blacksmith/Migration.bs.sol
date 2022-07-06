// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/modules/Migration.sol";
contract MigrationBS {
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
    function PROPOSAL_PERIOD() public  startPrank stop returns (uint256) {
        return Migration(proxiedContract).PROPOSAL_PERIOD();
    }

	function batchMigrateVaultERC1155(address _vault, uint256 _proposalId, address _token, uint256[] memory _ids, uint256[] memory _amounts, bytes32[] memory _erc1155BatchTransferProof) public  startPrank stop  {
        Migration(proxiedContract).batchMigrateVaultERC1155(_vault, _proposalId, _token, _ids, _amounts, _erc1155BatchTransferProof);
    }

	function buyout() public  startPrank stop returns (address payable) {
        return Migration(proxiedContract).buyout();
    }

	function commit(address _vault, uint256 _proposalId) public  startPrank stop returns (bool) {
        return Migration(proxiedContract).commit(_vault, _proposalId);
    }

	function generateMerkleTree(address[] memory _modules) public  startPrank stop returns (bytes32[] memory) {
        return Migration(proxiedContract).generateMerkleTree(_modules);
    }

	function getLeafNodes() public  startPrank stop returns (bytes32[] memory) {
        return Migration(proxiedContract).getLeafNodes();
    }

	function getPermissions() public  startPrank stop returns (Permission[] memory) {
        return Migration(proxiedContract).getPermissions();
    }

	function getProof(bytes32[] memory _data, uint256 _node) public  startPrank stop returns (bytes32[] memory) {
        return Migration(proxiedContract).getProof(_data, _node);
    }

	function getRoot(bytes32[] memory _data) public  startPrank stop returns (bytes32) {
        return Migration(proxiedContract).getRoot(_data);
    }

	function hashLeafPairs(bytes32 _left, bytes32 _right) public  startPrank stop returns (bytes32) {
        return Migration(proxiedContract).hashLeafPairs(_left, _right);
    }

	function join(address _vault, uint256 _proposalId, uint256 _amount) public payable  startPrank stop  {
        Migration(proxiedContract).join{value: msg.value}(_vault, _proposalId, _amount);
    }

	function leave(address _vault, uint256 _proposalId) public  startPrank stop  {
        Migration(proxiedContract).leave(_vault, _proposalId);
    }

	function log2ceil_naive(uint256 x) public  startPrank stop returns (uint256) {
        return Migration(proxiedContract).log2ceil_naive(x);
    }

	function migrateFractions(address _vault, uint256 _proposalId) public  startPrank stop  {
        Migration(proxiedContract).migrateFractions(_vault, _proposalId);
    }

	function migrateVaultERC1155(address _vault, uint256 _proposalId, address _token, uint256 _id, uint256 _amount, bytes32[] memory _erc1155TransferProof) public  startPrank stop  {
        Migration(proxiedContract).migrateVaultERC1155(_vault, _proposalId, _token, _id, _amount, _erc1155TransferProof);
    }

	function migrateVaultERC20(address _vault, uint256 _proposalId, address _token, uint256 _amount, bytes32[] memory _erc20TransferProof) public  startPrank stop  {
        Migration(proxiedContract).migrateVaultERC20(_vault, _proposalId, _token, _amount, _erc20TransferProof);
    }

	function migrateVaultERC721(address _vault, uint256 _proposalId, address _token, uint256 _tokenId, bytes32[] memory _erc721TransferProof) public  startPrank stop  {
        Migration(proxiedContract).migrateVaultERC721(_vault, _proposalId, _token, _tokenId, _erc721TransferProof);
    }

	function migrationInfo(address arg0, uint256 arg1) public  startPrank stop returns (uint256, uint256, uint256, uint256, address, bool, uint256, uint256, bool) {
        return Migration(proxiedContract).migrationInfo(arg0, arg1);
    }

	function multicall(bytes[] memory _data) public  startPrank stop returns (bytes[] memory) {
        return Migration(proxiedContract).multicall(_data);
    }

	function nextId() public  startPrank stop returns (uint256) {
        return Migration(proxiedContract).nextId();
    }

	function onERC1155BatchReceived(address arg0, address arg1, uint256[] memory arg2, uint256[] memory arg3, bytes memory arg4) public  startPrank stop returns (bytes4) {
        return Migration(proxiedContract).onERC1155BatchReceived(arg0, arg1, arg2, arg3, arg4);
    }

	function onERC1155Received(address arg0, address arg1, uint256 arg2, uint256 arg3, bytes memory arg4) public  startPrank stop returns (bytes4) {
        return Migration(proxiedContract).onERC1155Received(arg0, arg1, arg2, arg3, arg4);
    }

	function onERC721Received(address arg0, address arg1, uint256 arg2, bytes memory arg3) public  startPrank stop returns (bytes4) {
        return Migration(proxiedContract).onERC721Received(arg0, arg1, arg2, arg3);
    }

	function propose(address _vault, address[] memory _modules, address[] memory _plugins, bytes4[] memory _selectors, uint256 _newFractionSupply, uint256 _targetPrice) public  startPrank stop  {
        Migration(proxiedContract).propose(_vault, _modules, _plugins, _selectors, _newFractionSupply, _targetPrice);
    }

	function registry() public  startPrank stop returns (address) {
        return Migration(proxiedContract).registry();
    }

	function settleFractions(address _vault, uint256 _proposalId, bytes32[] memory _mintProof) public  startPrank stop  {
        Migration(proxiedContract).settleFractions(_vault, _proposalId, _mintProof);
    }

	function settleVault(address _vault, uint256 _proposalId) public  startPrank stop  {
        Migration(proxiedContract).settleVault(_vault, _proposalId);
    }

	function supply() public  startPrank stop returns (address) {
        return Migration(proxiedContract).supply();
    }

	function verifyProof(bytes32 _root, bytes32[] memory _proof, bytes32 _valueToProve) public  startPrank stop returns (bool) {
        return Migration(proxiedContract).verifyProof(_root, _proof, _valueToProve);
    }

	function withdrawContribution(address _vault, uint256 _proposalId) public  startPrank stop  {
        Migration(proxiedContract).withdrawContribution(_vault, _proposalId);
    }
}
