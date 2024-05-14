
const MedicalRecord = require('../models/medicalRecord');
const Patient = require('../models/patient');
const crypto = require('crypto');
const nodeSchedule = require('node-schedule');
const verifyToken = require('./middleware/tokenauth'); 
const fs = require('fs');


const { uploadRecordToBlockchain, getRecordsFromBlockchain } =  require('./../blockchain_connection/medical_record');




// Temporary storage for tokens
const tempTokenStore = new Map();

exports. uploadRecord = async (req, res) => {
    try {
        // const { patientId } = req.params;
        await verifyToken(req, res); 
  
        const userId = req.userId; // Access user ID attached by verifyToken
        const { originalname, mimetype, buffer } = req.file;
 // Calculate the hash of the file
// Convert the originalname and mimetype to buffers



const hash = crypto.createHash('sha256');
hash.update(buffer);
const fileHash = hash.digest('hex');



        // // Find existing MedicalRecord for the patient
         let medicalRecord = await MedicalRecord.findOne({ patient: userId });
        let Patient_wallet = await Patient.findOne({_id: userId});
        // console.log(PatientEmail);
        // If no existing record found, create a new one
        if (!medicalRecord) {
            medicalRecord = new MedicalRecord({
                patient: userId,
                records: [],
                files_hashes: [],
            });
        }

        // Push the new record details into the records array
        medicalRecord.records.push({
            filename: originalname,
            contentType: mimetype,
            length: buffer.length,
            data: buffer,
        });
        medicalRecord.files_hashes.push({
            hash: fileHash,
        });
        medicalRecord.patient = userId;

        // Save the updated medical record to the database
        const savedRecord = await medicalRecord.save();

// // Create a new MedicalRecord
// const medicalRecord = new MedicalRecord({
//     patient: userId,
//     filename: originalname,
//     contentType: mimetype,
//     length: buffer.length,
//     data: buffer
// });

// // Save the Medical Record
// await medicalRecord.save();



 // Upload the record to the blockchain
  const tx = await uploadRecordToBlockchain(fileHash, Patient_wallet.wallet_address);
var tx_status = false;
if(tx != null){
    console.log("record uploaded to etherium");
    tx_status = true;
}

        res.status(201).json({ message: 'Medical record uploaded successfully', record: savedRecord, tx: tx_status });
    } catch (error) {
        console.error('Error in uploadRecord:', error);
        res.status(500).json({ error: error.message });
    }
};

// Modified getAllRecordsByPatient to be reusable
exports.getAllRecordsByPatient = async (req, res) => {
    try {
        await verifyToken(req, res); 
  
        const userId = req.userId; // Access user ID attached by verifyToken

        const patient = await Patient.findById({_id: userId});
        
            // Get array2 from blockchain
        const array2 = await getRecordsFromBlockchain(patient.wallet_address);
        
        // Find existing MedicalRecord for the patient
        const medicalRecord = await MedicalRecord.findOne({ patient: userId });

        // Extract hashes from medicalRecord.files_hashes
        const hashesFromRecords = medicalRecord.files_hashes.map(item => item.hash);

        // Extract values from array2 (plain strings)
        const valuesFromArray2 = new Set(array2);

        // Check if every hash from array1 is present in array2
        const allValuesPresent = hashesFromRecords.every(hash => valuesFromArray2.has(hash));


        if (allValuesPresent) {
            console.log("All values in array 1 are present in array 2.");
        } else {
            console.log("Not all values in array 1 are present in array 2.");
            return res.status(404).json({ message: 'Medical records found in Blockchain and Server storage dont match So files cannot be displayed.' });
        }    
    
        // If no existing record found, return an error
        if (!medicalRecord) {
            return res.status(404).json({ message: 'Medical records not found for this patient' });
        }

        // Convert the records map to an array of objects for the response
        res.status(200).json(medicalRecord.records);

    } catch (error) {
        console.error('Error in getAllRecordsByPatient:', error);
        throw new Error(error.message);
    }
};
    

// Modified getAllRecordsByPatient to be reusable

