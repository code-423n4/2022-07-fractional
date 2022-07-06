# Solidity API

## IVault

_Interface for Vault proxy contract_

### ExecutionReverted

```solidity
error ExecutionReverted()
```

_Emitted when execution reverted with no reason_

### Initialized

```solidity
error Initialized(address _owner, address _newOwner, uint256 _nonce)
```

_Emitted when ownership of the proxy has been renounced_

### MethodNotFound

```solidity
error MethodNotFound()
```

_Emitted when there is no implementation stored in methods for a function signature_

### NotAuthorized

```solidity
error NotAuthorized(address _caller, address _target, bytes4 _selector)
```

_Emitted when the caller is not the owner_

### NotOwner

```solidity
error NotOwner(address _owner, address _caller)
```

_Emitted when the caller is not the owner_

### OwnerChanged

```solidity
error OwnerChanged(address _originalOwner, address _newOwner)
```

_Emitted when the owner is changed during the DELEGATECALL_

### TargetInvalid

```solidity
error TargetInvalid(address _target)
```

_Emitted when passing an EOA or an undeployed contract as the target_

### Execute

```solidity
event Execute(address _target, bytes _data, bytes _response)
```

_Event log for executing transactions_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _target | address | Address of target contract |
| _data | bytes | Transaction data being executed |
| _response | bytes | Return data of delegatecall |

### InstallPlugin

```solidity
event InstallPlugin(bytes4[] _selectors, address[] _plugins)
```

_Event log for installing plugins_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _selectors | bytes4[] | List of function selectors |
| _plugins | address[] | List of plugin contracts |

### TransferOwnership

```solidity
event TransferOwnership(address _oldOwner, address _newOwner)
```

_Event log for transferring ownership_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _oldOwner | address | Address of old owner |
| _newOwner | address | Address of new owner |

### UninstallPlugin

```solidity
event UninstallPlugin(bytes4[] _selectors)
```

_Event log for uninstalling plugins_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _selectors | bytes4[] | List of function selectors |

### execute

```solidity
function execute(address _target, bytes _data, bytes32[] _proof) external payable returns (bool success, bytes response)
```

### init

```solidity
function init() external
```

### install

```solidity
function install(bytes4[] _selectors, address[] _plugins) external
```

### merkleRoot

```solidity
function merkleRoot() external view returns (bytes32)
```

### methods

```solidity
function methods(bytes4) external view returns (address)
```

### nonce

```solidity
function nonce() external view returns (uint256)
```

### owner

```solidity
function owner() external view returns (address)
```

### setMerkleRoot

```solidity
function setMerkleRoot(bytes32 _rootHash) external
```

### transferOwnership

```solidity
function transferOwnership(address _newOwner) external
```

### uninstall

```solidity
function uninstall(bytes4[] _selectors) external
```

