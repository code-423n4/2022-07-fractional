// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/IBuyout.sol";
contract IBuyoutBS {
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
        return IBuyout(proxiedContract).PROPOSAL_PERIOD();
    }

	function REJECTION_PERIOD() public  startPrank stop returns (uint256) {
        return IBuyout(proxiedContract).REJECTION_PERIOD();
    }

	function batchWithdrawERC1155(address _vault, address _token, address _to, uint256[] memory _ids, uint256[] memory _values, bytes32[] memory _erc1155BatchTransferProof) public  startPrank stop  {
        IBuyout(proxiedContract).batchWithdrawERC1155(_vault, _token, _to, _ids, _values, _erc1155BatchTransferProof);
    }

	function buyFractions(address _vault, uint256 _amount) public payable  startPrank stop  {
        IBuyout(proxiedContract).buyFractions{value: msg.value}(_vault, _amount);
    }

	function buyoutInfo(address arg0) public  startPrank stop returns (uint256, address, State, uint256, uint256, uint256) {
        return IBuyout(proxiedContract).buyoutInfo(arg0);
    }

	function cash(address _vault, bytes32[] memory _burnProof) public  startPrank stop  {
        IBuyout(proxiedContract).cash(_vault, _burnProof);
    }

	function end(address _vault, bytes32[] memory _burnProof) public  startPrank stop  {
        IBuyout(proxiedContract).end(_vault, _burnProof);
    }

	function getLeafNodes() public  startPrank stop returns (bytes32[] memory) {
        return IBuyout(proxiedContract).getLeafNodes();
    }

	function getPermissions() public  startPrank stop returns (Permission[] memory) {
        return IBuyout(proxiedContract).getPermissions();
    }

	function redeem(address _vault, bytes32[] memory _burnProof) public  startPrank stop  {
        IBuyout(proxiedContract).redeem(_vault, _burnProof);
    }

	function registry() public  startPrank stop returns (address) {
        return IBuyout(proxiedContract).registry();
    }

	function sellFractions(address _vault, uint256 _amount) public  startPrank stop  {
        IBuyout(proxiedContract).sellFractions(_vault, _amount);
    }

	function start(address _vault) public payable  startPrank stop  {
        IBuyout(proxiedContract).start{value: msg.value}(_vault);
    }

	function supply() public  startPrank stop returns (address) {
        return IBuyout(proxiedContract).supply();
    }

	function transfer() public  startPrank stop returns (address) {
        return IBuyout(proxiedContract).transfer();
    }

	function withdrawERC1155(address _vault, address _token, address _to, uint256 _id, uint256 _value, bytes32[] memory _erc1155TransferProof) public  startPrank stop  {
        IBuyout(proxiedContract).withdrawERC1155(_vault, _token, _to, _id, _value, _erc1155TransferProof);
    }

	function withdrawERC20(address _vault, address _token, address _to, uint256 _value, bytes32[] memory _erc20TransferProof) public  startPrank stop  {
        IBuyout(proxiedContract).withdrawERC20(_vault, _token, _to, _value, _erc20TransferProof);
    }

	function withdrawERC721(address _vault, address _token, address _to, uint256 _tokenId, bytes32[] memory _erc721TransferProof) public  startPrank stop  {
        IBuyout(proxiedContract).withdrawERC721(_vault, _token, _to, _tokenId, _erc721TransferProof);
    }
}
