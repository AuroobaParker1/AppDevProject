// const Web3 = require('web3').default;
// const web3 = new Web3('http://localhost:7545');
// const fs = require('fs');
// const path = require('path');
// const contractAddress = process.env.Contract_Address_MedicalRecord; // replace with your contract address
// const abi = JSON.parse(fs.readFileSync('C:\\Users\\Yousuf\\Desktop\\etherium_tutorial\\fyp_1\\backend\\blockchain\\build\\contracts\\MedicalRecord.json')).abi;

// const contract = new web3.eth.Contract(abi, contractAddress);

// async function uploadRecordToBlockchain(fileHash, wallet_address) {
//   try {
//     const accounts = await web3.eth.getAccounts();
    
//     // Estimate the gas required for the transaction
//     const gasEstimate = await contract.methods.storeFileHash(fileHash, wallet_address).estimateGas({ from: accounts[0] });
    
//     // Send the transaction to upload record with a higher gas limit
//     const tx = await contract.methods.storeFileHash(fileHash, wallet_address).send({ from: accounts[0], gas: gasEstimate });
//     return tx;

//   } catch (error) {
//     console.error('Error uploading record to blockchain:', error);
//     throw error;
//   }
// }


// async  function getRecordsFromBlockchain(wallet_address) {
//   try {
//     // Call the getRecords function to retrieve records
//     const records = await contract.methods.getRecords(wallet_address).call();
//     return records;

//   } catch (error) {
//     console.error('Error retrieving records from blockchain:', error);
//     throw error;
//   }
// }

// module.exports = { uploadRecordToBlockchain,getRecordsFromBlockchain };

// // 81bc76cff0cd87a172a57cb15109113fa7dffe19f7a1a3c409d133cc9d57a549

const Web3 = require('web3').default;
const fs = require('fs');
const path = require('path');

// Update Web3 provider URL to Alchemy's Sepolia endpoint
const web3 = new Web3('https://eth-sepolia.g.alchemy.com/v2/rdrCTIqWya92zI_rnEeGWXLwBe-re2by');

// Replace with your actual contract address once you retrieve it
const contractAddress = process.env.Contract_Address_MedicalRecord; 
const abi = JSON.parse(fs.readFileSync('C:\\Users\\Yousuf\\Desktop\\etherium_tutorial\\fyp_1\\backend\\blockchain\\build\\contracts\\MedicalRecord.json')).abi;

const contract = new web3.eth.Contract(abi, contractAddress);

// Specify the wallet address to use
const walletAddress = '0x25DAb8a88dAe21fb364B40a98107163dc316cB61';

// Load the private key of the wallet (DO NOT hardcode in production, use environment variables or secure vault)
const privateKey = process.env.WALLET_PRIVATE_KEY;

async function uploadRecordToBlockchain(fileHash, recipientWalletAddress) {
  try {
    // Estimate the gas required for the transaction
    const gasEstimate = await contract.methods.storeFileHash(fileHash, recipientWalletAddress).estimateGas({ from: walletAddress });
    const gasLimit = Math.ceil(Number(gasEstimate) * 1.1); // Adjust the buffer factor as needed

    // Get the current transaction nonce for the wallet address
    const nonce = await web3.eth.getTransactionCount(walletAddress);

        // Fetch the current gas price
        const gasPrice = await web3.eth.getGasPrice();

    // Create the transaction object
    const tx = {
      from: walletAddress,
      to: contractAddress,
      gas: Number(gasLimit),
      gasPrice: Number(gasPrice),
      nonce: nonce,
      data: contract.methods.storeFileHash(fileHash, recipientWalletAddress).encodeABI()
    };

    // Sign the transaction
    const signedTx = await web3.eth.accounts.signTransaction(tx, privateKey);

    // Send the transaction
    const receipt = await web3.eth.sendSignedTransaction(signedTx.rawTransaction);
    return receipt;

  } catch (error) {
    console.error('Error uploading record to blockchain:', error);
    throw error;
  }
}

async function getRecordsFromBlockchain(recipientWalletAddress) {
  try {
    // Call the getRecords function to retrieve records
    const records = await contract.methods.getRecords(recipientWalletAddress).call();
    return records;

  } catch (error) {
    console.error('Error retrieving records from blockchain:', error);
    throw error;
  }
}

module.exports = { uploadRecordToBlockchain, getRecordsFromBlockchain };
