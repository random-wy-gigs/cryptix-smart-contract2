import { ethers } from "hardhat";

async function main() {
  const CrytpixMarketplaceContract = await ethers.getContractFactory('CrytpixMarketplace');
  const CrytpixMarketplace = await CrytpixMarketplaceContract.deploy();

  await CrytpixMarketplace.deployed();
  console.log(`CrytpixMarketplace deployed to ${CrytpixMarketplace.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
