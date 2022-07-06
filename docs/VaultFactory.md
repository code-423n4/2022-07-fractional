# Solidity API

## VaultFactory

Factory contract for deploying fractional vaults

### implementation

```solidity
address implementation
```

Address of Vault proxy contract

### nextSeeds

```solidity
mapping(address => bytes32) nextSeeds
```

_Internal mapping to track the next seed to be used by an EOA_

### constructor

```solidity
constructor() public
```

Initializes implementation contract

### deploy

```solidity
function deploy() external returns (address payable vault)
```

Deploys new vault for sender

| Name | Type | Description |
| ---- | ---- | ----------- |
| vault | address payable | Address of deployed vault |

### getNextAddress

```solidity
function getNextAddress(address _deployer) external view returns (address vault)
```

Gets pre-computed address of vault deployed by given account

| Name | Type | Description |
| ---- | ---- | ----------- |
| _deployer | address | Address of vault deployer |

| Name | Type | Description |
| ---- | ---- | ----------- |
| vault | address | Address of next vault |

### getNextSeed

```solidity
function getNextSeed(address _deployer) external view returns (bytes32)
```

Gets next seed value of given account

| Name | Type | Description |
| ---- | ---- | ----------- |
| _deployer | address | Address of vault deployer |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bytes32 | Value of next seed |

### deployFor

```solidity
function deployFor(address _owner) public returns (address payable vault)
```

Deploys new vault for given address

| Name | Type | Description |
| ---- | ---- | ----------- |
| _owner | address | Address of vault owner |

| Name | Type | Description |
| ---- | ---- | ----------- |
| vault | address payable | Address of deployed vault |

