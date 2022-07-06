const hre = require("hardhat");
const fs = require("fs");
const contractsDir = __dirname + "/contracts";

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deployer address:", await deployer.getAddress());
    console.log("Account balance:", (await deployer.getBalance()).toString());

    // Get all contract factories
    const BaseVault = await ethers.getContractFactory("BaseVault");
    const Buyout = await ethers.getContractFactory("Buyout");
    const Migration = await ethers.getContractFactory("Migration");
    const Supply = await ethers.getContractFactory("Supply");
    const Transfer = await ethers.getContractFactory("Transfer");
    const VaultFactory = await ethers.getContractFactory("VaultFactory");
    const VaultRegistry = await ethers.getContractFactory("VaultRegistry");

    // Deploy contracts in necessary order
    const factory = await VaultFactory.deploy();
    await factory.deployed();
    const vault = await factory.implementation();

    const registry = await VaultRegistry.deploy();
    await registry.deployed();
    const ferc1155 = await registry.fNFTImplementation();

    const supply = await Supply.deploy(registry.address);
    await supply.deployed();

    const transfer = await Transfer.deploy();
    await transfer.deployed();

    const buyout = await Buyout.deploy(registry.address, supply.address, transfer.address);
    await buyout.deployed();

    const baseVault = await BaseVault.deploy(registry.address, supply.address);
    await baseVault.deployed();

    const migration = await Migration.deploy(buyout.address, registry.address, supply.address);
    await migration.deployed();

    // Log addresses of deployed contracts
    console.log("BaseVault address:", baseVault.address);
    console.log("Buyout address:", buyout.address);
    console.log("FERC1155 Address:", ferc1155);
    console.log("Migration address:", migration.address);
    console.log("Supply address:", supply.address);
    console.log("Transfer address:", transfer.address);
    console.log("Vault Address:", vault);
    console.log("VaultFactory address:", factory.address);
    console.log("VaultRegistry address:", registry.address);

    const contracts = {
        BaseVault: baseVault.address,
        Buyout: buyout.address,
        FERC1155: ferc1155,
        Migration: migration.address,
        Supply: supply.address,
        Transfer: transfer.address,
        Vault: vault,
        VaultFactory: factory.address,
        VaultRegistry: registry.address
    };

    saveAddress(contracts);
}

function saveAddress(contracts) {
    if (!fs.existsSync(contractsDir)) {
        fs.mkdirSync(contractsDir);
    }

    fs.writeFileSync(
        contractsDir + "/rinkeby.json",
        JSON.stringify({
            BaseVault: contracts["BaseVault"],
            Buyout: contracts["Buyout"],
            FERC1155: contracts["FERC1155"],
            Migration: contracts["Migration"],
            Supply: contracts["Supply"],
            Transfer: contracts["Transfer"],
            Vault: contracts["Vault"],
            VaultFactory: contracts["VaultFactory"],
            VaultRegistry: contracts["VaultRegistry"]
        }, undefined, 2)
    );
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
