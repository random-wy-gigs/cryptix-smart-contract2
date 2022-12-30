import * as dotenv from 'dotenv'
dotenv.config();
import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";
const { PRIVATE_KEY, RPC_URL } = process.env
const config: HardhatUserConfig = {
  // solidity: "0.8.17",
  solidity: {
    version: "0.8.17",
    settings: {
      optimizer: {
        enabled: true,
        runs: 200
      }
    }
  },
  defaultNetwork: 'mumbai',
  networks: {
    mumbai: {
      url: RPC_URL,
      accounts: [PRIVATE_KEY] as string[]
    }
  },
  paths: {
    sources: "./contracts",
    tests: './test',
    cache: './cache',
    artifacts: './artifacts'
  },
  mocha: {
    timeout: 20000
  }
};

export default config;
