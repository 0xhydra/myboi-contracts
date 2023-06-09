import { Contract, ContractFactory } from "ethers";
import { ethers, run, upgrades } from "hardhat";

async function main(): Promise<void> {
  const Factory: ContractFactory = await ethers.getContractFactory("");
  const contract: Contract = await upgrades.upgradeProxy("", Factory, {
    kind: "uups",
  });
  await contract.deployed();
  console.log("Factory upgraded to : ", await upgrades.erc1967.getImplementationAddress(contract.address));

  await run(`verify:verify`, {
    address: contract.address,
  });
}

main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
