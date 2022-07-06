// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/mocks/MockERC1155.sol";
contract MockERC1155BS {
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
        return MockERC1155(proxiedContract).balanceOf(arg0, arg1);
    }

	function balanceOfBatch(address[] memory owners, uint256[] memory ids) public  startPrank stop returns (uint256[] memory) {
        return MockERC1155(proxiedContract).balanceOfBatch(owners, ids);
    }

	function batchBurn(address from, uint256[] memory ids, uint256[] memory amounts) public  startPrank stop  {
        MockERC1155(proxiedContract).batchBurn(from, ids, amounts);
    }

	function batchMint(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public  startPrank stop  {
        MockERC1155(proxiedContract).batchMint(to, ids, amounts, data);
    }

	function burn(address from, uint256 id, uint256 amount) public  startPrank stop  {
        MockERC1155(proxiedContract).burn(from, id, amount);
    }

	function isApprovedForAll(address arg0, address arg1) public  startPrank stop returns (bool) {
        return MockERC1155(proxiedContract).isApprovedForAll(arg0, arg1);
    }

	function mint(address to, uint256 id, uint256 amount, bytes memory data) public  startPrank stop  {
        MockERC1155(proxiedContract).mint(to, id, amount, data);
    }

	function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public  startPrank stop  {
        MockERC1155(proxiedContract).safeBatchTransferFrom(from, to, ids, amounts, data);
    }

	function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) public  startPrank stop  {
        MockERC1155(proxiedContract).safeTransferFrom(from, to, id, amount, data);
    }

	function setApprovalForAll(address operator, bool approved) public  startPrank stop  {
        MockERC1155(proxiedContract).setApprovalForAll(operator, approved);
    }

	function supportsInterface(bytes4 interfaceId) public  startPrank stop returns (bool) {
        return MockERC1155(proxiedContract).supportsInterface(interfaceId);
    }

	function uri(uint256 arg0) public  startPrank stop returns (string memory) {
        return MockERC1155(proxiedContract).uri(arg0);
    }
}
