// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/targets/Transfer.sol";
contract TransferBS {
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
    function ERC1155BatchTransferFrom(address arg0, address arg1, address arg2, uint256[] memory arg3, uint256[] memory arg4) public  startPrank stop  {
        Transfer(proxiedContract).ERC1155BatchTransferFrom(arg0, arg1, arg2, arg3, arg4);
    }

	function ERC1155TransferFrom(address _token, address _from, address _to, uint256 _tokenId, uint256 _amount) public  startPrank stop  {
        Transfer(proxiedContract).ERC1155TransferFrom(_token, _from, _to, _tokenId, _amount);
    }

	function ERC20Transfer(address _token, address _to, uint256 _amount) public  startPrank stop  {
        Transfer(proxiedContract).ERC20Transfer(_token, _to, _amount);
    }

	function ERC721TransferFrom(address _token, address _from, address _to, uint256 _tokenId) public  startPrank stop  {
        Transfer(proxiedContract).ERC721TransferFrom(_token, _from, _to, _tokenId);
    }
}
