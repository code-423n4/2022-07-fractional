// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import {Permission} from "./IVaultRegistry.sol";
import {State} from "./IBuyout.sol";

/// @dev Struct of migration proposal info for a vault
struct Proposal {
    // Start time of the migration proposal
    uint256 startTime;
    // Target buyout price for the migration
    uint256 targetPrice;
    // Total ether contributed to the migration
    uint256 totalEth;
    // Total fractions contributed to the migration
    uint256 totalFractions;
    // Module contract addresses proposed for the migration
    address[] modules;
    // Plugin contract addresses proposed for the migration
    address[] plugins;
    // Function selectors for the proposed plugins
    bytes4[] selectors;
    // Address for the new vault to migrate to (if buyout is succesful)
    address newVault;
    // Boolean status to check if the propoal is active
    bool isCommited;
    // Old fraction supply for a given vault
    uint256 oldFractionSupply;
    // New fraction supply for a given vault that has succesfully migrated
    uint256 newFractionSupply;
    // Boolean status to check that the fractions have already been migrated
    bool fractionsMigrated;
}

/// @dev Interface for Migration module contract
interface IMigration {
    /// @dev Emitted when someone attempts to mint more new fractions into existence
    error NewFractionsAlreadyMinted();
    /// @dev Emitted when someone attempts to deploy a vault after a migration has already redeployed one
    error NewVaultAlreadyDeployed(address _newVault);
    /// @dev Emitted when a user attempts to withdraw non existing contributions
    error NoContributionToWithdraw();
    /// @dev Emitted when the buyout was not initiated by a migration
    error NotProposalBuyout();
    /// @dev Emitted when an action is taken on a proposal id that does not exist
    error NotProposed();
    /// @dev Emitted when the address is not a registered vault
    error NotVault(address _vault);
    /// @dev Emitted when a user attempts to settle an action before a new vault has been deployed
    error NoVaultToMigrateTo();
    /// @dev Emitted when an action is taken on a migration with a proposal period that has ended
    error ProposalOver();
    /// @dev Emitted when a migration is attempted after an unsuccessful buyout
    error UnsuccessfulMigration();

    /// @dev Event log for minting the new fractional supply for a vault
    /// @param _oldVault Address of the old vault
    /// @param _newVault Address of the new vault
    /// @param _proposalId id of the proposal
    /// @param _amount Amount of fractions settled
    event FractionsMigrated(
        address indexed _oldVault,
        address indexed _newVault,
        uint256 _proposalId,
        uint256 _amount
    );
    /// @dev Event log for settling a vault
    /// @param _oldVault Address of the old vault
    /// @param _newVault Address of the vault
    /// @param _proposalId id of the proposal for the Migration
    /// @param _modules Addresses of module contracts
    /// @param _plugins Addresses of plugin contracts
    /// @param _selectors List of plugin function selectors
    event VaultMigrated(
        address indexed _oldVault,
        address indexed _newVault,
        uint256 _proposalId,
        address[] _modules,
        address[] _plugins,
        bytes4[] _selectors
    );

    function PROPOSAL_PERIOD() external view returns (uint256);

    function batchMigrateVaultERC1155(
        address _vault,
        uint256 _proposalId,
        address _nft,
        uint256[] memory _ids,
        uint256[] memory _amounts,
        bytes32[] memory _erc1155BatchTransferProof
    ) external;

    function buyout() external view returns (address payable);

    function commit(address _vault, uint256 _proposalId)
        external
        returns (bool started);

    function generateMerkleTree(address[] memory _modules)
        external
        view
        returns (bytes32[] memory hashes);

    function join(
        address _vault,
        uint256 _proposalId,
        uint256 _amount
    ) external payable;

    function leave(address _vault, uint256 _proposalId) external;

    function migrateFractions(address _vault, uint256 _proposalId) external;

    function migrateVaultERC20(
        address _vault,
        uint256 _proposalId,
        address _token,
        uint256 _amount,
        bytes32[] memory _erc20TransferProof
    ) external;

    function migrateVaultERC721(
        address _vault,
        uint256 _proposalId,
        address _nft,
        uint256 _tokenId,
        bytes32[] memory _erc721TransferProof
    ) external;

    function migrationInfo(address, uint256)
        external
        view
        returns (
            uint256 startTime,
            uint256 targetPrice,
            uint256 totalEth,
            uint256 totalFractions,
            address newVault,
            bool isCommited,
            uint256 oldFractionSupply,
            uint256 newFractionSupply,
            bool fractionsMigrated
        );

    function nextId() external view returns (uint256);

    function propose(
        address _vault,
        address[] memory _modules,
        address[] memory _plugins,
        bytes4[] memory _selectors,
        uint256 _newFractionSupply,
        uint256 _targetPrice
    ) external;

    function registry() external view returns (address);

    function settleFractions(
        address _vault,
        uint256 _proposalId,
        bytes32[] memory _mintProof
    ) external;

    function settleVault(address _vault, uint256 _proposalId) external;

    function withdrawContribution(address _vault, uint256 _proposalId) external;
}
