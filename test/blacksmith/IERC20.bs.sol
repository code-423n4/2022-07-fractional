// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/IERC20.sol";
contract IERC20BS {
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
        return IERC20(proxiedContract).DOMAIN_SEPARATOR();
    }

	function allowance(address arg0, address arg1) public  startPrank stop returns (uint256) {
        return IERC20(proxiedContract).allowance(arg0, arg1);
    }

	function approve(address _spender, uint256 _amount) public  startPrank stop returns (bool) {
        return IERC20(proxiedContract).approve(_spender, _amount);
    }

	function balanceOf(address arg0) public  startPrank stop returns (uint256) {
        return IERC20(proxiedContract).balanceOf(arg0);
    }

	function decimals() public  startPrank stop returns (uint8) {
        return IERC20(proxiedContract).decimals();
    }

	function name() public  startPrank stop returns (string memory) {
        return IERC20(proxiedContract).name();
    }

	function nonces(address arg0) public  startPrank stop returns (uint256) {
        return IERC20(proxiedContract).nonces(arg0);
    }

	function permit(address _owner, address _spender, uint256 _value, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) public  startPrank stop  {
        IERC20(proxiedContract).permit(_owner, _spender, _value, _deadline, _v, _r, _s);
    }

	function symbol() public  startPrank stop returns (string memory) {
        return IERC20(proxiedContract).symbol();
    }

	function totalSupply() public  startPrank stop returns (uint256) {
        return IERC20(proxiedContract).totalSupply();
    }

	function transfer(address _to, uint256 _amount) public  startPrank stop returns (bool) {
        return IERC20(proxiedContract).transfer(_to, _amount);
    }

	function transferFrom(address _from, address _to, uint256 _amount) public  startPrank stop returns (bool) {
        return IERC20(proxiedContract).transferFrom(_from, _to, _amount);
    }
}
