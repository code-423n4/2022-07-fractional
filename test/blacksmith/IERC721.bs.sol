// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/IERC721.sol";
contract IERC721BS {
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
    function approve(address _spender, uint256 _id) public  startPrank stop  {
        IERC721(proxiedContract).approve(_spender, _id);
    }

	function balanceOf(address _owner) public  startPrank stop returns (uint256) {
        return IERC721(proxiedContract).balanceOf(_owner);
    }

	function getApproved(uint256 arg0) public  startPrank stop returns (address) {
        return IERC721(proxiedContract).getApproved(arg0);
    }

	function isApprovedForAll(address arg0, address arg1) public  startPrank stop returns (bool) {
        return IERC721(proxiedContract).isApprovedForAll(arg0, arg1);
    }

	function name() public  startPrank stop returns (string memory) {
        return IERC721(proxiedContract).name();
    }

	function ownerOf(uint256 _id) public  startPrank stop returns (address) {
        return IERC721(proxiedContract).ownerOf(_id);
    }

	function safeTransferFrom(address _from, address _to, uint256 _id) public  startPrank stop  {
        IERC721(proxiedContract).safeTransferFrom(_from, _to, _id);
    }

	function safeTransferFrom(address _from, address _to, uint256 _id, bytes memory _data) public  startPrank stop  {
        IERC721(proxiedContract).safeTransferFrom(_from, _to, _id, _data);
    }

	function setApprovalForAll(address _operator, bool _approved) public  startPrank stop  {
        IERC721(proxiedContract).setApprovalForAll(_operator, _approved);
    }

	function supportsInterface(bytes4 _interfaceId) public  startPrank stop returns (bool) {
        return IERC721(proxiedContract).supportsInterface(_interfaceId);
    }

	function symbol() public  startPrank stop returns (string memory) {
        return IERC721(proxiedContract).symbol();
    }

	function tokenURI(uint256 _id) public  startPrank stop returns (string memory) {
        return IERC721(proxiedContract).tokenURI(_id);
    }

	function transferFrom(address _from, address _to, uint256 _id) public  startPrank stop  {
        IERC721(proxiedContract).transferFrom(_from, _to, _id);
    }
}
