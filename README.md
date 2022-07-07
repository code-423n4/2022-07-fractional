# Fractional v2 contest details

- $71,250 USDC main award pot
- $3,750 USDC gas optimization award pot
- Join [C4 Discord](https://discord.gg/code4rena) to register
- Submit findings [using the C4 form](https://code4rena.com/contests/2022-07-fractional-v2-contest/submit)
- [Read our guidelines for more details](https://docs.code4rena.com/roles/wardens)
- Starts July 7, 2022 20:00 UTC
- Ends July 14, 2022 20:00 UTC

# Contest Scope

This contest is open for one week to give wardens time to understand the protocol properly.  Representatives from Fractional will be available in the Code Arena Discord to answer any questions during the contest period. The focus of the contest is to try and find any logic errors, mint/burn fractions unexpectedly, or ways to remove NFTs from the Fractional Vaults in ways that would be beneficial for an attacker at the expense of vault creators or fraction holders. Wardens should assume that governance variables are set sensibly (unless they can find a way to change the value of a governance variable, and not counting social engineering approaches for this).

## Protocol overview

> The Fractional v2 Protocol is designed around the concept of Hyperstructures

[**Hyperstructures**](https://jacob.energy/hyperstructures.html): *Crypto protocols that can run for free and forever, without maintenance, interruption, or intermediaries*

Fractional is a decentralized protocol that allows for shared ownership and governance of NFTs. When an NFT is fractionalized, the newly minted tokens function as normal ERC-1155 tokens which govern the non-custodial Vault containing the NFT(s).

## Vaults

> The home of all items on Fractional

Vaults are a slightly modified implementation of [PRBProxy](https://github.com/paulrberg/prb-proxy) which is a basic and non-upgradeable proxy contract. Think of a Vault as a smart wallet that enables the execution of arbitrary smart contract calls in a single transaction. Generally, the calls a Vault can make are disabled and must be explicitly allowed through permissions. The vault is intentionally left unopinionated and extremely flexible for experimentation in the future.

## Permissions

> Authorize transactions performed on a vault

A permission is a combination of a **Module** contract, **Target** contract, and specific function **Selector** in a target contract that can be executed by the vault. A group of permissions creates the set of functions that are callable on the Vault in order to carry out its specific use case. Each permission is then hashed and used as a leaf node to generate a merkle tree, where the merkle root of the tree is stored on the vault itself. Whenever a transaction is executed on a vault, a merkle proof is used to verify legitimacy of the leaf node (*Permission*) and the Merkle root.

For example, a vault involved in an active buyout will need permission to burn fractional tokens. Therefore, a permission will be set on the deployment of the vault that consists of the `Buyout` contract address (*Module*), `Supply` contract address (*Target*), and a burn function (*Selector*) which is declared in the `Supply` contract. This same process will then be repeated for all pre-defined actions that a vault may want, such as minting fractional tokens or transferring assets out of the vault.

## Modules

> Make vaults do cool stuff

Modules are the bread and butter of what makes Fractional unique. At Vault creation, modules are added to permissions for the vault. Each module should have specific goals it plans to accomplish. Some general examples are *Buyouts*, *Inflation*, *Migration*, and *Renting*. If a vault wants to update the set of modules enabled, then it must have the migration module enabled and go through the migration process.

In general, it is highly recommended for vaults to have a module that enables items to be removed from vaults. Without this, all items inside of a vault will be stuck forever.

## Protoforms

> Protoforms are templates for common vault use-cases

Protoforms aggregate static sets of module permissions to deploy vaults with similar base functionality.  Protoforms are the main entry point for deploying a vault with a certain use-case determined by the modules that are enabled on a vault.

## Targets

> Execute vault transactions

Targets are stateless script-like contracts for executing transactions by the Vault on-behalf of a user. Only functions of a target contract that are initially set as enabled permissions for a vault can be executed by a vault.

# Smart Contracts

All the contracts in this section are to be reviewed. Any contracts not in this list are to be ignored for this contest.

|File|nSLOC|Lines|Description
|:-|:-:|:-:|:-|
|[src/FERC1155.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/FERC1155.sol)|195|398|ERC-1155 implementation for Fractional tokens
|[src/Vault.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/Vault.sol)|80|148|Proxy contract for storing fractionalized assets
|[src/VaultFactory.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/VaultFactory.sol)|50|90|Factory contract for deploying fractional vaults
|[src/VaultRegistry.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/VaultRegistry.sol)|75|178|Registry contract for tracking all fractional vaults and deploying token contracts
|[src/constants/Memory.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/constants/Memory.sol)|14|20|Global list of constants used for assembly optimizations
|[src/constants/Permit.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/constants/Permit.sol)|10|17|Global list of constants used for EIP-712 permit functionality
|[src/constants/Supply.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/constants/Supply.sol)|28|40|List of constants used inside the Supply target contract
|[src/constants/Transfer.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/constants/Transfer.sol)|80|129|List of constants used inside the Transfer target contract
|[src/interfaces/IBaseVault.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IBaseVault.sol)|6|46|Interface for BaseVault protoform contract
|[src/interfaces/IBuyout.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IBuyout.sol)|38|159|Interface for Buyout module contract
|[src/interfaces/IERC1155.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IERC1155.sol)|23|60|Interface for generic ERC-1155 contract
|[src/interfaces/IERC20.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IERC20.sol)|9|48|Interface for generic ERC-20 contract
|[src/interfaces/IERC721.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IERC721.sol)|18|63|Interface for generic ERC-721 contract
|[src/interfaces/IFERC1155.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IFERC1155.sol)|20|135|Interface for FERC1155 token contract
|[src/interfaces/IMigration.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IMigration.sol)|42|168|Interface for Migration module contract
|[src/interfaces/IMinter.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IMinter.sol)|5|10|Interface for Minter contract
|[src/interfaces/IModule.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IModule.sol)|4|14|Interface for generic Module contract
|[src/interfaces/INFTReceiver.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/INFTReceiver.sol)|3|28|Interface for NFTReceiver contract
|[src/interfaces/IProtoform.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IProtoform.sol)|4|20|Interface for generic Protoform contract
|[src/interfaces/ISupply.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/ISupply.sol)|5|14|Interface for Supply targert contract
|[src/interfaces/ITransfer.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/ITransfer.sol)|26|79|Interface for Transfer target contract
|[src/interfaces/IVault.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IVault.sol)|17|65|Interface for Vault proxy contract
|[src/interfaces/IVaultFactory.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IVaultFactory.sol)|11|34|Interface for VaultFactory contract
|[src/interfaces/IVaultRegistry.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/interfaces/IVaultRegistry.sol)|19|92|Interface for VaultRegistry contract
|[src/modules/Buyout.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/modules/Buyout.sol)|293|504|Module contract for vaults to hold buyout pools
|[src/modules/Migration.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/modules/Migration.sol)|305|548|Module contract for vaults to migrate to a new set of permissions
|[src/modules/Minter.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/modules/Minter.sol)|30|62|Module contract for minting a fixed supply of fractions
|[src/modules/protoforms/BaseVault.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/modules/protoforms/BaseVault.sol)|68|138|Protoform contract for vault deployments with a fixed supply and buyout mechanism
|[src/references/SupplyReference.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/references/SupplyReference.sol)|15|32|Reference implementation for the optimized Supply target contract
|[src/references/TransferReference.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/references/TransferReference.sol)|19|70|Reference implementation for the optimized Transfer target contract
|[src/targets/Supply.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/targets/Supply.sol)|114|199|Target contract for minting and burning fractional tokens
|[src/targets/Transfer.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/targets/Transfer.sol)|444|703|Target contract for transferring fungible and non-fungible tokens
|[src/utils/MerkleBase.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/utils/MerkleBase.sol)|101|193|Utility contract for generating merkle roots and verifying proofs
|[src/utils/Metadata.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/utils/Metadata.sol)|19|39|Utility contract for storing metadata of an FERC1155 token
|[src/utils/Multicall.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/utils/Multicall.sol)|26|45|Utility contract that enables calling multiple local methods in a single call
|[src/utils/SafeSend.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/utils/SafeSend.sol)|17|36|Utility contract for sending Ether or WETH value to an address
|[src/utils/SelfPermit.sol](https://github.com/code-423n4/2022-07-fractional/blob/e2c5a962a94106f9495eb96769d7f60f7d5b14c9/src/utils/SelfPermit.sol)|27|64|Utility contract for executing a permit signature to update the approval status of an FERC1155 token
|Total:| 2274 | 4730 |


### BaseVault.sol
*External Contracts*: `IERC20`, `IERC721`, `IERC1155`, `IModule`, `IVaultRegistry`

### Buyout.sol
*External Contracts*: `IERC1155`, `ISupply`, `ITransfer`, `IVault`, `IVaultRegistry`

### IBaseVault.sol
*External Contracts*: `IProtoform`

### IBuyout.sol
*External Contracts*: `IModule`

### IMinter.sol
*External Contracts*: `IModule`

### FERC1155.sol
*External Contracts*: `IFERC1155`, `INFTReceiver`

*Libraries*: **clones-with-immutable-args/src/Clone.sol**, **@rari-capital/solmate/src/tokens/ERC1155.sol**

### Migration.sol
*External Contracts*: `IBuyout`, `IERC20`, `IERC721`, `IERC1155`, `IFERC1155`, `IModule`, `IVaultRegistry`

*Libraries*: **@rari-capital/solmate/src/utils/ReentrancyGuard.sol**

### Minter.sol
*External Contracts*: `IVault`

### SafeSend.sol
*Libraries*: **@rari-capital/solmate/src/tokens/WETH.sol**

### Supply.sol
*External Contracts*: `IVaultRegistry`

### Transfer.sol
*External Contracts*: `IERC20`, `IERC721`, `IERC1155`

### Vault.sol
*Libraries*: **@openzeppelin/contracts/utils/cryptography/MerkleProof.sol**

### VaultFactory.sol
*External Contracts*: `Vault`

*Libraries*: **clones-with-immutable-args/src/Create2ClonesWithImmutableArgs.sol**

### VaultRegistry.sol
*External Contracts*: `FERC1155`, `IVault`, `VaultFactory`

*Libraries*: **clones-with-immutable-args/src/ClonesWithImmutableArgs.sol**


## Areas of concern for Wardens

We would like wardens to focus on any core functional logic, boundary case errors, or similar issues which could be utilized by an attacker to take assets away from fraction holders or vault curators who deposit assets into the Vaults. Any errors may be submitted by wardens for review and potential reward as per the normal issue impact prioritization. Gas optimizations are welcome but not the main focus of this contest and thus at most 5% of the contest reward will be allocated to gas optimizations. For gas optimizations, the most important flows are BaseVault deployment, buyout claims/withdrawals, and migration flows.

If wardens are unclear on which areas to look at or which areas are important please feel free to ask in the contest Discord channel.

## Tests

A full set of unit tests are provided in the repo. To run these do the following:

## Prepare Environment

1. install `node`, refer to [nodejs](https://nodejs.org/en/)

2. install `foundry`, refer to [foundry](https://github.com/foundry-rs/foundry)

### Setup Environment

> Required **node >12**

1. run `make deps` in root directory - Installs gitmodule dependencies

2. create `.env` file in root directory and add the following:
```
ALCHEMY_API_KEY=
DEPLOYER_PRIVATE_KEY=
ETHERSCAN_API_KEY=
```

3. run `npm ci` in root directory - Installs node dependencies

4. run `make users` - Generates user proxies

5. run `make test` - Runs foundry tests

## Glossary

| Name                                                                                                     | Description                                                                              |
| -------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------- |
| [Blacksmith](https://github.com/pbshgthm/blacksmith)                                                     | Full-fledged contract generator to create User contracts for testing purposes            |
| [ClonesWithImmutableArgs](https://github.com/wighawag/clones-with-immutable-args)                        | Enables creating clone contracts with immutable arguments                                |
| [Forge Standard Library](https://github.com/foundry-rs/forge-std)                                        | Leverages forge's cheatcodes to make writing tests easier and faster in Foundry          |
| [Foundry](https://github.com/foundry-rs/foundry)                                                         | Framework for Ethereum application development                                           |
| [Hardhat](https://github.com/NomicFoundation/hardhat)                                                    | Development environment for deploying and interacting with smart contracts               |
| [Multicall (Uniswap v3)](https://github.com/Uniswap/v3-periphery/blob/main/contracts/base/Multicall.sol) | Enables calling multiple methods in a single call to the contract                        |
| [Murky](https://github.com/dmfxyz/murky)                                                                 | Generates merkle roots and verifies proofs in Solidity                                   |
| [NatSpec Format](https://docs.soliditylang.org/en/v0.8.13/natspec-format.html)                           | A special form of comments to provide rich documentation                                 |
| [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts)                                   | Library of community-vetted code for secure smart contract development                   |
| [PRBProxy](https://github.com/paulrberg/prb-proxy)                                                       | Proxy contract to compose Ethereum transactions on behalf of the owner                   |
| [Seaport](https://github.com/ProjectOpenSea/seaport/blob/main/contracts/lib/TokenTransferrer.sol)        | Library for performing optimized token transfers from OpenSea's new marketplace protocol |
| [Solidity Style Guide](https://github.com/ethereum/solidity/blob/develop/docs/style-guide.rst)           | Standard coding conventions for writing Solidity code                                    |
| [Solmate](https://github.com/Rari-Capital/solmate)                                                       | Building blocks for smart contract development                                           |
