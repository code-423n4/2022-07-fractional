// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.13;

import "./TestUtil.sol";

contract VaultFactoryTest is TestUtil {
    uint256 seed_1;
    uint256 seed_2;
    uint256 seed_3;
    address predicted_1;
    address predicted_2;
    address actual_1;
    address actual_2;

    function setUp() public {
        setUpContract();
    }

    function checkNextCreate2Helper(address who)
        public
        view
        returns (uint256, address)
    {
        bytes32 seed = IVaultFactory(factory).getNextSeed(who);
        return (uint256(seed), IVaultFactory(factory).getNextAddress(who));
    }

    function testDeploy() public {
        factory = registry.factory();
        (seed_1, predicted_1) = checkNextCreate2Helper(tx.origin);
        actual_1 = IVaultFactory(factory).deploy();
        (seed_2, ) = checkNextCreate2Helper(tx.origin);
        assertEq(seed_2, seed_1 + 1);
        assertEq(predicted_1, actual_1);
    }

    function testDeploy(address who) public {
        factory = registry.factory();
        (seed_1, predicted_1) = checkNextCreate2Helper(who);
        vm.startPrank(who, who);
        actual_1 = IVaultFactory(factory).deploy();
        vm.stopPrank();
        (seed_2, predicted_2) = checkNextCreate2Helper(who);
        vm.startPrank(who, who);
        actual_2 = IVaultFactory(factory).deploy();
        vm.stopPrank();

        (seed_3, ) = checkNextCreate2Helper(who);
        assertEq(seed_2, seed_1 + 1);
        assertEq(predicted_1, actual_1);
        assertEq(seed_3, seed_2 + 1);
        assertEq(predicted_2, actual_2);
    }

    function testDeployFor(address who) public {
        factory = registry.factory();
        (seed_1, predicted_1) = checkNextCreate2Helper(who);
        vm.startPrank(who, who);
        actual_1 = IVaultFactory(factory).deployFor(address(this));
        vm.stopPrank();
        (seed_2, predicted_2) = checkNextCreate2Helper(who);
        vm.startPrank(who, who);
        actual_2 = IVaultFactory(factory).deployFor(address(this));
        vm.stopPrank();

        (seed_3, ) = checkNextCreate2Helper(who);
        assertEq(seed_2, seed_1 + 1);
        assertEq(predicted_1, actual_1);
        assertEq(seed_3, seed_2 + 1);
        assertEq(predicted_2, actual_2);
    }
}
