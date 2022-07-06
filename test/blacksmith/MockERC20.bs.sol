// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/mocks/MockERC20.sol";
contract MockERC20BS {
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
    function DOMAIN_SEPARATOR() public  startPrank stop returns (bytes32) {
        return MockERC20(proxiedContract).DOMAIN_SEPARATOR();
    }

	function allowance(address arg0, address arg1) public  startPrank stop returns (uint256) {
        return MockERC20(proxiedContract).allowance(arg0, arg1);
    }

	function approve(address spender, uint256 amount) public  startPrank stop returns (bool) {
        return MockERC20(proxiedContract).approve(spender, amount);
    }

	function balanceOf(address arg0) public  startPrank stop returns (uint256) {
        return MockERC20(proxiedContract).balanceOf(arg0);
    }

	function burn(address from, uint256 amount) public  startPrank stop  {
        MockERC20(proxiedContract).burn(from, amount);
    }

	function decimals() public  startPrank stop returns (uint8) {
        return MockERC20(proxiedContract).decimals();
    }

	function mint(address to, uint256 amount) public  startPrank stop  {
        MockERC20(proxiedContract).mint(to, amount);
    }

	function name() public  startPrank stop returns (string memory) {
        return MockERC20(proxiedContract).name();
    }

	function nonces(address arg0) public  startPrank stop returns (uint256) {
        return MockERC20(proxiedContract).nonces(arg0);
    }

	function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) public  startPrank stop  {
        MockERC20(proxiedContract).permit(owner, spender, value, deadline, v, r, s);
    }

	function symbol() public  startPrank stop returns (string memory) {
        return MockERC20(proxiedContract).symbol();
    }

	function totalSupply() public  startPrank stop returns (uint256) {
        return MockERC20(proxiedContract).totalSupply();
    }

	function transfer(address to, uint256 amount) public  startPrank stop returns (bool) {
        return MockERC20(proxiedContract).transfer(to, amount);
    }

	function transferFrom(address from, address to, uint256 amount) public  startPrank stop returns (bool) {
        return MockERC20(proxiedContract).transferFrom(from, to, amount);
    }
}
