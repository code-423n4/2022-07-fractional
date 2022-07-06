// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.13;

import "./TestUtil.sol";

contract VaultTest is TestUtil {
    /// =================
    /// ===== SETUP =====
    /// =================
    function setUp() public {
        setUpContract();
        vaultProxy = new Vault();
        vault = address(vaultProxy);
        alice = setUpUser(111, 1);
        alice.vaultProxy = new VaultBS(address(0), 111, vault);

        (nftReceiverSelectors, nftReceiverPlugins) = initializeNFTReceiver();

        vm.label(address(this), "VaultTest");
        vm.label(vault, "VaultProxy");
        vm.label(alice.addr, "Alice");
    }

    /// ============================
    /// ===== INITIALIZE PROXY =====
    /// ============================
    function testInit() public {
        assertEq(vaultProxy.nonce(), 0);
        assertEq(vaultProxy.owner(), address(0));

        vaultProxy.init();

        assertEq(vaultProxy.nonce(), 1);
        assertEq(vaultProxy.owner(), address(this));
    }

    function testInitRevertInvalidNonce() public {
        vaultProxy.init();
        vm.expectRevert(
            abi.encodeWithSelector(
                IVault.Initialized.selector,
                vaultProxy.owner(),
                address(this),
                vaultProxy.nonce()
            )
        );
        vaultProxy.init();
    }

    /// ==============================
    /// ===== TRANSFER OWNERSHIP =====
    /// ==============================
    function testTransferOwnership(address _newOwner) public {
        alice.vaultProxy.init();
        alice.vaultProxy.transferOwnership(_newOwner);

        assertEq(vaultProxy.owner(), _newOwner);
    }

    function testTransferOwnershipRevertNotOwner(address _newOwner) public {
        vm.assume(_newOwner != address(this));
        vaultProxy.init();
        vaultProxy.transferOwnership(_newOwner);
        vm.expectRevert(
            abi.encodeWithSelector(
                IVault.NotOwner.selector,
                _newOwner,
                address(this)
            )
        );
        vaultProxy.transferOwnership(alice.addr);
    }

    /// ===========================
    /// ===== SET MERKLE ROOT =====
    /// ===========================
    function testSetMerkleRoot() public {
        vaultProxy.init();
        vaultProxy.setMerkleRoot(merkleRoot);

        assertEq(vaultProxy.merkleRoot(), merkleRoot);
    }

    function testSetMerkleRootRevertNotOwner() public {
        vaultProxy.init();
        vm.expectRevert(
            abi.encodeWithSelector(
                IVault.NotOwner.selector,
                address(this),
                alice.addr
            )
        );
        alice.vaultProxy.setMerkleRoot(merkleRoot);
    }

    /// =========================
    /// ===== RECEIVE TOKEN =====
    /// =========================
    function testReceiveEther() public {
        vaultProxy.init();
        payable(vault).transfer(1 ether);

        assertEq(vault.balance, 1 ether);
    }

    function testReceiveERC721() public {
        vaultProxy.init();
        vaultProxy.install(nftReceiverSelectors, nftReceiverPlugins);
        MockERC721(erc721).mint(vault, 2);

        assertEq(IERC721(erc721).balanceOf(vault), 1);
    }

    function testReceiveERC1155() public {
        vaultProxy.init();
        vaultProxy.install(nftReceiverSelectors, nftReceiverPlugins);
        mintERC1155(vault, 1);

        assertEq(IERC1155(erc1155).balanceOf(vault, 1), 10);
    }

    /// ===================
    /// ===== EXECUTE =====
    /// ===================
    function testExecute() public {
        bytes memory data = setUpExecute(alice);
        vaultProxy.execute(address(transferTarget), data, erc721TransferProof);

        assertEq(IERC721(erc721).balanceOf(vault), 0);
        assertEq(IERC721(erc721).balanceOf(alice.addr), 1);
    }

    function testExecuteRevert() public {
        bytes memory data = setUpExecute(alice);
        vm.expectRevert(
            abi.encodeWithSelector(IVault.ExecutionReverted.selector)
        );
        vaultProxy.execute(address(supplyTarget), data, erc721TransferProof);
    }

    function testExecuteRevertNotAuthorized() public {
        bytes memory data = setUpExecute(alice);
        vm.expectRevert(
            abi.encodeWithSelector(
                IVault.NotAuthorized.selector,
                alice.addr,
                address(transferTarget),
                transferTarget.ERC721TransferFrom.selector
            )
        );
        alice.vaultProxy.execute(
            address(transferTarget),
            data,
            erc721TransferProof
        );
    }

    function testExecuteRevertTargetInvalid() public {
        bytes memory data = setUpExecute(alice);
        vm.expectRevert(
            abi.encodeWithSelector(IVault.TargetInvalid.selector, alice.addr)
        );
        vaultProxy.execute(alice.addr, data, erc721TransferProof);
    }

    function testExecuteRevertNotOwner() public {
        vaultProxy.init();
        TargetContract targetContract = new TargetContract();
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = keccak256(
            abi.encode(
                alice.addr,
                address(targetContract),
                TargetContract.transferOwnership.selector
            )
        );
        vaultProxy.setMerkleRoot(proof[0]);
        bytes memory data = abi.encodeCall(
            targetContract.transferOwnership,
            ()
        );
        vm.expectRevert(
            abi.encodeWithSelector(
                IVault.NotOwner.selector,
                address(this),
                address(vaultProxy)
            )
        );
        vaultProxy.execute(address(targetContract), data, proof);
    }

    function testExecuteRevertOwnerChanged() public {
        vaultProxy.init();
        TargetContract targetContract = new TargetContract();
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = keccak256(
            abi.encode(
                alice.addr,
                address(targetContract),
                TargetContract.changeOwner.selector
            )
        );
        vaultProxy.setMerkleRoot(proof[0]);
        bytes memory data = abi.encodeCall(
            targetContract.changeOwner,
            (alice.addr)
        );
        vm.expectRevert(
            abi.encodeWithSelector(
                IVault.OwnerChanged.selector,
                address(this),
                alice.addr
            )
        );
        vaultProxy.execute(address(targetContract), data, proof);
    }
}

contract TargetContract {
    address public owner;

    function changeOwner(address _owner) public {
        owner = _owner;
    }

    function transferOwnership() external {
        Vault(payable(address(this))).transferOwnership(address(1));
    }
}
