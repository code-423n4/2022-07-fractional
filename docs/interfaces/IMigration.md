# Solidity API

## Proposal

```solidity
struct Proposal {
  uint256 startTime;
  uint256 targetPrice;
  uint256 totalEth;
  uint256 totalFractions;
  address[] modules;
  address[] plugins;
  bytes4[] selectors;
  address newVault;
  bool isCommited;
  uint256 oldFractionSupply;
  uint256 newFractionSupply;
  bool fractionsMigrated;
}
```

## IMigration

_Interface for Migration module contract_

### NewFractionsAlreadyMinted

```solidity
error NewFractionsAlreadyMinted()
```

_Emitted when someone attempts to mint more new fractions into existence_

### NewVaultAlreadyDeployed

```solidity
error NewVaultAlreadyDeployed(address _newVault)
```

_Emitted when someone attempts to deploy a vault after a migration has already redeployed one_

### NoContributionToWithdraw

```solidity
error NoContributionToWithdraw()
```

_Emitted when a user attempts to withdraw non existing contributions_

### NotProposalBuyout

```solidity
error NotProposalBuyout()
```

_Emitted when the buyout was not initiated by a migration_

### NotProposed

```solidity
error NotProposed()
```

_Emitted when an action is taken on a proposal id that does not exist_

### NotVault

```solidity
error NotVault(address _vault)
```

_Emitted when the address is not a registered vault_

### NoVaultToMigrateTo

```solidity
error NoVaultToMigrateTo()
```

_Emitted when a user attempts to settle an action before a new vault has been deployed_

### ProposalOver

```solidity
error ProposalOver()
```

_Emitted when an action is taken on a migration with a proposal period that has ended_

### UnsuccessfulMigration

```solidity
error UnsuccessfulMigration()
```

_Emitted when a migration is attempted after an unsuccessful buyout_

### FractionsMigrated

```solidity
event FractionsMigrated(address _oldVault, address _newVault, uint256 _proposalId, uint256 _amount)
```

_Event log for minting the new fractional supply for a vault_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _oldVault | address | Address of the old vault |
| _newVault | address | Address of the new vault |
| _proposalId | uint256 | id of the proposal |
| _amount | uint256 | Amount of fractions settled |

### VaultMigrated

```solidity
event VaultMigrated(address _oldVault, address _newVault, uint256 _proposalId, address[] _modules, address[] _plugins, bytes4[] _selectors)
```

_Event log for settling a vault_

| Name | Type | Description |
| ---- | ---- | ----------- |
| _oldVault | address | Address of the old vault |
| _newVault | address | Address of the vault |
| _proposalId | uint256 | id of the proposal for the Migration |
| _modules | address[] | Addresses of module contracts |
| _plugins | address[] | Addresses of plugin contracts |
| _selectors | bytes4[] | List of plugin function selectors |

### PROPOSAL_PERIOD

```solidity
function PROPOSAL_PERIOD() external view returns (uint256)
```

### batchMigrateVaultERC1155

```solidity
function batchMigrateVaultERC1155(address _vault, uint256 _proposalId, address _nft, uint256[] _ids, uint256[] _amounts, bytes32[] _erc1155BatchTransferProof) external
```

### buyout

```solidity
function buyout() external view returns (address payable)
```

### commit

```solidity
function commit(address _vault, uint256 _proposalId) external returns (bool started)
```

### generateMerkleTree

```solidity
function generateMerkleTree(address[] _modules) external view returns (bytes32[] hashes)
```

### join

```solidity
function join(address _vault, uint256 _proposalId, uint256 _amount) external payable
```

### leave

```solidity
function leave(address _vault, uint256 _proposalId) external
```

### migrateFractions

```solidity
function migrateFractions(address _vault, uint256 _proposalId) external
```

### migrateVaultERC20

```solidity
function migrateVaultERC20(address _vault, uint256 _proposalId, address _token, uint256 _amount, bytes32[] _erc20TransferProof) external
```

### migrateVaultERC721

```solidity
function migrateVaultERC721(address _vault, uint256 _proposalId, address _nft, uint256 _tokenId, bytes32[] _erc721TransferProof) external
```

### migrationInfo

```solidity
function migrationInfo(address, uint256) external view returns (uint256 startTime, uint256 targetPrice, uint256 totalEth, uint256 totalFractions, address newVault, bool isCommited, uint256 oldFractionSupply, uint256 newFractionSupply, bool fractionsMigrated)
```

### nextId

```solidity
function nextId() external view returns (uint256)
```

### propose

```solidity
function propose(address _vault, address[] _modules, address[] _plugins, bytes4[] _selectors, uint256 _newFractionSupply, uint256 _targetPrice) external
```

### registry

```solidity
function registry() external view returns (address)
```

### settleFractions

```solidity
function settleFractions(address _vault, uint256 _proposalId, bytes32[] _mintProof) external
```

### settleVault

```solidity
function settleVault(address _vault, uint256 _proposalId) external
```

### withdrawContribution

```solidity
function withdrawContribution(address _vault, uint256 _proposalId) external
```

