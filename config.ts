// import {config} from 'dotenv'
// config()
const { PRIVATE_KEY, RPC_URL } = process.env

const x_config = {
    mumbai: {
        url: RPC_URL,
        accounts: [PRIVATE_KEY]
    }
}
export default x_config;