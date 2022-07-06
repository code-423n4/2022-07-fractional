// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/IFERC1155.sol";
contract IFERC1155BS {
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
    function INITIAL_CONTROLLER() public  startPrank stop returns (address) {
        return IFERC1155(proxiedContract).INITIAL_CONTROLLER();
    }

	function NAME() public  startPrank stop returns (string memory) {
        return IFERC1155(proxiedContract).NAME();
    }

	function VAULT_REGISTRY() public  startPrank stop returns (address) {
        return IFERC1155(proxiedContract).VAULT_REGISTRY();
    }

	function VERSION() public  startPrank stop returns (string memory) {
        return IFERC1155(proxiedContract).VERSION();
    }

	function burn(address _from, uint256 _id, uint256 _amount) public  startPrank stop  {
        IFERC1155(proxiedContract).burn(_from, _id, _amount);
    }

	function contractURI() public  startPrank stop returns (string memory) {
        return IFERC1155(proxiedContract).contractURI();
    }

	function controller() public  startPrank stop returns (address) {
        return IFERC1155(proxiedContract).controller();
    }

	function emitSetURI(uint256 _id, string memory _uri) public  startPrank stop  {
        IFERC1155(proxiedContract).emitSetURI(_id, _uri);
    }

	function isApproved(address arg0, address arg1, uint256 arg2) public  startPrank stop returns (bool) {
        return IFERC1155(proxiedContract).isApproved(arg0, arg1, arg2);
    }

	function metadata(uint256 arg0) public  startPrank stop returns (address) {
        return IFERC1155(proxiedContract).metadata(arg0);
    }

	function mint(address _to, uint256 _id, uint256 _amount, bytes memory _data) public  startPrank stop  {
        IFERC1155(proxiedContract).mint(_to, _id, _amount, _data);
    }

	function nonces(address arg0) public  startPrank stop returns (uint256) {
        return IFERC1155(proxiedContract).nonces(arg0);
    }

	function permit(address _owner, address _operator, uint256 _id, bool _approved, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) public  startPrank stop  {
        IFERC1155(proxiedContract).permit(_owner, _operator, _id, _approved, _deadline, _v, _r, _s);
    }

	function permitAll(address _owner, address _operator, bool _approved, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) public  startPrank stop  {
        IFERC1155(proxiedContract).permitAll(_owner, _operator, _approved, _deadline, _v, _r, _s);
    }

	function royaltyInfo(uint256 _id, uint256 _salePrice) public  startPrank stop returns (address, uint256) {
        return IFERC1155(proxiedContract).royaltyInfo(_id, _salePrice);
    }

	function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data) public  startPrank stop  {
        IFERC1155(proxiedContract).safeTransferFrom(_from, _to, _id, _amount, _data);
    }

	function setApprovalFor(address _operator, uint256 _id, bool _approved) public  startPrank stop  {
        IFERC1155(proxiedContract).setApprovalFor(_operator, _id, _approved);
    }

	function setContractURI(string memory _uri) public  startPrank stop  {
        IFERC1155(proxiedContract).setContractURI(_uri);
    }

	function setMetadata(address _metadata, uint256 _id) public  startPrank stop  {
        IFERC1155(proxiedContract).setMetadata(_metadata, _id);
    }

	function setRoyalties(uint256 _id, address _receiver, uint256 _percentage) public  startPrank stop  {
        IFERC1155(proxiedContract).setRoyalties(_id, _receiver, _percentage);
    }

	function totalSupply(uint256 arg0) public  startPrank stop returns (uint256) {
        return IFERC1155(proxiedContract).totalSupply(arg0);
    }

	function transferController(address _newController) public  startPrank stop  {
        IFERC1155(proxiedContract).transferController(_newController);
    }

	function uri(uint256 _id) public  startPrank stop returns (string memory) {
        return IFERC1155(proxiedContract).uri(_id);
    }
}