exports.generateTemporaryLink = async (req, res) => {
    try {
        
        // const { patientId } = req.params;
        await verifyToken(req, res); 
  
        const patientId = req.userId; // Access user ID attached by verifyToken



        const token = crypto.randomBytes(20).toString('hex');
        const linkExpirationDate = new Date(Date.now() + 120000); // 2 minutes from now

        tempTokenStore.set(token, { patientId, expires: linkExpirationDate });

        // Schedule token deletion
        nodeSchedule.scheduleJob(linkExpirationDate, () => {
            tempTokenStore.delete(token);
        });

        const link = `${req.protocol}://${req.get('host')}/api/medical-records/temporary/${token}`;
        res.status(200).json({ message: 'Temporary link generated successfully', link });
    } catch (error) {
        console.error('Error in generateTemporaryLink:', error);
        res.status(500).json({ error: error.message });
    }
};


exports.accessTemporaryLink = async (req, res) => {
    try {
        const { token } = req.params;
        const tokenData = tempTokenStore.get(token);

        if (!tokenData || new Date() > tokenData.expires) {
            return res.status(404).json({ message: 'Link is invalid or has expired' });
        }

        tempTokenStore.delete(token); // Invalidate token

        // 
        // Fetch the patient's name
        const patient = await Patient.findById(tokenData.patientId);
        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }
        const patientName = patient.name; // Assuming the patient's name field is `name`

        const medicalRecords = await getAllRecordsByPatient_noToken(tokenData.patientId,email);
        // console.log(medicalRecords[0].data);


            // Get array2 from blockchain
            const array2 = await getRecordsFromBlockchain(patient.wallet_address);
        
            // Find existing MedicalRecord for the patient
            const medicalRecord = await MedicalRecord.findOne({ patient: userId });
    
            // Extract hashes from medicalRecord.files_hashes
            const hashesFromRecords = medicalRecord.files_hashes.map(item => item.hash);
    
            // Extract values from array2 (plain strings)
            const valuesFromArray2 = new Set(array2);
    
            // Check if every hash from array1 is present in array2
            const allValuesPresent = hashesFromRecords.every(hash => valuesFromArray2.has(hash));
    
    
            if (allValuesPresent) {
                console.log("All values in array 1 are present in array 2.");
            } else {
                console.log("Not all values in array 1 are present in array 2.");
                return res.status(404).json({ message: 'Medical records found in Blockchain and Server storage dont match So files cannot be displayed.' });
            }    





        const aesKeyBase64 = patient.AESkey; // Base64 encoded AES key retrieved from Flutter storage
        const ivBase64 = patient.iv; // Base64 encoded IV retrieved from Flutter storage

        // Convert the base64 encoded AES key and IV to buffers
        const aesKey = Buffer.from(aesKeyBase64, 'base64');
        const iv = Buffer.from(ivBase64, 'base64');

        
        let imagesHtml = '';
        medicalRecords.forEach(record => {
           
        // Create a decipher object
        const decipher = crypto.createDecipheriv('aes-256-cbc', aesKey, iv);

            // console.log(record.data);
             // Convert the decrypted binary data to Base64
            let decryptedData = decipher.update(record.data);
            decryptedData = Buffer.concat([decryptedData, decipher.final()]);
            let base64Image = decryptedData.toString('base64');

            // let decryptedText = decipher.update(record.data, 'binary', 'utf8');
            // decryptedText += decipher.final('utf8');
            
            console.log(base64Image);

            //  console.log(base64Image);
            imagesHtml += `
                <div>
                    <h2>${record.filename}</h2>
                     <img src="data:${record.contentType};base64,${base64Image}"alt="${record.filename}" style="width:100%;" />
                </div>
            `;
        });

        // const html = `
        //     <!DOCTYPE html>
        //     <html>
        //     <head>
        //         <title>Medical Records for ${patientName}</title>
        //     </head>
        //     <body>
        //         <h1>${patientName}</h1>
        //         ${imagesHtml}
        //     </body>
        //     </html>
        // `;

        const html = `
        <!DOCTYPE html>
        <html>
        <head>
            <title>Medical Records for ${patientName}</title>
            <style>
                body {
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                    margin: 0;
                    padding: 20px;
                }
                .container {
                    max-width: 800px;
                    margin: 0 auto;
                    background-color: #fff;
                    padding: 20px;
                    border-radius: 5px;
                    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
                }
                h1 {
                    color: #333;
                }
                h2 {
                    color: #666;
                }
                img {
                    max-width: 100%;
                    height: auto;
                    margin-bottom: 10px;
                    border-radius: 5px;
                    box-shadow: 0 0 5px rgba(0, 0, 0, 0.1);
                }
            </style>
        </head>
        <body>
            <div class="container">
                <h1>${patientName}'s Medical Records</h1>
                ${imagesHtml}
            </div>
        </body>
        </html>
    `;
    
        res.send(html);
    } catch (error) {
        console.error('Error in accessTemporaryLink:', error);
        res.status(500).json({ error: error.message });
    }
};





