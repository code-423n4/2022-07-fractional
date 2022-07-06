// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.13;

import "./TestUtil.sol";

contract MigrationTest is TestUtil {
    /// =================
    /// ===== SETUP =====
    /// =================
    function setUp() public {
        setUpContract();
        alice = setUpUser(111, 1);
        bob = setUpUser(222, 2);

        vm.label(address(this), "MigrateTest");
        vm.label(alice.addr, "Alice");
        vm.label(bob.addr, "Bob");
    }

    function testProposal() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();
        //Migrate to a vault with no permissions (just to test out migration)
        address[] memory modules = new address[](1);
        modules[0] = address(mockModule);
        bob.migrationModule.propose(
            vault,
            modules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
    }

    function testProposalNotVault() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();
        //Migrate to a vault with no permissions (just to test out migration)
        address[] memory modules = new address[](1);
        modules[0] = address(mockModule);
        vm.expectRevert(
            abi.encodeWithSelector(IMigration.NotVault.selector, address(0))
        );
        bob.migrationModule.propose(
            address(0),
            modules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
    }

    function testJoin() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();
        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory modules = new address[](1);
        modules[0] = address(mockModule);
        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            modules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 0.5 ether}(vault, 1, HALF_SUPPLY);
    }

    function testJoinNotVault() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();
        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory modules = new address[](1);
        modules[0] = address(mockModule);
        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            modules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        vm.expectRevert(
            abi.encodeWithSelector(IMigration.NotVault.selector, address(0))
        );
        bob.migrationModule.join{value: 0.5 ether}(address(0), 1, HALF_SUPPLY);
    }

    function testLeave() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();
        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory modules = new address[](1);
        modules[0] = address(mockModule);
        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            modules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 0.5 ether}(vault, 1, HALF_SUPPLY);
        // Bob leaves the proposal
        bob.migrationModule.leave(vault, 1);
    }

    function testLeaveNotVault() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();
        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory modules = new address[](1);
        modules[0] = address(mockModule);
        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            modules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 0.5 ether}(vault, 1, HALF_SUPPLY);
        // Bob leaves the proposal
        vm.expectRevert(
            abi.encodeWithSelector(IMigration.NotVault.selector, address(0))
        );
        bob.migrationModule.leave(address(0), 1);
    }

    function testCommit() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();

        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory modules = new address[](1);
        modules[0] = address(mockModule);
        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            modules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 1 ether}(vault, 1, HALF_SUPPLY);

        vm.warp(proposalPeriod + 1);
        // bob calls commit to kickoff the buyout process
        bool started = bob.migrationModule.commit(vault, 1);
        assertTrue(started);
    }

    function testCommitNotVault() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();

        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory modules = new address[](1);
        modules[0] = address(mockModule);
        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            modules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 1 ether}(vault, 1, HALF_SUPPLY);

        vm.warp(proposalPeriod + 1);
        // bob calls commit to kickoff the buyout process
        vm.expectRevert(
            abi.encodeWithSelector(IMigration.NotVault.selector, address(0))
        );
        bob.migrationModule.commit(address(0), 1);
    }

    function testCommitProposalOver() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();

        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory modules = new address[](1);
        modules[0] = address(mockModule);
        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            modules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 1 ether}(vault, 1, HALF_SUPPLY);

        vm.warp(proposalPeriod * 10);
        // bob calls commit to kickoff the buyout process
        vm.expectRevert(
            abi.encodeWithSelector(IMigration.ProposalOver.selector)
        );
        bob.migrationModule.commit(vault, 1);
    }

    function testSettle() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();
        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory newModules = new address[](2);

        newModules[0] = migration;
        newModules[1] = modules[1];

        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            newModules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 1 ether}(vault, 1, HALF_SUPPLY);
        // Alice joins the proposal
        alice.migrationModule.join{value: 1 ether}(vault, 1, 1000);

        vm.warp(proposalPeriod + 1);
        // bob calls commit to kickoff the buyout process
        bool started = bob.migrationModule.commit(vault, 1);
        assertTrue(started);

        vm.warp(proposalPeriod + rejectionPeriod + 2);
        bob.buyoutModule.end(vault, burnProof);

        bob.migrationModule.settleVault(vault, 1);
        bob.migrationModule.settleFractions(vault, 1, mintProof);
    }

    function testSettleVaultUnsuccessfulMigration() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();

        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory newModules = new address[](2);

        newModules[0] = migration;
        newModules[1] = modules[1];

        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            newModules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 1 ether}(vault, 1, 1000);

        vm.warp(proposalPeriod + 1);
        // bob calls commit to kickoff the buyout process
        bool started = bob.migrationModule.commit(vault, 1);
        assertTrue(started);

        vm.warp(proposalPeriod + rejectionPeriod + 2);
        bob.buyoutModule.end(vault, burnProof);

        vm.expectRevert(
            abi.encodeWithSelector(IMigration.UnsuccessfulMigration.selector)
        );
        bob.migrationModule.settleVault(vault, 1);
    }

    function testSettleVaultNewVaultAlreadyDeployed() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();

        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory newModules = new address[](2);

        newModules[0] = migration;
        newModules[1] = modules[1];

        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            newModules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 1 ether}(vault, 1, HALF_SUPPLY);
        // Alice joins the proposal
        alice.migrationModule.join{value: 1 ether}(vault, 1, 1000);

        vm.warp(proposalPeriod + 1);
        // bob calls commit to kickoff the buyout process
        bool started = bob.migrationModule.commit(vault, 1);
        assertTrue(started);

        vm.warp(proposalPeriod + rejectionPeriod + 2);
        bob.buyoutModule.end(vault, burnProof);

        bob.migrationModule.settleVault(vault, 1);
        (, , , , address newVault, , , , ) = migrationModule.migrationInfo(
            vault,
            1
        );
        vm.expectRevert(
            abi.encodeWithSelector(
                IMigration.NewVaultAlreadyDeployed.selector,
                newVault
            )
        );
        bob.migrationModule.settleVault(vault, 1);
    }

    function testSettleFractionsUnsuccessfulMigration() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();

        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory newModules = new address[](2);

        newModules[0] = migration;
        newModules[1] = modules[1];

        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            newModules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 1 ether}(vault, 1, 1000);

        vm.warp(proposalPeriod + 1);
        // bob calls commit to kickoff the buyout process
        bool started = bob.migrationModule.commit(vault, 1);
        assertTrue(started);

        vm.warp(proposalPeriod + rejectionPeriod + 2);
        bob.buyoutModule.end(vault, burnProof);

        vm.expectRevert(
            abi.encodeWithSelector(IMigration.UnsuccessfulMigration.selector)
        );
        bob.migrationModule.settleFractions(vault, 1, mintProof);
    }

    function testSettleFractionsNoVaultToMigrateTo() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();

        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory newModules = new address[](2);

        newModules[0] = migration;
        newModules[1] = modules[1];

        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            newModules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 1 ether}(vault, 1, HALF_SUPPLY);
        // Alice joins the proposal
        alice.migrationModule.join{value: 1 ether}(vault, 1, 1000);

        vm.warp(proposalPeriod + 1);
        // bob calls commit to kickoff the buyout process
        bool started = bob.migrationModule.commit(vault, 1);
        assertTrue(started);

        vm.warp(proposalPeriod + rejectionPeriod + 2);
        bob.buyoutModule.end(vault, burnProof);

        vm.expectRevert(
            abi.encodeWithSelector(IMigration.NoVaultToMigrateTo.selector)
        );
        bob.migrationModule.settleFractions(vault, 1, mintProof);
    }

    function testSettleFractionsAlreadyMinted() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();

        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory newModules = new address[](2);

        newModules[0] = migration;
        newModules[1] = modules[1];

        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            newModules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 1 ether}(vault, 1, HALF_SUPPLY);
        // Alice joins the proposal
        alice.migrationModule.join{value: 1 ether}(vault, 1, 1000);

        vm.warp(proposalPeriod + 1);
        // bob calls commit to kickoff the buyout process
        bool started = bob.migrationModule.commit(vault, 1);
        assertTrue(started);

        vm.warp(proposalPeriod + rejectionPeriod + 2);
        bob.buyoutModule.end(vault, burnProof);

        bob.migrationModule.settleVault(vault, 1);
        bob.migrationModule.settleFractions(vault, 1, mintProof);
        vm.expectRevert(
            abi.encodeWithSelector(
                IMigration.NewFractionsAlreadyMinted.selector
            )
        );
        bob.migrationModule.settleFractions(vault, 1, mintProof);
    }

    function testWithdrawERC20() public {
        testSettle();
        MockERC20(erc20).mint(vault, 10);

        bob.migrationModule.migrateVaultERC20(
            vault,
            1,
            erc20,
            10,
            erc20TransferProof
        );
    }

    function testWithdrawERC20NotVault() public {
        testSettle();
        MockERC20(erc20).mint(vault, 10);

        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.NotVault.selector, address(0))
        );
        bob.migrationModule.migrateVaultERC20(
            address(0),
            1,
            erc20,
            10,
            erc20TransferProof
        );
    }

    function testWithdrawERC20UnsuccesfulBuyout() public {
        testSettleVaultUnsuccessfulMigration();
        MockERC20(erc20).mint(vault, 10);

        vm.stopPrank();
        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.InvalidState.selector, 2, 0)
        );
        bob.migrationModule.migrateVaultERC20(
            vault,
            1,
            erc20,
            10,
            erc20TransferProof
        );
    }

    function testWithdrawERC721() public {
        testSettle();

        bob.migrationModule.migrateVaultERC721(
            vault,
            1,
            erc721,
            1,
            erc721TransferProof
        );
    }

    function testWithdrawERC721NotVault() public {
        testSettle();

        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.NotVault.selector, address(0))
        );
        bob.migrationModule.migrateVaultERC721(
            address(0),
            1,
            erc721,
            1,
            erc721TransferProof
        );
    }

    function testWithdrawERC721UnsuccesfulBuyout() public {
        testSettleVaultUnsuccessfulMigration();

        vm.stopPrank();
        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.InvalidState.selector, 2, 0)
        );
        bob.migrationModule.migrateVaultERC721(
            vault,
            1,
            erc721,
            1,
            erc721TransferProof
        );
    }

    function testWithdrawERC1155() public {
        testSettle();
        // mint some ERC1155 to the vault
        MockERC1155(erc1155).mint(vault, 1, 10, "");

        bob.migrationModule.migrateVaultERC1155(
            vault,
            1,
            erc1155,
            1,
            10,
            erc1155TransferProof
        );
    }

    function testWithdrawERC1155NotVault() public {
        testSettle();
        // mint some ERC1155 to the vault
        MockERC1155(erc1155).mint(vault, 1, 10, "");

        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.NotVault.selector, address(0))
        );
        bob.migrationModule.migrateVaultERC1155(
            address(0),
            1,
            erc1155,
            1,
            10,
            erc1155TransferProof
        );
    }

    function testWithdrawERC1155UnsuccesfulBuyout() public {
        testSettleVaultUnsuccessfulMigration();
        // mint some ERC1155 to the vault
        MockERC1155(erc1155).mint(vault, 1, 10, "");

        vm.stopPrank();
        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.InvalidState.selector, 2, 0)
        );
        bob.migrationModule.migrateVaultERC1155(
            vault,
            1,
            erc1155,
            1,
            10,
            erc1155TransferProof
        );
    }

    function testbBatchWithdrawERC1155() public {
        testSettle();
        // mint some ERC1155 to the vault
        MockERC1155(erc1155).mint(vault, 1, 10, "");
        MockERC1155(erc1155).mint(vault, 2, 10, "");

        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 2;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10;
        amounts[1] = 10;

        bob.migrationModule.batchMigrateVaultERC1155(
            vault,
            1,
            erc1155,
            ids,
            amounts,
            erc1155BatchTransferProof
        );
    }

    function testBatchWithdrawERC1155NotVault() public {
        testSettle();
        // mint some ERC1155 to the vault
        MockERC1155(erc1155).mint(vault, 1, 10, "");
        MockERC1155(erc1155).mint(vault, 2, 10, "");

        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 2;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10;
        amounts[1] = 10;

        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.NotVault.selector, address(0))
        );
        bob.migrationModule.batchMigrateVaultERC1155(
            address(0),
            1,
            erc1155,
            ids,
            amounts,
            erc1155BatchTransferProof
        );
    }

    function testBatchWithdrawERC1155UnsuccesfulBuyout() public {
        testSettleVaultUnsuccessfulMigration();
        // mint some ERC1155 to the vault
        MockERC1155(erc1155).mint(vault, 1, 10, "");
        MockERC1155(erc1155).mint(vault, 2, 10, "");

        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 2;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10;
        amounts[1] = 10;

        vm.stopPrank();
        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.InvalidState.selector, 2, 0)
        );
        bob.migrationModule.batchMigrateVaultERC1155(
            vault,
            1,
            erc1155,
            ids,
            amounts,
            erc1155BatchTransferProof
        );
    }

    function testWithdrawItems() public {
        testSettle();
        // mint some ERC1155 to the vault
        MockERC1155(erc1155).mint(vault, 1, 10, "");
        MockERC1155(erc1155).mint(vault, 2, 10, "");
        // mint some ERC20 to the vault
        MockERC20(erc20).mint(vault, 10);

        // Migrate
        // migrateVaultERC20()
        bytes[] memory data = new bytes[](3);
        data[0] = initializeERC721Migration(vault, 1, 1);
        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 2;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10;
        amounts[1] = 10;
        data[1] = initializeBatchMigrationERC1155(vault, 1, ids, amounts);
        data[2] = initializeERC20Migration(vault, 1, 10);

        bob.migrationModule.multicall(data);
    }

    function testWithdrawItemsNotVault() public {
        testSettle();
        // mint some ERC1155 to the vault
        MockERC1155(erc1155).mint(vault, 1, 10, "");
        MockERC1155(erc1155).mint(vault, 2, 10, "");
        // mint some ERC20 to the vault
        MockERC20(erc20).mint(vault, 10);

        // migrateVaultERC20()
        bytes[] memory data = new bytes[](3);
        data[0] = initializeERC721Migration(address(0), 1, 1);
        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 2;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10;
        amounts[1] = 10;
        data[1] = initializeBatchMigrationERC1155(address(0), 1, ids, amounts);
        data[2] = initializeERC20Migration(address(0), 1, 10);

        vm.expectRevert(
            abi.encodeWithSelector(IMigration.NotVault.selector, address(0))
        );
        bob.migrationModule.multicall(data);
    }

    function testWithdrawItemsUnsuccesfulBuyout() public {
        testSettleVaultUnsuccessfulMigration();
        // mint some ERC1155 to the vault
        MockERC1155(erc1155).mint(vault, 1, 10, "");
        MockERC1155(erc1155).mint(vault, 2, 10, "");
        // mint some ERC20 to the vault
        MockERC20(erc20).mint(vault, 10);

        // migrateVaultERC20()
        bytes[] memory data = new bytes[](3);
        data[0] = initializeERC721Migration(vault, 1, 1);
        uint256[] memory ids = new uint256[](2);
        ids[0] = 1;
        ids[1] = 2;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 10;
        amounts[1] = 10;
        data[1] = initializeBatchMigrationERC1155(vault, 1, ids, amounts);
        data[2] = initializeERC20Migration(vault, 1, 10);

        vm.stopPrank();
        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.InvalidState.selector, 2, 0)
        );
        bob.migrationModule.multicall(data);
    }

    function testMigrateFractions() public {
        testSettle();
        (, , , , address newVault, , , , ) = migrationModule.migrationInfo(
            vault,
            1
        );
        (address newToken, uint256 id) = registry.vaultToToken(newVault);

        assertEq(getFractionBalance(alice.addr), 4000);
        alice.migrationModule.migrateFractions(vault, 1);
        assertEq(IERC1155(newToken).balanceOf(alice.addr, id), 6000);

        assertEq(getFractionBalance(bob.addr), 0);
        bob.migrationModule.migrateFractions(vault, 1);
        assertEq(IERC1155(newToken).balanceOf(bob.addr, id), 14000);
    }

    function testMigrateFractionsNotVault() public {
        testSettle();

        assertEq(getFractionBalance(alice.addr), 4000);
        vm.expectRevert(
            abi.encodeWithSelector(IMigration.NotVault.selector, address(0))
        );
        alice.migrationModule.migrateFractions(address(0), 1);

        vm.stopPrank();

        assertEq(getFractionBalance(bob.addr), 0);
        vm.expectRevert(
            abi.encodeWithSelector(IMigration.NotVault.selector, address(0))
        );
        bob.migrationModule.migrateFractions(address(0), 1);
    }

    function testMigrateFractionsUnsuccesfulBuyout() public {
        testSettleVaultUnsuccessfulMigration();

        vm.stopPrank();

        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.InvalidState.selector, 2, 0)
        );
        alice.migrationModule.migrateFractions(vault, 1);

        vm.stopPrank();

        vm.expectRevert(
            abi.encodeWithSelector(IBuyout.InvalidState.selector, 2, 0)
        );
        bob.migrationModule.migrateFractions(vault, 1);
    }

    function testWithdrawContribution() public {
        testSettleVaultUnsuccessfulMigration();

        vm.stopPrank();

        bob.migrationModule.withdrawContribution(vault, 1);
    }

    function testWithdrawContributionNotVault() public {
        initializeMigration(alice, bob, TOTAL_SUPPLY, HALF_SUPPLY, true);
        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();

        // Migrate to a vault with no permissions (just to test out migration)
        address[] memory newModules = new address[](3);

        newModules[0] = migration;
        newModules[1] = modules[1];

        // Bob makes the proposal
        bob.migrationModule.propose(
            vault,
            newModules,
            nftReceiverPlugins,
            nftReceiverSelectors,
            TOTAL_SUPPLY * 2,
            1 ether
        );
        // Bob joins the proposal
        bob.migrationModule.join{value: 1 ether}(vault, 1, HALF_SUPPLY);

        vm.warp(proposalPeriod + 1);
        // bob calls commit to kickoff the buyout process
        bool started = bob.migrationModule.commit(vault, 1);
        assertTrue(started);

        vm.warp(proposalPeriod + rejectionPeriod + 2);
        bob.buyoutModule.end(vault, burnProof);

        vm.expectRevert(
            abi.encodeWithSelector(IMigration.NotVault.selector, address(0))
        );
        bob.migrationModule.withdrawContribution(address(0), 1);
    }

    function testWithdrawContributionNothingToWithdraw() public {
        testSettle();

        vm.stopPrank();

        vm.expectRevert(
            abi.encodeWithSelector(IMigration.NoContributionToWithdraw.selector)
        );
        bob.migrationModule.withdrawContribution(vault, 1);
    }
}
