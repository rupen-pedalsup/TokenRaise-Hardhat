const hre = require("hardhat");

async function main() {
  const tokenRaise = await hre.ethers.deployContract("TokenRaise");
  await tokenRaise.waitForDeployment();

  console.log(`TokenRaise deployed to ${tokenRaise.target}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
