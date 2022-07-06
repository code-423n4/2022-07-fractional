// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {IVault} from "./interfaces/IVault.sol";
import {MerkleProof} from "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";
import {NFTReceiver} from "./utils/NFTReceiver.sol";

/// @title Vault
/// @author Fractional Art
/// @notice Proxy contract for storing fractionalized assets
contract Vault is IVault, NFTReceiver {
    /// @notice Address of vault owner
    address public owner;
    /// @notice Merkle root hash of vault permissions
    bytes32 public merkleRoot;
    /// @notice Initializer value
    uint256 public nonce;
    /// @dev Minimum reserve of gas units
    uint256 private constant MIN_GAS_RESERVE = 5_000;
    /// @notice Mapping of function selector to plugin address
    mapping(bytes4 => address) public methods;

    /// @dev Initializes nonce and proxy owner
    function init() external {
        if (nonce != 0) revert Initialized(owner, msg.sender, nonce);
        nonce = 1;
        owner = msg.sender;
        emit TransferOwnership(address(0), msg.sender);
    }

    /// @dev Callback for receiving Ether when the calldata is empty
    receive() external payable {}

    /// @dev Callback for handling plugin transactions
    /// @param _data Transaction data
    /// @return response Return data from executing plugin
    // prettier-ignore
    fallback(bytes calldata _data) external payable returns (bytes memory response) {
        address plugin = methods[msg.sig];
        (,response) = _execute(plugin, _data);
    }

    /// @notice Executes vault transactions through delegatecall
    /// @param _target Target address
    /// @param _data Transaction data
    /// @param _proof Merkle proof of permission hash
    /// @return success Result status of delegatecall
    /// @return response Return data of delegatecall
    function execute(
        address _target,
        bytes calldata _data,
        bytes32[] calldata _proof
    ) external payable returns (bool success, bytes memory response) {
        bytes4 selector;
        assembly {
            selector := calldataload(_data.offset)
        }

        // Generate leaf node by hashing module, target and function selector.
        bytes32 leaf = keccak256(abi.encode(msg.sender, _target, selector));
        // Check that the caller is either a module with permission to call or the owner.
        if (!MerkleProof.verify(_proof, merkleRoot, leaf)) {
            if (msg.sender != owner)
                revert NotAuthorized(msg.sender, _target, selector);
        }

        (success, response) = _execute(_target, _data);
    }

    /// @notice Installs plugin by setting function selector to contract address
    /// @param _selectors List of function selectors
    /// @param _plugins Addresses of plugin contracts
    function install(bytes4[] memory _selectors, address[] memory _plugins)
        external
    {
        if (owner != msg.sender) revert NotOwner(owner, msg.sender);
        uint256 length = _selectors.length;
        for (uint256 i = 0; i < length; i++) {
            methods[_selectors[i]] = _plugins[i];
        }
        emit InstallPlugin(_selectors, _plugins);
    }

    /// @notice Sets merkle root of vault permissions
    /// @param _rootHash Hash of merkle root
    function setMerkleRoot(bytes32 _rootHash) external {
        if (owner != msg.sender) revert NotOwner(owner, msg.sender);
        merkleRoot = _rootHash;
    }

    /// @notice Transfers ownership to given account
    /// @param _newOwner Address of new owner
    function transferOwnership(address _newOwner) external {
        if (owner != msg.sender) revert NotOwner(owner, msg.sender);
        owner = _newOwner;
        emit TransferOwnership(msg.sender, _newOwner);
    }

    /// @notice Uninstalls plugin by setting function selector to zero address
    /// @param _selectors List of function selectors
    function uninstall(bytes4[] memory _selectors) external {
        if (owner != msg.sender) revert NotOwner(owner, msg.sender);
        uint256 length = _selectors.length;
        for (uint256 i = 0; i < length; i++) {
            methods[_selectors[i]] = address(0);
        }
        emit UninstallPlugin(_selectors);
    }

    /// @notice Executes plugin transactions through delegatecall
    /// @param _target Target address
    /// @param _data Transaction data
    /// @return success Result status of delegatecall
    /// @return response Return data of delegatecall
    function _execute(address _target, bytes calldata _data)
        internal
        returns (bool success, bytes memory response)
    {
        // Check that the target is a valid contract
        uint256 codeSize;
        assembly {
            codeSize := extcodesize(_target)
        }
        if (codeSize == 0) revert TargetInvalid(_target);
        // Save the owner address in memory to ensure that it cannot be modified during the DELEGATECALL
        address owner_ = owner;
        // Reserve some gas to ensure that the function has enough to finish the execution
        uint256 stipend = gasleft() - MIN_GAS_RESERVE;

        // Delegate call to the target contract
        (success, response) = _target.delegatecall{gas: stipend}(_data);
        if (owner_ != owner) revert OwnerChanged(owner_, owner);

        // Revert if execution was unsuccessful
        if (!success) {
            if (response.length == 0) revert ExecutionReverted();
            _revertedWithReason(response);
        }
    }

    /// @notice Reverts transaction with reason
    function _revertedWithReason(bytes memory _response) internal pure {
        assembly {
            let returndata_size := mload(_response)
            revert(add(32, _response), returndata_size)
        }
    }
}
