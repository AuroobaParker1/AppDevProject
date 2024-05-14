// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract MedicalRecord {
     mapping(string => address)  single_fileHash;
 mapping(address => string[]) fileHashes;  // Store file hashes for each address
    function storeFileHash(string memory fileHash, address wallet) public {
        // Store the wallet address associated with the file hash
        single_fileHash[fileHash]= wallet;
       fileHashes[wallet].push(fileHash);
    }

    // function updateFileHashes(string[] memory newHashes, address wallet) public {
    //     fileHashes[wallet] = newHashes;
    // }

     // Get method
    function getRecords(address wallet_address) public view returns (string[] memory) {
        return fileHashes[wallet_address];
    }
    function getWalletAddress(string memory fileHash) public view returns (address) {
        return single_fileHash[fileHash];
    }
}
