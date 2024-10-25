import hardhat from 'hardhat';
const { ethers } = hardhat;

async function main() {

const ProposalContractFactory = await ethers.getContractFactory("ProposalContractFactory");
const proposalContractFactory = await ProposalContractFactory.deploy();

const deployedContract = await proposalContractFactory.waitForDeployment();

  console.log('Contract Deployed at ' + deployedContract.target);

}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});