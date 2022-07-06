# Solidity API

## Migration

Module contract for vaults to migrate to a new set of permissions
- A fractional holder creates a proposal with a target price and list of modules
- For 7 days, users can contribute their fractions / ether to signal support
- If the target price is reached then a buyout can be triggered and trading
  against the proposed buyout price can take place to resolve the outcome
- If a proposal holds more than 51% of the total supply, the buyout succeeds, a new vault can
  be created and the underlying assets (ERC-20, ERC-721 and ERC-1155 tokens) can be migrated

### buyout

```solidity
address payable buyout
```

Address of Buyout module contract

### registry

```solidity
address registry
```

Address of VaultRegistry contract

### nextId

```solidity
uint256 nextId
```

Counter used to assign IDs to new proposals

### PROPOSAL_PERIOD

```solidity
uint256 PROPOSAL_PERIOD
```

The length for the migration proposal period

### migrationInfo

```solidity
mapping(address => mapping(uint256 => struct Proposal)) migrationInfo
```

Mapping of a vault to it's proposal migration information

### userProposalEth

```solidity
mapping(uint256 => mapping(address => uint256)) userProposalEth
```

Mapping of a proposal ID to a user's ether contribution

### userProposalFractions

```solidity
mapping(uint256 => mapping(address => uint256)) userProposalFractions
```

Mapping of a proposal ID to a user's fractions contribution

### constructor

```solidity
constructor(address _buyout, address _registry, address _supply) public
```

Initializes buyout, registry, and supply contracts

### receive

```solidity
receive() external payable
```

_Callback for receiving ether when the calldata is empty_

### propose

```solidity
function propose(address _vault, address[] _modules, address[] _plugins, bytes4[] _selectors, uint256 _newFractionSupply, uint256 _targetPrice) external
```

Proposes a set of modules and plugins to migrate a vault to

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _modules | address[] | Addresses of module contracts |
| _plugins | address[] | Addresses of plugin contracts |
| _selectors | bytes4[] | List of plugin function selectors |
| _newFractionSupply | uint256 | New supply of fractional tokens |
| _targetPrice | uint256 | Target price of the buyout |

### join

```solidity
function join(address _vault, uint256 _proposalId, uint256 _amount) external payable
```

Joins a migration proposal by contributing ether and fractional tokens

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | The address of the vault |
| _proposalId | uint256 | ID of the proposal being contributed to |
| _amount | uint256 | Number of fractions being contributed |

### leave

```solidity
function leave(address _vault, uint256 _proposalId) external
```

Leaves a proposed migration with contribution amount

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _proposalId | uint256 | ID of the proposal being left |

### commit

```solidity
function commit(address _vault, uint256 _proposalId) external returns (bool started)
```

Kicks off the buyout process for a migration

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _proposalId | uint256 | ID of the proposal being committed to |

| Name | Type | Description |
| ---- | ---- | ----------- |
| started | bool | Bool status of starting the buyout process |

### settleVault

```solidity
function settleVault(address _vault, uint256 _proposalId) external
```

Settles a migration by ending the buyout

_Succeeds if buyout goes through, fails otherwise_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _proposalId | uint256 | ID of the proposal being settled |

### settleFractions

```solidity
function settleFractions(address _vault, uint256 _proposalId, bytes32[] _mintProof) external
```

Mints the fractional tokens for a new vault

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _proposalId | uint256 | ID of the proposal |
| _mintProof | bytes32[] | Merkle proof for minting fractional tokens |

### withdrawContribution

```solidity
function withdrawContribution(address _vault, uint256 _proposalId) external
```

Retrieves ether and fractions deposited from an unsuccessful migration

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _proposalId | uint256 | ID of the failed proposal |

### migrateVaultERC20

```solidity
function migrateVaultERC20(address _vault, uint256 _proposalId, address _token, uint256 _amount, bytes32[] _erc20TransferProof) external
```

