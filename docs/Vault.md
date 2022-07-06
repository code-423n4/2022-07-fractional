# Solidity API

## Vault

Proxy contract for storing fractionalized assets

### owner

```solidity
address owner
```

Address of vault owner

### merkleRoot

```solidity
bytes32 merkleRoot
```

Merkle root hash of vault permissions

### nonce

```solidity
uint256 nonce
```

Initializer value

### MIN_GAS_RESERVE

```solidity
uint256 MIN_GAS_RESERVE
```

_Minimum reserve of gas units_

### methods

```solidity
mapping(bytes4 => address) methods
```

Mapping of function selector to plugin address

### init

```solidity
function init() external
```

_Initializes nonce and proxy owner_

### receive

```solidity
receive() external payable
```

_Callback for receiving Ether when the calldata is empty_

### fallback

```solidity
fallback(bytes _data) external payable returns (bytes response)
```

_Callback for handling plugin transactions_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _data | bytes | Transaction data |

| Name | Type | Description |
| ---- | ---- | ----------- |
| response | bytes | Return data from executing plugin |

### execute

```solidity
function execute(address _target, bytes _data, bytes32[] _proof) external payable returns (bool success, bytes response)
```

Executes vault transactions through delegatecall

| Name | Type | Description |
| ---- | ---- | ----------- |
| _target | address | Target address |
| _data | bytes | Transaction data |
| _proof | bytes32[] | Merkle proof of permission hash |

| Name | Type | Description |
| ---- | ---- | ----------- |
| success | bool | Result status of delegatecall |
| response | bytes | Return data of delegatecall |

### install

```solidity
function install(bytes4[] _selectors, address[] _plugins) external
```

Installs plugin by setting function selector to contract address

| Name | Type | Description |
| ---- | ---- | ----------- |
| _selectors | bytes4[] | List of function selectors |
| _plugins | address[] | Addresses of plugin contracts |

### setMerkleRoot

```solidity
function setMerkleRoot(bytes32 _rootHash) external
```

Sets merkle root of vault permissions

| Name | Type | Description |
| ---- | ---- | ----------- |
| _rootHash | bytes32 | Hash of merkle root |

### transferOwnership

```solidity
function transferOwnership(address _newOwner) external
```

Transfers ownership to given account

| Name | Type | Description |
| ---- | ---- | ----------- |
| _newOwner | address | Address of new owner |

### uninstall

```solidity
function uninstall(bytes4[] _selectors) external
```

Uninstalls plugin by setting function selector to zero address

| Name | Type | Description |
| ---- | ---- | ----------- |
| _selectors | bytes4[] | List of function selectors |

### _execute

```solidity
function _execute(address _target, bytes _data) internal returns (bool success, bytes response)
```

Executes plugin transactions through delegatecall

| Name | Type | Description |
| ---- | ---- | ----------- |
| _target | address | Target address |
| _data | bytes | Transaction data |

| Name | Type | Description |
| ---- | ---- | ----------- |
| success | bool | Result status of delegatecall |
| response | bytes | Return data of delegatecall |

### _revertedWithReason

```solidity
function _revertedWithReason(bytes _response) internal pure
```

Reverts transaction with reason