async function getAllRecordsByPatient_noToken(patientId) {
    try {
        
         const userId = patientId; // Access user ID attached by verifyToken
  
      // Find the medical records for the given patient
      const medicalRecord = await MedicalRecord.findOne({ patient: userId });
  
      if (!medicalRecord) {
        return [];
      }
  
      return medicalRecord.records;
    } catch (error) {
      console.error('Error in getAllRecordsByPatient:', error);
      throw error;
    }
  };
// exports.getAllRecordsByPatient = async (req, res) => {
// try {

//     await verifyToken(req, res); 

//         const userId = req.userId; // Access user ID attached by verifyToken

//     const medicalRecords = await MedicalRecord.find({ patient: userId });
//     if (medicalRecords.length === 0) {
//         return [];
//     }

//     return medicalRecords.map(record => {
//         // const base64Data = record.data.toString('base64');

//         return {
//             _id: record._id,
//             filename: record.filename,
//             contentType: record.contentType,
//             data: record.data,
//         };
//     });
// } catch (error) {
//     console.error('Error in getAllRecordsByPatient:', error);
//     throw new Error(error.message);
// }
// };
// Generate and store a 6-digit code corresponding to the patient's email
exports.generateVerificationCode = async (req, res) => {
    try {
        
        await verifyToken(req, res); 
  
        const patientId = req.userId; // Access user ID attached by verifyToken

       var patient = await Patient.findById(patientId);

       const email = patient.email;
        // Generate a random 6-digit code
        const code = Math.floor(100000 + Math.random() * 900000);
        // Store the code with the email for 2 minutes
        tempTokenStore.set(code, { email, expires: Date.now() + 120000 });
        console.log(tempTokenStore);

        res.status(200).json({ message: 'Verification code generated successfully', code });
    } catch (error) {
        console.error('Error in generateVerificationCode:', error);
        res.status(500).json({ error: error.message });
    }
};

// Validate the provided code and retrieve records if it matches
exports.verifyCodeAndRetrieveRecords = async (req, res) => {
    try {
        var { code } = req.body; // Assuming the code is sent in the request body
        code = parseInt(code);
        const storedData = tempTokenStore.get(code);
        
        if (!storedData || Date.now() > storedData.expirationTime) {
            return res.status(404).json({ message: 'Code is invalid or has expired' });
        }

        // Retrieve patient by email
        const patient = await Patient.findOne({ email: storedData.email });
        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        // Compare the provided code with the stored code
        if (parseInt(code) === parseInt(code)) {
            const medicalRecords = await getAllRecordsByPatient_noToken(patient._id);
            return res.status(200).json({ medicalRecords });
        } else {
            return res.status(401).json({ message: 'Code is incorrect' });
        }
    } catch (error) {
        console.error('Error in verifyCodeAndRetrieveRecords:', error);
        res.status(500).json({ error: error.message });
    }
};
// function areAllValuesInArray1PresentInArray2(array1, array2) {
//     const array2Set = new Set(array2);
//     // Check if every element of array 1 is present in array 2
//     return array1.every(value => array2Set.has(value));
// }
