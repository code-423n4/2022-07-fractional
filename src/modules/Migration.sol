// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.13;

import {IBuyout, Auction, State} from "../interfaces/IBuyout.sol";
import {IERC20} from "../interfaces/IERC20.sol";
import {IERC721} from "../interfaces/IERC721.sol";
import {IERC1155} from "../interfaces/IERC1155.sol";
import {IFERC1155} from "../interfaces/IFERC1155.sol";
import {IMigration, Proposal} from "../interfaces/IMigration.sol";
import {IModule} from "../interfaces/IModule.sol";
import {IVault} from "../interfaces/IVault.sol";
import {IVaultRegistry, Permission} from "../interfaces/IVaultRegistry.sol";
import {MerkleBase} from "../utils/MerkleBase.sol";
import {Minter} from "./Minter.sol";
import {Multicall} from "../utils/Multicall.sol";
import {NFTReceiver} from "../utils/NFTReceiver.sol";
import {ReentrancyGuard} from "@rari-capital/solmate/src/utils/ReentrancyGuard.sol";

/// @title Migration
/// @author Fractional Art
/// @notice Module contract for vaults to migrate to a new set of permissions
/// - A fractional holder creates a proposal with a target price and list of modules
/// - For 7 days, users can contribute their fractions / ether to signal support
/// - If the target price is reached then a buyout can be triggered and trading
///   against the proposed buyout price can take place to resolve the outcome
/// - If a proposal holds more than 51% of the total supply, the buyout succeeds, a new vault can
///   be created and the underlying assets (ERC-20, ERC-721 and ERC-1155 tokens) can be migrated
contract Migration is
    IMigration,
    MerkleBase,
    Minter,
    Multicall,
    NFTReceiver,
    ReentrancyGuard
{
    /// @notice Address of Buyout module contract
    address payable public buyout;
    /// @notice Address of VaultRegistry contract
    address public registry;
    /// @notice Counter used to assign IDs to new proposals
    uint256 public nextId;
    /// @notice The length for the migration proposal period
    uint256 public constant PROPOSAL_PERIOD = 7 days;
    /// @notice Mapping of a vault to it's proposal migration information
    mapping(address => mapping(uint256 => Proposal)) public migrationInfo;
    /// @notice Mapping of a proposal ID to a user's ether contribution
    mapping(uint256 => mapping(address => uint256)) private userProposalEth;
    /// @notice Mapping of a proposal ID to a user's fractions contribution
    mapping(uint256 => mapping(address => uint256))
        private userProposalFractions;

    /// @notice Initializes buyout, registry, and supply contracts
    constructor(
        address _buyout,
        address _registry,
        address _supply
    ) Minter(_supply) {
        buyout = payable(_buyout);
        registry = _registry;
    }

    /// @dev Callback for receiving ether when the calldata is empty
    receive() external payable {}

    /// @notice Proposes a set of modules and plugins to migrate a vault to
    /// @param _vault Address of the vault
    /// @param _modules Addresses of module contracts
    /// @param _plugins Addresses of plugin contracts
    /// @param _selectors List of plugin function selectors
    /// @param _newFractionSupply New supply of fractional tokens
    /// @param _targetPrice Target price of the buyout
    function propose(
        address _vault,
        address[] calldata _modules,
        address[] calldata _plugins,
        bytes4[] calldata _selectors,
        uint256 _newFractionSupply,
        uint256 _targetPrice
    ) external {
        // Reverts if address is not a registered vault
        (, uint256 id) = IVaultRegistry(registry).vaultToToken(_vault);
        if (id == 0) revert NotVault(_vault);
        // Reverts if buyout state is not inactive
        (, , State current, , , ) = IBuyout(buyout).buyoutInfo(_vault);
        State required = State.INACTIVE;
        if (current != required) revert IBuyout.InvalidState(required, current);

        // Initializes migration proposal info
        Proposal storage proposal = migrationInfo[_vault][++nextId];
        proposal.startTime = block.timestamp;
        proposal.targetPrice = _targetPrice;
        proposal.modules = _modules;
        proposal.plugins = _plugins;
        proposal.selectors = _selectors;
        proposal.oldFractionSupply = IVaultRegistry(registry).totalSupply(
            _vault
        );
        proposal.newFractionSupply = _newFractionSupply;
    }

    /// @notice Joins a migration proposal by contributing ether and fractional tokens
    /// @param _vault The address of the vault
    /// @param _proposalId ID of the proposal being contributed to
    /// @param _amount Number of fractions being contributed
    function join(
        address _vault,
        uint256 _proposalId,
        uint256 _amount
    ) external payable nonReentrant {
        // Reverts if address is not a registered vault
        (address token, uint256 id) = IVaultRegistry(registry).vaultToToken(
            _vault
        );
        if (id == 0) revert NotVault(_vault);
        // Reverts if buyout state is not inactive
        (, , State current, , , ) = IBuyout(buyout).buyoutInfo(_vault);
        State required = State.INACTIVE;
        if (current != required) revert IBuyout.InvalidState(required, current);

        // Gets the migration proposal for the given ID
        Proposal storage proposal = migrationInfo[_vault][_proposalId];
        // Updates ether balances of the proposal and caller
        proposal.totalEth += msg.value;
        userProposalEth[_proposalId][msg.sender] += msg.value;
        // Deposits fractional tokens into contract
        IFERC1155(token).safeTransferFrom(
            msg.sender,
            address(this),
            id,
            _amount,
            ""
        );
        // Updates fraction balances of the proposal and caller
        proposal.totalFractions += _amount;
        userProposalFractions[_proposalId][msg.sender] += _amount;
    }

    /// @notice Leaves a proposed migration with contribution amount
    /// @param _vault Address of the vault
    /// @param _proposalId ID of the proposal being left
    function leave(address _vault, uint256 _proposalId) external {
        // Reverts if address is not a registered vault
        (address token, uint256 id) = IVaultRegistry(registry).vaultToToken(
            _vault
        );
        if (id == 0) revert NotVault(_vault);
        // Reverts if buyout state is not inactive
        (, , State current, , , ) = IBuyout(buyout).buyoutInfo(_vault);
        State required = State.INACTIVE;
        if (current != required) revert IBuyout.InvalidState(required, current);

        // Gets the migration proposal for the given ID
        Proposal storage proposal = migrationInfo[_vault][_proposalId];
        // Updates fraction balances of the proposal and caller
        uint256 amount = userProposalFractions[_proposalId][msg.sender];
        proposal.totalFractions -= amount;
        userProposalFractions[_proposalId][msg.sender] = 0;
        // Updates ether balances of the proposal and caller
        uint256 ethAmount = userProposalEth[_proposalId][msg.sender];
        proposal.totalEth -= ethAmount;
        userProposalEth[_proposalId][msg.sender] = 0;

        // Withdraws fractions from contract back to caller
        IFERC1155(token).safeTransferFrom(
            address(this),
            msg.sender,
            id,
            amount,
            ""
        );
        // Withdraws ether from contract back to caller
        payable(msg.sender).transfer(ethAmount);
    }

    /// @notice Kicks off the buyout process for a migration
    /// @param _vault Address of the vault
    /// @param _proposalId ID of the proposal being committed to
    /// @return started Bool status of starting the buyout process
    function commit(address _vault, uint256 _proposalId)
        external
        returns (bool started)
    {
        // Reverts if address is not a registered vault
        (address token, uint256 id) = IVaultRegistry(registry).vaultToToken(
            _vault
        );
        if (id == 0) revert NotVault(_vault);
        // Reverts if buyout state is not inactive
        (, , State current, , , ) = IBuyout(buyout).buyoutInfo(_vault);
        State required = State.INACTIVE;
        if (current != required) revert IBuyout.InvalidState(required, current);
        // Reverts if migration is passed proposal period
        Proposal storage proposal = migrationInfo[_vault][_proposalId];
        if (block.timestamp > proposal.startTime + PROPOSAL_PERIOD)
            revert ProposalOver();

        // Calculates current price of the proposal based on total supply
        uint256 currentPrice = _calculateTotal(
            100,
            IVaultRegistry(registry).totalSupply(_vault),
            proposal.totalEth,
            proposal.totalFractions
        );

        // Checks if the current price is greater than target price of the proposal
        if (currentPrice > proposal.targetPrice) {
            // Sets token approval to the buyout contract
            IFERC1155(token).setApprovalFor(address(buyout), id, true);
            // Starts the buyout process
            IBuyout(buyout).start{value: proposal.totalEth}(_vault);
            proposal.isCommited = true;
            started = true;
        }
    }

    /// @notice Settles a migration by ending the buyout
    /// @dev Succeeds if buyout goes through, fails otherwise
    /// @param _vault Address of the vault
    /// @param _proposalId ID of the proposal being settled
    function settleVault(address _vault, uint256 _proposalId) external {
        // Reverts if the migration was not proposed
        Proposal storage proposal = migrationInfo[_vault][_proposalId];
        if (!(proposal.isCommited)) revert NotProposed();
        // Reverts if the migration was unsuccessful
        (, , State current, , , ) = IBuyout(buyout).buyoutInfo(_vault);
        if (current != State.SUCCESS) revert UnsuccessfulMigration();
        // Reverts if the new vault has already been deployed
        if (proposal.newVault != address(0))
            revert NewVaultAlreadyDeployed(proposal.newVault);

        // Gets the merkle root for the vault and given proposal ID
        bytes32[] memory merkleTree = generateMerkleTree(proposal.modules);
        bytes32 merkleRoot = getRoot(merkleTree);
        // Deploys a new vault with set permissions and plugins
        address newVault = IVaultRegistry(registry).create(
            merkleRoot,
            proposal.plugins,
            proposal.selectors
        );
        // Sets address of the newly deployed vault
        proposal.newVault = newVault;
        // Emits event for settling the new vault
        emit VaultMigrated(
            _vault,
            newVault,
            _proposalId,
            proposal.modules,
            proposal.plugins,
            proposal.selectors
        );
    }

    /// @notice Mints the fractional tokens for a new vault
    /// @param _vault Address of the vault
    /// @param _proposalId ID of the proposal
    /// @param _mintProof Merkle proof for minting fractional tokens
    function settleFractions(
        address _vault,
        uint256 _proposalId,
        bytes32[] calldata _mintProof
    ) external {
        // Reverts if the migration was unsuccessful
        (, , State current, , , ) = IBuyout(buyout).buyoutInfo(_vault);
        if (current != State.SUCCESS) revert UnsuccessfulMigration();
        // Reverts if there is no new vault to migrate to
        Proposal storage proposal = migrationInfo[_vault][_proposalId];
        if (proposal.newVault == address(0)) revert NoVaultToMigrateTo();
        // Reverts if fractions of the new vault have already been minted
        if (proposal.fractionsMigrated) revert NewFractionsAlreadyMinted();

        // Mints initial supply of fractions for the new vault
        _mintFractions(
            proposal.newVault,
            address(this),
            proposal.newFractionSupply,
            _mintProof
        );

        migrationInfo[_vault][_proposalId].fractionsMigrated = true;
        // Emits event for minting fractional tokens for the new vault
        emit FractionsMigrated(
            _vault,
            proposal.newVault,
            _proposalId,
            proposal.newFractionSupply
        );
    }

    /// @notice Retrieves ether and fractions deposited from an unsuccessful migration
    /// @param _vault Address of the vault
    /// @param _proposalId ID of the failed proposal
    function withdrawContribution(address _vault, uint256 _proposalId)
        external
    {
        // Reverts if address is not a registered vault
        (address token, uint256 id) = IVaultRegistry(registry).vaultToToken(
            _vault
        );
        if (id == 0) revert NotVault(_vault);
        // Reverts if caller has no fractional balance to withdraw
        (, , State current, , , ) = IBuyout(buyout).buyoutInfo(_vault);
        if (
            current != State.INACTIVE ||
            migrationInfo[_vault][_proposalId].newVault != address(0)
        ) revert NoContributionToWithdraw();

        // Temporarily store user's fractions for the transfer
        uint256 userFractions = userProposalFractions[_proposalId][msg.sender];
        // Updates fractional balance of caller
        userProposalFractions[_proposalId][msg.sender] = 0;
        // Withdraws fractional tokens from contract back to caller
        IFERC1155(token).safeTransferFrom(
            address(this),
            msg.sender,
            id,
            userFractions,
            ""
        );

        // Temporarily store user's eth for the transfer
        uint256 userEth = userProposalEth[_proposalId][msg.sender];
        // Udpates ether balance of caller
        userProposalEth[_proposalId][msg.sender] = 0;
        // Withdraws ether from contract back to caller
        payable(msg.sender).transfer(userEth);
    }

    /// @notice Migrates an ERC-20 token to the new vault after a successful migration
    /// @param _vault Address of the vault
    /// @param _proposalId ID of the proposal
    /// @param _token Address of the ERC-20 token
    /// @param _amount Transfer amount
    /// @param _erc20TransferProof Merkle proof for transferring an ERC-20 token
    function migrateVaultERC20(
        address _vault,
        uint256 _proposalId,
        address _token,
        uint256 _amount,
        bytes32[] calldata _erc20TransferProof
    ) external {
        address newVault = migrationInfo[_vault][_proposalId].newVault;
        // Withdraws an ERC-20 token from the old vault and transfers to the new vault
        IBuyout(buyout).withdrawERC20(
            _vault,
            _token,
            newVault,
            _amount,
            _erc20TransferProof
        );
    }

    /// @notice Migrates an ERC-721 token to the new vault after a successful migration
    /// @param _vault Address of the vault
    /// @param _proposalId ID of the proposal
    /// @param _token Address of the ERC-721 token
    /// @param _tokenId ID of the token
    /// @param _erc721TransferProof Merkle proof for transferring an ERC-721 token
    function migrateVaultERC721(
        address _vault,
        uint256 _proposalId,
        address _token,
        uint256 _tokenId,
        bytes32[] calldata _erc721TransferProof
    ) external {
        address newVault = migrationInfo[_vault][_proposalId].newVault;
        // Withdraws an ERC-721 token from the old vault and transfers to the new vault
        IBuyout(buyout).withdrawERC721(
            _vault,
            _token,
            newVault,
            _tokenId,
            _erc721TransferProof
        );
    }

    /// @notice Migrates an ERC-1155 token to the new vault after a successful migration
    /// @param _vault Address of the vault
    /// @param _proposalId ID of the proposal
    /// @param _token Address of the ERC-1155 token
    /// @param _id ID of the token
    /// @param _amount amount to be transferred
    /// @param _erc1155TransferProof Merkle proof for transferring an ERC-1155 token
    function migrateVaultERC1155(
        address _vault,
        uint256 _proposalId,
        address _token,
        uint256 _id,
        uint256 _amount,
        bytes32[] calldata _erc1155TransferProof
    ) external {
        address newVault = migrationInfo[_vault][_proposalId].newVault;
        // Withdraws an ERC-1155 token from the old vault and transfers to the new vault
        IBuyout(buyout).withdrawERC1155(
            _vault,
            _token,
            newVault,
            _id,
            _amount,
            _erc1155TransferProof
        );
    }

    /// @notice Batch migrates multiple ERC-1155 tokens to the new vault after a successful migration
    /// @param _vault Address of the vault
    /// @param _proposalId ID of the proposal
    /// @param _token Address of the ERC-1155 token
    /// @param _ids IDs of each token type
    /// @param _amounts Transfer amounts per token type
    /// @param _erc1155BatchTransferProof Merkle proof for batch transferring multiple ERC-1155 tokens
    function batchMigrateVaultERC1155(
        address _vault,
        uint256 _proposalId,
        address _token,
        uint256[] calldata _ids,
        uint256[] calldata _amounts,
        bytes32[] calldata _erc1155BatchTransferProof
    ) external {
        address newVault = migrationInfo[_vault][_proposalId].newVault;
        // Batch withdraws multiple ERC-1155 tokens from the old vault and transfers to the new vault
        IBuyout(buyout).batchWithdrawERC1155(
            _vault,
            _token,
            newVault,
            _ids,
            _amounts,
            _erc1155BatchTransferProof
        );
    }

    /// @notice Migrates the caller's fractions from an old vault to a new one after a successful migration
    /// @param _vault Address of the vault
    /// @param _proposalId ID of the proposal
    function migrateFractions(address _vault, uint256 _proposalId) external {
        // Reverts if address is not a registered vault
        (, uint256 id) = IVaultRegistry(registry).vaultToToken(_vault);
        if (id == 0) revert NotVault(_vault);
        // Reverts if buyout state is not successful
        (, address proposer, State current, , , ) = IBuyout(buyout).buyoutInfo(
            _vault
        );
        State required = State.SUCCESS;
        if (current != required) revert IBuyout.InvalidState(required, current);
        // Reverts if proposer of buyout is not this contract
        if (proposer != address(this)) revert NotProposalBuyout();

        // Gets the last total supply of fractions for the vault
        (, , , , , uint256 lastTotalSupply) = IBuyout(buyout).buyoutInfo(
            _vault
        );
        // Calculates the total ether amount of a successful proposal
        uint256 totalInEth = _calculateTotal(
            1 ether,
            lastTotalSupply,
            migrationInfo[_vault][_proposalId].totalEth,
            migrationInfo[_vault][_proposalId].totalFractions
        );
        // Calculates balance of caller based on ether contribution
        uint256 balanceContributedInEth = _calculateContribution(
            totalInEth,
            lastTotalSupply,
            userProposalEth[_proposalId][msg.sender],
            userProposalFractions[_proposalId][msg.sender]
        );

        // Gets the token and fraction ID of the new vault
        address newVault = migrationInfo[_vault][_proposalId].newVault;
        (address token, uint256 newFractionId) = IVaultRegistry(registry)
            .vaultToToken(newVault);
        // Calculates share amount of fractions for the new vault based on the new total supply
        uint256 newTotalSupply = IVaultRegistry(registry).totalSupply(newVault);
        uint256 shareAmount = (balanceContributedInEth * newTotalSupply) /
            totalInEth;

        // Transfers fractional tokens to caller based on share amount
        IFERC1155(token).safeTransferFrom(
            address(this),
            msg.sender,
            newFractionId,
            shareAmount,
            ""
        );
    }

    /// @notice Generates the merkle tree of a given proposal
    /// @param _modules List of module contracts
    /// @return hashes Combined list of leaf nodes
    function generateMerkleTree(address[] memory _modules)
        public
        view
        returns (bytes32[] memory hashes)
    {
        uint256 treeLength;
        uint256 modulesLength = _modules.length;

        unchecked {
            for (uint256 i; i < modulesLength; ++i) {
                treeLength += IModule(_modules[i]).getLeafNodes().length;
            }
        }

        uint256 counter;
        hashes = new bytes32[](treeLength);
        unchecked {
            for (uint256 i; i < modulesLength; ++i) {
                bytes32[] memory leaves = IModule(_modules[i]).getLeafNodes();
                uint256 leavesLength = leaves.length;
                for (uint256 j; j < leavesLength; ++j) {
                    hashes[counter++] = leaves[j];
                }
            }
        }
    }

    /// @notice Calculates the total amount of ether
    /// @param _scalar Scalar used for multiplication
    /// @param _lastTotalSupply Previous total fractional supply of the vault
    /// @param _totalEth Total ether balance of the proposal
    /// @param _totalFractions Total fractional balance of the proposal
    /// @return Total amount of ether
    function _calculateTotal(
        uint256 _scalar,
        uint256 _lastTotalSupply,
        uint256 _totalEth,
        uint256 _totalFractions
    ) private pure returns (uint256) {
        return
            (_totalEth * _scalar) /
            (_scalar - ((_totalFractions * _scalar) / _lastTotalSupply));
    }

    /// @notice Calculates the amount of ether contributed by the user
    /// @param _totalInEth Total amount of ether
    /// @param _lastTotalSupply Previous total fractional supply of the vault
    /// @param _userProposalEth User balance of ether for the proposal
    /// @param _userProposalFractions User balance of fractions for the proposal
    /// @return Total contribution amount
    function _calculateContribution(
        uint256 _totalInEth,
        uint256 _lastTotalSupply,
        uint256 _userProposalEth,
        uint256 _userProposalFractions
    ) private pure returns (uint256) {
        return
            _userProposalEth +
            (_userProposalFractions * _totalInEth) /
            _lastTotalSupply;
    }
}
