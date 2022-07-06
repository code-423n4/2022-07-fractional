// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/IMigration.sol";
contract IMigrationBS {
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
        return IMigration(proxiedContract).PROPOSAL_PERIOD();
    }

	function batchMigrateVaultERC1155(address _vault, uint256 _proposalId, address _nft, uint256[] memory _ids, uint256[] memory _amounts, bytes32[] memory _erc1155BatchTransferProof) public  startPrank stop  {
        IMigration(proxiedContract).batchMigrateVaultERC1155(_vault, _proposalId, _nft, _ids, _amounts, _erc1155BatchTransferProof);
    }

	function buyout() public  startPrank stop returns (address payable) {
        return IMigration(proxiedContract).buyout();
    }

	function commit(address _vault, uint256 _proposalId) public  startPrank stop returns (bool) {
        return IMigration(proxiedContract).commit(_vault, _proposalId);
    }

	function generateMerkleTree(address[] memory _modules) public  startPrank stop returns (bytes32[] memory) {
        return IMigration(proxiedContract).generateMerkleTree(_modules);
    }

	function join(address _vault, uint256 _proposalId, uint256 _amount) public payable  startPrank stop  {
        IMigration(proxiedContract).join{value: msg.value}(_vault, _proposalId, _amount);
    }

	function leave(address _vault, uint256 _proposalId) public  startPrank stop  {
        IMigration(proxiedContract).leave(_vault, _proposalId);
    }

	function migrateFractions(address _vault, uint256 _proposalId) public  startPrank stop  {
        IMigration(proxiedContract).migrateFractions(_vault, _proposalId);
    }

	function migrateVaultERC20(address _vault, uint256 _proposalId, address _token, uint256 _amount, bytes32[] memory _erc20TransferProof) public  startPrank stop  {
        IMigration(proxiedContract).migrateVaultERC20(_vault, _proposalId, _token, _amount, _erc20TransferProof);
    }

	function migrateVaultERC721(address _vault, uint256 _proposalId, address _nft, uint256 _tokenId, bytes32[] memory _erc721TransferProof) public  startPrank stop  {
        IMigration(proxiedContract).migrateVaultERC721(_vault, _proposalId, _nft, _tokenId, _erc721TransferProof);
    }

	function migrationInfo(address arg0, uint256 arg1) public  startPrank stop returns (uint256, uint256, uint256, uint256, address, bool, uint256, uint256, bool) {
        return IMigration(proxiedContract).migrationInfo(arg0, arg1);
    }

	function nextId() public  startPrank stop returns (uint256) {
        return IMigration(proxiedContract).nextId();
    }

	function propose(address _vault, address[] memory _modules, address[] memory _plugins, bytes4[] memory _selectors, uint256 _newFractionSupply, uint256 _targetPrice) public  startPrank stop  {
        IMigration(proxiedContract).propose(_vault, _modules, _plugins, _selectors, _newFractionSupply, _targetPrice);
    }

	function registry() public  startPrank stop returns (address) {
        return IMigration(proxiedContract).registry();
    }

	function settleFractions(address _vault, uint256 _proposalId, bytes32[] memory _mintProof) public  startPrank stop  {
        IMigration(proxiedContract).settleFractions(_vault, _proposalId, _mintProof);
    }

	function settleVault(address _vault, uint256 _proposalId) public  startPrank stop  {
        IMigration(proxiedContract).settleVault(_vault, _proposalId);
    }

	function withdrawContribution(address _vault, uint256 _proposalId) public  startPrank stop  {
        IMigration(proxiedContract).withdrawContribution(_vault, _proposalId);
    }
}
