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

#### FERC1155.sol (265 sloc each)

```markdown
ERC-1155 implementation for Fractional tokens

External Contracts: IFERC1155, INFTReceiver

Libraries: Clone, ERC1155, IFERC1155, INFTReceiver
```

#### Vault.sol (90 sloc each)

```markdown
Proxy contract for storing fractionalized assets

External Contracts: MerkleProof

Libraries: IVault, NFTReceiver
```

#### VaultFactory.sol (55 sloc each)

```
Factory contract for deploying fractional vaults

External Contracts: Vault

Libraries: Create2ClonesWithImmutableArgs, IVaultFactory
```

#### VaultRegistry.sol (103 sloc each)

```
Registry contract for tracking all fractional vaults and deploying token contracts

External Contracts: FERC1155, IVault, VaultFactory

Libraries: ClonesWithImmutableArgs, IVaultRegistry
```

#### Supply.sol (114 sloc)

```
Target contract for minting and burning fractional tokens

External Contracts: IVaultRegistry 

Libraries: ISupply
```

#### Transfer.sol (466 sloc)

```
Target contract for transferring fungible and non-fungible tokens

External Contracts: IERC20, IERC721, IERC1155

Libraries: ITransfer
```

#### Buyout.sol (324 sloc)

```
Module contract for vaults to hold buyout pools

External Contracts: IERC1155, ISupply, ITransfer, IVault, IVaultRegistry

Libraries: IBuyout, Multicall, NFTReceiver, SafeSend, SelfPermit
```

#### Migration.sol (365 sloc)

```
Module contract for vaults to migrate to a new set of permissions

External Contracts: IBuyout, IERC20, IERC721, IERC1155, IFERC1155, IModule, IVaultRegistry

Libraries: IMigration, MerkleBase, Minter, Multicall, NFTReceiver, ReentrancyGuard
```

#### Minter.sol (39 sloc)

```
Module contract for minting a fixed supply of fractions

External Contracts: IVault

Libraries: IMinter, ISupply
```

#### BaseVault.sol (95 sloc)

```
Protoform contract for vault deployments with a fixed supply and buyout mechanism

External Contracts: IERC20, IERC721, IERC1155, IModule, IVaultRegistry

Libraries: IBaseVault, MerkleBase, Minter, Multicall
```

#### Memory.sol (13 sloc)

```
Global list of constants used for assembly optimizations
```

#### Permit.sol (9 sloc)

```
Global list of constants used for EIP-712 permit functionality
```

#### SupplyReference.sol (15 sloc)

```
Reference implementation for the optimized Supply target contract
```

#### TransferReference.sol (40 sloc)

```
Reference implementation for the optimized Transfer target contract
```

#### MerkleBase.sol (116 sloc)

```
Utility contract for generating merkle roots and verifying proofs
```

#### Metadata.sol (17 sloc)

```
Utility contract for storing metadata of a FERC1155 token
```

#### Multicall.sol (28 sloc)

```
Utility contract that enables calling multiple local methods in a single call
```

#### SafeSend.sol (18 sloc)

```
Utility contract for sending Ether or WETH value to an address
```

#### SelfPermit.sol (40 sloc)

```
Utility contract for executing a permit signature to update the approval status in an FERC1155 contract
```

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

1. `npm ci` in root folder - Installs node dependencies
2. `make deps` - installs gitmodule dependencies
3. `make users` - Generates user proxies
4. `make test` - Runs foundry tests

## Glossary


| [Blacksmith](https://github.com/pbshgthm/blacksmith)         | Full-fledged contract generator to create User contracts for testing purposes |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| [ClonesWithImmutableArgs](https://github.com/wighawag/clones-with-immutable-args) | Library for creating clone contracts with immutable arguments |
| [Forge Standard Library](https://github.com/foundry-rs/forge-std) | Leverages `forge`'s cheatcodes to make writing tests easier and faster in Foundry |
| [Foundry](https://github.com/foundry-rs/foundry)             | Framework for Ethereum application development               |
| [Hardhat](https://github.com/NomicFoundation/hardhat)        | Development environment for deploying and interacting with smart contracts |
| [Murky](https://github.com/dmfxyz/murky)                     | Library for generating merkle roots and verifying proofs in Solidity |
| [Natspec](https://docs.soliditylang.org/en/v0.8.13/natspec-format.html) | A special form of comments to provide rich documentation     |
| [OpenZeppelin](https://github.com/OpenZeppelin/openzeppelin-contracts) | Library of community-vetted code for secure smart contract development |
| [PRBProxy](https://github.com/paulrberg/prb-proxy)           | Proxy contract to compose Ethereum transactions on behalf of the owner |
| [Seaport](https://github.com/ProjectOpenSea/seaport)         | OpenSea's new marketplace protocol                           |
| [Solmate](https://github.com/Rari-Capital/solmate)           | Building blocks for smart contract development               |
| [Style Guide](https://github.com/ethereum/solidity/blob/develop/docs/style-guide.rst) | Standard coding conventions for formatting and organizing Solidity code |
