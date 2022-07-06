const fs = require("fs");
const rinkebyFile = fs.readFileSync(__dirname + "/../contracts/rinkeby.json");
const contractAddr = JSON.parse(rinkebyFile);

async function main() {
    await hre.run("verify:verify", {
        address: contractAddr.VaultRegistry,
        constructorArguments: []
    });

    await hre.run("verify:verify", {
        address: contractAddr.FERC1155,
        constructorArguments: [],
    });
}

main()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error);
        process.exit(1);
    });