Migrates an ERC-20 token to the new vault after a successful migration

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _proposalId | uint256 | ID of the proposal |
| _token | address | Address of the ERC-20 token |
| _amount | uint256 | Transfer amount |
| _erc20TransferProof | bytes32[] | Merkle proof for transferring an ERC-20 token |

### migrateVaultERC721

```solidity
function migrateVaultERC721(address _vault, uint256 _proposalId, address _token, uint256 _tokenId, bytes32[] _erc721TransferProof) external
```

Migrates an ERC-721 token to the new vault after a successful migration

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _proposalId | uint256 | ID of the proposal |
| _token | address | Address of the ERC-721 token |
| _tokenId | uint256 | ID of the token |
| _erc721TransferProof | bytes32[] | Merkle proof for transferring an ERC-721 token |

### migrateVaultERC1155

```solidity
function migrateVaultERC1155(address _vault, uint256 _proposalId, address _token, uint256 _id, uint256 _amount, bytes32[] _erc1155TransferProof) external
```

Migrates an ERC-1155 token to the new vault after a successful migration

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _proposalId | uint256 | ID of the proposal |
| _token | address | Address of the ERC-1155 token |
| _id | uint256 | ID of the token |
| _amount | uint256 | amount to be transferred |
| _erc1155TransferProof | bytes32[] | Merkle proof for transferring an ERC-1155 token |

### batchMigrateVaultERC1155

```solidity
function batchMigrateVaultERC1155(address _vault, uint256 _proposalId, address _token, uint256[] _ids, uint256[] _amounts, bytes32[] _erc1155BatchTransferProof) external
```

Batch migrates multiple ERC-1155 tokens to the new vault after a successful migration

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _proposalId | uint256 | ID of the proposal |
| _token | address | Address of the ERC-1155 token |
| _ids | uint256[] | IDs of each token type |
| _amounts | uint256[] | Transfer amounts per token type |
| _erc1155BatchTransferProof | bytes32[] | Merkle proof for batch transferring multiple ERC-1155 tokens |

### migrateFractions

```solidity
function migrateFractions(address _vault, uint256 _proposalId) external
```

Migrates the caller's fractions from an old vault to a new one after a successful migration

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vault | address | Address of the vault |
| _proposalId | uint256 | ID of the proposal |

### generateMerkleTree

```solidity
function generateMerkleTree(address[] _modules) public view returns (bytes32[] hashes)
```

Generates the merkle tree of a given proposal

| Name | Type | Description |
| ---- | ---- | ----------- |
| _modules | address[] | List of module contracts |

| Name | Type | Description |
| ---- | ---- | ----------- |
| hashes | bytes32[] | Combined list of leaf nodes |

### _calculateTotal

```solidity
function _calculateTotal(uint256 _scalar, uint256 _lastTotalSupply, uint256 _totalEth, uint256 _totalFractions) private pure returns (uint256)
```

Calculates the total amount of ether

| Name | Type | Description |
| ---- | ---- | ----------- |
| _scalar | uint256 | Scalar used for multiplication |
| _lastTotalSupply | uint256 | Previous total fractional supply of the vault |
| _totalEth | uint256 | Total ether balance of the proposal |
| _totalFractions | uint256 | Total fractional balance of the proposal |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | Total amount of ether |

### _calculateContribution

```solidity
function _calculateContribution(uint256 _totalInEth, uint256 _lastTotalSupply, uint256 _userProposalEth, uint256 _userProposalFractions) private pure returns (uint256)
```

Calculates the amount of ether contributed by the user

| Name | Type | Description |
| ---- | ---- | ----------- |
| _totalInEth | uint256 | Total amount of ether |
| _lastTotalSupply | uint256 | Previous total fractional supply of the vault |
| _userProposalEth | uint256 | User balance of ether for the proposal |
| _userProposalFractions | uint256 | User balance of fractions for the proposal |

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | uint256 | Total contribution amount |

