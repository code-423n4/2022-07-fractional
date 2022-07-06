// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;
import "./Blacksmith.sol";
import "../../src/VaultRegistry.sol";
contract VaultRegistryBS {
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
    function burn(address _from, uint256 _value) public  startPrank stop  {
        VaultRegistry(proxiedContract).burn(_from, _value);
    }

	function create(bytes32 _merkleRoot, address[] memory _plugins, bytes4[] memory _selectors) public  startPrank stop returns (address) {
        return VaultRegistry(proxiedContract).create(_merkleRoot, _plugins, _selectors);
    }

	function createCollection(bytes32 _merkleRoot, address[] memory _plugins, bytes4[] memory _selectors) public  startPrank stop returns (address, address) {
        return VaultRegistry(proxiedContract).createCollection(_merkleRoot, _plugins, _selectors);
    }

	function createCollectionFor(bytes32 _merkleRoot, address _controller, address[] memory _plugins, bytes4[] memory _selectors) public  startPrank stop returns (address, address) {
        return VaultRegistry(proxiedContract).createCollectionFor(_merkleRoot, _controller, _plugins, _selectors);
    }

	function createFor(bytes32 _merkleRoot, address _owner, address[] memory _plugins, bytes4[] memory _selectors) public  startPrank stop returns (address) {
        return VaultRegistry(proxiedContract).createFor(_merkleRoot, _owner, _plugins, _selectors);
    }

	function createInCollection(bytes32 _merkleRoot, address _token, address[] memory _plugins, bytes4[] memory _selectors) public  startPrank stop returns (address) {
        return VaultRegistry(proxiedContract).createInCollection(_merkleRoot, _token, _plugins, _selectors);
    }

	function fNFT() public  startPrank stop returns (address) {
        return VaultRegistry(proxiedContract).fNFT();
    }

	function fNFTImplementation() public  startPrank stop returns (address) {
        return VaultRegistry(proxiedContract).fNFTImplementation();
    }

	function factory() public  startPrank stop returns (address) {
        return VaultRegistry(proxiedContract).factory();
    }

	function mint(address _to, uint256 _value) public  startPrank stop  {
        VaultRegistry(proxiedContract).mint(_to, _value);
    }

	function nextId(address arg0) public  startPrank stop returns (uint256) {
        return VaultRegistry(proxiedContract).nextId(arg0);
    }

	function totalSupply(address _vault) public  startPrank stop returns (uint256) {
        return VaultRegistry(proxiedContract).totalSupply(_vault);
    }

	function uri(address _vault) public  startPrank stop returns (string memory) {
        return VaultRegistry(proxiedContract).uri(_vault);
    }

	function vaultToToken(address arg0) public  startPrank stop returns (address, uint256) {
        return VaultRegistry(proxiedContract).vaultToToken(arg0);
    }
}
