import { expect } from "chai";
import { ethers } from "hardhat";
import { CrytpixMarketplace } from "../typechain-types";
// import { CrytpixMarketplace } from "../typechain-types";
// :TODO: write full test 

describe("CrytpixMarketplace", function () {
    let CrytpixMarketplace: CrytpixMarketplace;
    let owner;
    let otherAccount;
    const NAME = "CrytpixMarketplace";

    before(async function () {
        const CrytpixMarketplaceContract = await ethers.getContractFactory('CrytpixMarketplace');

        [owner, otherAccount] = await ethers.getSigners();
        CrytpixMarketplace = await CrytpixMarketplaceContract.deploy();
        await CrytpixMarketplace.deployed();
    });

    describe("Deployment", async function () {
        it("Should have a name", async function () {
            expect(await CrytpixMarketplace.name()).to.equal(NAME);
        });
    });
});