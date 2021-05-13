const hre = require('hardhat');
const ethers = hre.ethers;

async function main() {
    const allowanceContract = await ethers.getContractFactory("Allowance");
    const allowanceContractInstance = await allowanceContract.deploy('John Doe', 'The Doe Family');

    await allowanceContractInstance.deployed();

    console.log(`Allowance Contract Deployed to ${allowanceContractInstance.address}`);
}

main()
    // process.exit status code 0 means shut down the process
    // once there are no more async operations running
    .then( () => process.exit(0))
    .catch(error => {
        console.error(error);
        // process status code 1 means shut down the process regardless
        process.exit(1);
    });