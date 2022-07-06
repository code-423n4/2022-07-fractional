// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/IERC1155.sol";
contract IERC1155BS {
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
    function balanceOf(address arg0, uint256 arg1) public  startPrank stop returns (uint256) {
        return IERC1155(proxiedContract).balanceOf(arg0, arg1);
    }

	function balanceOfBatch(address[] memory _owners, uint256[] memory ids) public  startPrank stop returns (uint256[] memory) {
        return IERC1155(proxiedContract).balanceOfBatch(_owners, ids);
    }

	function isApprovedForAll(address arg0, address arg1) public  startPrank stop returns (bool) {
        return IERC1155(proxiedContract).isApprovedForAll(arg0, arg1);
    }

	function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data) public  startPrank stop  {
        IERC1155(proxiedContract).safeBatchTransferFrom(_from, _to, _ids, _amounts, _data);
    }

	function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data) public  startPrank stop  {
        IERC1155(proxiedContract).safeTransferFrom(_from, _to, _id, _amount, _data);
    }

	function setApprovalForAll(address _operator, bool _approved) public  startPrank stop  {
        IERC1155(proxiedContract).setApprovalForAll(_operator, _approved);
    }

	function supportsInterface(bytes4 _interfaceId) public  startPrank stop returns (bool) {
        return IERC1155(proxiedContract).supportsInterface(_interfaceId);
    }

	function uri(uint256 _id) public  startPrank stop returns (string memory) {
        return IERC1155(proxiedContract).uri(_id);
    }
}
