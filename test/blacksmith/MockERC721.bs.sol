// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/mocks/MockERC721.sol";
contract MockERC721BS {
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
    function approve(address spender, uint256 id) public  startPrank stop  {
        MockERC721(proxiedContract).approve(spender, id);
    }

	function balanceOf(address owner) public  startPrank stop returns (uint256) {
        return MockERC721(proxiedContract).balanceOf(owner);
    }

	function burn(uint256 tokenId) public  startPrank stop  {
        MockERC721(proxiedContract).burn(tokenId);
    }

	function getApproved(uint256 arg0) public  startPrank stop returns (address) {
        return MockERC721(proxiedContract).getApproved(arg0);
    }

	function isApprovedForAll(address arg0, address arg1) public  startPrank stop returns (bool) {
        return MockERC721(proxiedContract).isApprovedForAll(arg0, arg1);
    }

	function mint(address to, uint256 tokenId) public  startPrank stop  {
        MockERC721(proxiedContract).mint(to, tokenId);
    }

	function name() public  startPrank stop returns (string memory) {
        return MockERC721(proxiedContract).name();
    }

	function ownerOf(uint256 id) public  startPrank stop returns (address) {
        return MockERC721(proxiedContract).ownerOf(id);
    }

	function safeMint(address to, uint256 tokenId, bytes memory data) public  startPrank stop  {
        MockERC721(proxiedContract).safeMint(to, tokenId, data);
    }

	function safeMint(address to, uint256 tokenId) public  startPrank stop  {
        MockERC721(proxiedContract).safeMint(to, tokenId);
    }

	function safeTransferFrom(address from, address to, uint256 id) public  startPrank stop  {
        MockERC721(proxiedContract).safeTransferFrom(from, to, id);
    }

	function safeTransferFrom(address from, address to, uint256 id, bytes memory data) public  startPrank stop  {
        MockERC721(proxiedContract).safeTransferFrom(from, to, id, data);
    }

	function setApprovalForAll(address operator, bool approved) public  startPrank stop  {
        MockERC721(proxiedContract).setApprovalForAll(operator, approved);
    }

	function supportsInterface(bytes4 interfaceId) public  startPrank stop returns (bool) {
        return MockERC721(proxiedContract).supportsInterface(interfaceId);
    }

	function symbol() public  startPrank stop returns (string memory) {
        return MockERC721(proxiedContract).symbol();
    }

	function tokenURI(uint256 arg0) public  startPrank stop returns (string memory) {
        return MockERC721(proxiedContract).tokenURI(arg0);
    }

	function transferFrom(address from, address to, uint256 id) public  startPrank stop  {
        MockERC721(proxiedContract).transferFrom(from, to, id);
    }
}
