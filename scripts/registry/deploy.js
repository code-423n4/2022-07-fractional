const hre = require("hardhat");
const fs = require("fs");
const contractsDir = __dirname + "/../contracts";
const rinkebyFile = fs.readFileSync(contractsDir + "/rinkeby.json");
const contractAddr = JSON.parse(rinkebyFile);

async function main() {
    const [deployer] = await ethers.getSigners();

    console.log("Deployer address:", await deployer.getAddress());
    console.log("Account balance:", (await deployer.getBalance()).toString());

    // Get all contract factories
    const VaultRegistry = await ethers.getContractFactory("VaultRegistry");

    // Deploy contracts in necessary order
    const registry = await VaultRegistry.deploy();
    await registry.deployed();

    // Log addresses of deployed contracts
    console.log("VaultRegistry address:", registry.address);
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
