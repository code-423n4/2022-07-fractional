// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/mocks/MockPermitter.sol";
contract MockPermitterBS {
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
    function selfPermit(address _token, uint256 _id, bool _approved, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) public  startPrank stop  {
        MockPermitter(proxiedContract).selfPermit(_token, _id, _approved, _deadline, _v, _r, _s);
    }

	function selfPermitAll(address _token, bool _approved, uint256 _deadline, uint8 _v, bytes32 _r, bytes32 _s) public  startPrank stop  {
        MockPermitter(proxiedContract).selfPermitAll(_token, _approved, _deadline, _v, _r, _s);
    }
}
