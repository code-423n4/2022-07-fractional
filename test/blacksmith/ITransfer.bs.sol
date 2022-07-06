// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/ITransfer.sol";
contract ITransferBS {
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
    function ERC1155BatchTransferFrom(address _token, address _from, address _to, uint256[] memory _ids, uint256[] memory _values) public  startPrank stop  {
        ITransfer(proxiedContract).ERC1155BatchTransferFrom(_token, _from, _to, _ids, _values);
    }

	function ERC1155TransferFrom(address _token, address _from, address _to, uint256 _id, uint256 _value) public  startPrank stop  {
        ITransfer(proxiedContract).ERC1155TransferFrom(_token, _from, _to, _id, _value);
    }

	function ERC20Transfer(address _token, address _to, uint256 _value) public  startPrank stop  {
        ITransfer(proxiedContract).ERC20Transfer(_token, _to, _value);
    }

	function ERC721TransferFrom(address _token, address _from, address _to, uint256 _tokenId) public  startPrank stop  {
        ITransfer(proxiedContract).ERC721TransferFrom(_token, _from, _to, _tokenId);
    }
}
