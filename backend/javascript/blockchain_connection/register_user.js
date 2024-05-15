// const Web3 = require('web3').default;
// // const web3 = new Web3('http://localhost:7545');
// const fs = require('fs');
// require('dotenv').config
// const path = require('path');
// const contractAddress = process.env.Contract_Address_UserRepository; // replace with your contract address
// // const abi = JSON.parse(fs.readFileSync(path.resolve(__dirname,'..','..','blockchain','build','constracts', 'UserRegistry.json'))).abi;

// const abi = JSON.parse(fs.readFileSync('C:\\Users\\Yousuf\\Desktop\\etherium_tutorial\\fyp_1\\backend\\blockchain\\build\\contracts\\UserRegistry.json')).abi;
// // Update Web3 provider URL to Alchemy's Sepolia endpoint
// const web3 = new Web3('https://eth-sepolia.g.alchemy.com/v2/rdrCTIqWya92zI_rnEeGWXLwBe-re2by');


// // Specify the wallet address to use
// const walletAddress = '0x25DAb8a88dAe21fb364B40a98107163dc316cB61';

// // Load the private key of the wallet (DO NOT hardcode in production, use environment variables or secure vault)
// const privateKey = process.env.WALLET_PRIVATE_KEY;


// const contract = new web3.eth.Contract(abi, contractAddress);


// async function registerUser() {
//     try {

        

//         // Send the transaction to register the user
//         const tx = await contract.methods.register(wallet.address).send({ from: walletAddress});

//         console.log('Transaction hash:', tx.transactionHash);
//         // getRegisteredUsers();
//         return wallet;
//     } catch (error) {
//         console.error('Error registering user:', error);
//     }
// }
// async function getRegisteredUsers() {
//   const userCount = await contract.methods.getUserCount().call();
//   for (let i = 0; i < userCount; i++) {
//       const userAddress = await contract.methods.userAddresses(i).call();
//       const isRegistered = await contract.methods.registeredUsers(userAddress).call();
//       console.log('User address:', userAddress, 'Is registered:', isRegistered);
//   }
// }

// module.exports = registerUser;


const Web3 = require('web3').default;
const fs = require('fs');
const path = require('path');
require('dotenv').config();  // Make sure to call this to load the environment variables

// Update Web3 provider URL to Alchemy's Sepolia endpoint
const web3 = new Web3('https://eth-sepolia.g.alchemy.com/v2/rdrCTIqWya92zI_rnEeGWXLwBe-re2by');

// Load contract address and private key from environment variables
const contractAddress = process.env.Contract_Address_UserRepository;
const privateKey = process.env.WALLET_PRIVATE_KEY;

// Load the contract ABI
const abi = JSON.parse(fs.readFileSync(path.resolve(__dirname, 'C:\\Users\\Yousuf\\Desktop\\etherium_tutorial\\fyp_1\\backend\\blockchain\\build\\contracts\\UserRegistry.json'))).abi;

// Initialize the contract
const contract = new web3.eth.Contract(abi, contractAddress);

// Specify the wallet address to use
const walletAddress = '0x25DAb8a88dAe21fb364B40a98107163dc316cB61';

async function registerUser() {
    try {
        const wallet = web3.eth.accounts.create();
        // Get the current transaction nonce for the wallet address
        const nonce = await web3.eth.getTransactionCount(walletAddress, 'pending');

        // Estimate the gas required for the transaction
        const gasEstimate = await contract.methods.register(wallet.address).estimateGas({ from: walletAddress });
        const gasLimit = Math.ceil(Number(gasEstimate) * 1.1); // Adjust the buffer factor as needed

        // Fetch the current gas price
        const gasPrice = await web3.eth.getGasPrice();

        // Create the transaction object
        const tx = {
            from: walletAddress,
            to: contractAddress,
            gas: Number(gasLimit),
            gasPrice: Number(gasPrice),
            nonce: nonce,
            data: contract.methods.register(wallet.address).encodeABI()
        };

        // Sign the transaction
        const signedTx = await web3.eth.accounts.signTransaction(tx, privateKey);

        // Send the transaction
        const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);

        console.log('Transaction hash:', receipt.transactionHash);
        return wallet;
    } catch (error) {
        console.error('Error registering user:', error);
        throw error;
    }
}

// async function getRegisteredUsers() {
//     try {
//         const userCount = await contract.methods.getUserCount().call();
//         for (let i = 0; i < userCount; i++) {
//             const userAddress = await contract.methods.userAddresses(i).call();
//             const isRegistered = await contract.methods.registeredUsers(userAddress).call();
//             console.log('User address:', userAddress, 'Is registered:', isRegistered);
//         }
//     } catch (error) {
//         console.error('Error retrieving registered users:', error);
//         throw error;
//     }
// }

module.exports =registerUser ;
