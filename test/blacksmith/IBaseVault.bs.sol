// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/interfaces/IBaseVault.sol";
contract IBaseVaultBS {
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
    function batchDepositERC1155(address _from, address _to, address[] memory _tokens, uint256[] memory _ids, uint256[] memory _amounts, bytes[] memory _datas) public  startPrank stop  {
        IBaseVault(proxiedContract).batchDepositERC1155(_from, _to, _tokens, _ids, _amounts, _datas);
    }

	function batchDepositERC20(address _from, address _to, address[] memory _tokens, uint256[] memory _amounts) public  startPrank stop  {
        IBaseVault(proxiedContract).batchDepositERC20(_from, _to, _tokens, _amounts);
    }

	function batchDepositERC721(address _from, address _to, address[] memory _tokens, uint256[] memory _ids) public  startPrank stop  {
        IBaseVault(proxiedContract).batchDepositERC721(_from, _to, _tokens, _ids);
    }

	function deployVault(uint256 _fractionSupply, address[] memory _modules, address[] memory _plugins, bytes4[] memory _selectors, bytes32[] memory _mintProof) public  startPrank stop returns (address) {
        return IBaseVault(proxiedContract).deployVault(_fractionSupply, _modules, _plugins, _selectors, _mintProof);
    }

	function generateMerkleTree(address[] memory _modules) public  startPrank stop returns (bytes32[] memory) {
        return IBaseVault(proxiedContract).generateMerkleTree(_modules);
    }

	function registry() public  startPrank stop returns (address) {
        return IBaseVault(proxiedContract).registry();
    }
}
