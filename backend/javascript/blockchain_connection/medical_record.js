const Web3 = require('web3').default;
const web3 = new Web3('http://localhost:7545');
const fs = require('fs');
const path = require('path');
const contractAddress = process.env.Contract_Address_MedicalRecord; // replace with your contract address
const abi = JSON.parse(fs.readFileSync('C:\\Users\\Yousuf\\Desktop\\etherium_tutorial\\fyp_1\\backend\\blockchain\\build\\contracts\\MedicalRecord.json')).abi;

const contract = new web3.eth.Contract(abi, contractAddress);

async function uploadRecordToBlockchain(fileHash, wallet_address) {
  try {
    const accounts = await web3.eth.getAccounts();
    
    // Estimate the gas required for the transaction
    const gasEstimate = await contract.methods.storeFileHash(fileHash, wallet_address).estimateGas({ from: accounts[0] });
    
    // Send the transaction to upload record with a higher gas limit
    const tx = await contract.methods.storeFileHash(fileHash, wallet_address).send({ from: accounts[0], gas: gasEstimate });
    return tx;

  } catch (error) {
    console.error('Error uploading record to blockchain:', error);
    throw error;
  }
}


async  function getRecordsFromBlockchain(wallet_address) {
  try {
    // Call the getRecords function to retrieve records
    const records = await contract.methods.getRecords(wallet_address).call();
    return records;

  } catch (error) {
    console.error('Error retrieving records from blockchain:', error);
    throw error;
  }
}

module.exports = { uploadRecordToBlockchain,getRecordsFromBlockchain };
