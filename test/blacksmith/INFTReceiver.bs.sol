// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/INFTReceiver.sol";
contract INFTReceiverBS {
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
    function onERC1155BatchReceived(address arg0, address arg1, uint256[] memory arg2, uint256[] memory arg3, bytes memory arg4) public  startPrank stop returns (bytes4) {
        return INFTReceiver(proxiedContract).onERC1155BatchReceived(arg0, arg1, arg2, arg3, arg4);
    }

	function onERC1155Received(address arg0, address arg1, uint256 arg2, uint256 arg3, bytes memory arg4) public  startPrank stop returns (bytes4) {
        return INFTReceiver(proxiedContract).onERC1155Received(arg0, arg1, arg2, arg3, arg4);
    }

	function onERC721Received(address arg0, address arg1, uint256 arg2, bytes memory arg3) public  startPrank stop returns (bytes4) {
        return INFTReceiver(proxiedContract).onERC721Received(arg0, arg1, arg2, arg3);
    }
}
