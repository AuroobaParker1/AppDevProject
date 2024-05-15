require('dotenv').config();
const bcrypt = require('bcryptjs');
const NodeRSA = require('node-rsa');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const Patient = require('../models/patient');
// const register = require('../registerUser');
const registerUser = require('../blockchain_connection/register_user');
const verifyToken = require('./middleware/tokenauth'); // Assuming jwtVerify.js is in the same directory

exports.signup = async (req, res) => {
    try {

        // const { name, email, password } = req.body;
        //     const hashedPassword = await hashPassword(password);
            

        // Generate the RSA key pair
        const { publicKey, privateKey } = crypto.generateKeyPairSync('rsa', {
            modulusLength: 2048,  // the length of your key in bits
            publicKeyEncoding: {
                type: 'pkcs1',      // recommended to be 'spki' by the Node.js docs
                format: 'pem'
            },
            privateKeyEncoding: {
                type: 'pkcs1',     // recommended to be 'pkcs8' by the Node.js docs
                format: 'pem'
            }
        });

        const { name, email, mobileNumber, password } = req.body;
        const hashedPassword = await bcrypt.hash(password, 10);
        console.log(registerUser);

         const wallet = await registerUser();
        // const x509Identity =  await register(email);
        const patient = new Patient({
            name,
            email,
            mobile: mobileNumber,
            password: hashedPassword,
           
            wallet_address: wallet.address,
            wallet_privateKey: wallet.privateKey,
            rsa_prikey: privateKey,
            rsa_pubkey: publicKey,
        });
        // console.log(publicKey);
        // console.log(privateKey);

        await patient.save();
      
 
        res.status(201).json({
            message: 'Patient created successfully',
            wallet: wallet,
            rsaKeyPair: {
                publicKey: publicKey,
            }
        });

        
    } catch (error) {
        console.log(error.message);
        res.status(500).json({ error: error.message });
    }
};

exports.login = async (req, res) => {
    try {
        const aesKey = generateAESKey();
        
        const { email, password } = req.body;
        const patient = await Patient.findOne({ email });
        if (!patient) {
            return res.status(401).json({ message: 'No user with this email is registered' });
        }
        const isPasswordMatch = await bcrypt.compare(password, patient.password);
        if (!isPasswordMatch) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }
        const token = jwt.sign({ userId: patient._id }, process.env.SECRET_KEY, { expiresIn: '1h' });
        res.status(200).json({ token, expiresIn: 3600, userId: patient._id,aeskey: aesKey.toString('hex')});
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

// Generate a random AES key
const generateAESKey = () => {
    return crypto.randomBytes(32); // 32 bytes for AES-256
};


exports.forgotPassword = async (req, res) => {
    try {
        const { email } = req.body;
        const patient = await Patient.findOne({ email });
        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        // Generate random 4-digit OTP
        const otp = Math.floor(1000 + Math.random() * 9000);

        // Save the OTP to patient document in the database
        patient.resetPasswordOTP = otp;
        await patient.save();

        // Sending email with OTP
        const transporter = nodemailer.createTransport({
            service: 'Gmail',
            auth: {
              user: process.env.GMAIL_USER,
              pass: process.env.GMAIL_PASS,
            },
          });

        const mailOptions = {
            from: process.env.GMAIL_USER,
            to: email,
            subject: 'Password Reset OTP',
            text: `Your OTP for password reset is: ${otp}`
        };

        transporter.sendMail(mailOptions, (error, info) => {
            if (error) {
                console.error('Error sending email:', error);
                return res.status(500).json({ error: 'Failed to send OTP email' });
            }
            console.log('Email sent:', info.response);
            res.status(200).json({ message: 'OTP sent to your email' });
        });
    } catch (error) {
        console.error('Error in forgotPassword:', error);
        res.status(500).json({ error: error.message });
    }
};  

exports.verifyOTPAndChangePassword = async (req, res) => {
    try {
        const { email, otp, newPassword } = req.body;
        const patient = await Patient.findOne({ email });

        if (!patient) {
            return res.status(404).json({ message: 'Patient not found' });
        }

        // Check if OTP matches and is not expired
        if (patient.resetPasswordOTP !== otp) {
            return res.status(400).json({ message: 'Invalid OTP' });
        }

        const currentTime = new Date();
        if (currentTime > patient.resetPasswordExpires) {
            return res.status(400).json({ message: 'OTP has expired' });
        }

        // Hash the new password
        const hashedPassword = await bcrypt.hash(newPassword, 10);
        patient.password = hashedPassword;
        patient.resetPasswordOTP = null;
        patient.resetPasswordExpires = null;

        await patient.save();

        res.status(200).json({ message: 'Password changed successfully' });
    } catch (error) {
        console.error('Error in verifyOTPAndChangePassword:', error);
        res.status(500).json({ error: error.message });
    }
};
exports.UserInfo = async (req, res) => {
    try {
      // Call verifyToken middleware to authenticate the request
      await verifyToken(req, res); 
  
      const userId = req.userId; // Access user ID attached by verifyToken
      const patient = await Patient.findById(userId);
      if (!patient) {
        return res.status(404).json({ message: 'User not found' });
      }
  
      const userDetails = {
        id: patient._id,
        email: patient.email,
        name: patient.name,
        mobileNumber: patient.mobile,
        // Exclude sensitive data
      };
  
      res.status(200).json(userDetails);
    } catch (error) {
      console.error('Error fetching user details:', error);
      res.status(500).json({ error: 'Failed to fetch user details' });
    }
  };

  exports.storeAESkey = async (req, res) => {
    try {
      // Call verifyToken middleware to authenticate the request
      await verifyToken(req, res); 
  
      const userId = req.userId; // Access user ID attached by verifyToken
      const patient = await Patient.findById(userId);
      if (!patient) {
        return res.status(404).json({ message: 'User not found' });
      }
      
      const { encryptedAesKey , IV } = req.body;
      patient.AESkey = encryptedAesKey;

      
    patient.iv = IV;
    await patient.save();
    res.status(200).json({ message: 'AES key stored successfully' });
  } catch (error) {
    console.error(error);
    res.status(500).json({ message: 'An error occurred' });
  }
};

//   exports.storeEncryptedAESkey = async (req, res) => {
//     try {
//       // Call verifyToken middleware to authenticate the request
//       await verifyToken(req, res); 
  
//       const userId = req.userId; // Access user ID attached by verifyToken
//       const patient = await Patient.findById(userId);
//       if (!patient) {
//         return res.status(404).json({ message: 'User not found' });
//       }
//       const privateKey = patient.rsa_prikey;
//       const { encryptedAesKey , IV } = req.body;

//       // Decrypt data with private key
// // Create a new NodeRSA instance with private key



// // Create a new NodeRSA instance with the private key
// const pkey = '-----BEGIN RSA PRIVATE KEY-----MIICWgIBAAKBgFKfEW2XqAMA0END2FN9tlNUxZXiWGdS5OeRhio/Tfw9d0L5d74bqGX8VWViapCJYm7UM5ZSY2UzqVFf/758fVVkutuQi3U79jCs3QwCfjVc4fmwX2BwicwTEySjahXyNA8aC92VUgLZz5cF9vdETkpgFVY64UVJ6inw3UB8oiLTAgMBAAECgYAlicARWuYq9yOobBrNVECSe+GJx90ClNcLn0Klzz1PbV3SQCX3afmI3Kyv85cXNFRUpnUJx0UBpgc3wbYghc8riGs/lD3ZRbsTV2cuasqx/mAqW3zRsqOo7X6hW0REmnh5ATqK79RnwSvikctTJxZS1VjIc2dHAp8jrlJXlTfuAQJBAJ/HCGQnRcOZCacZezAKSV07qjN0QCWo2mJ+r1/d0s6Efw1KiwJULP44kxEVPL/4VXv2Wmn41StPkPbXHoeWtrECQQCEYNdxMZWllXlmYOKEGkKVbzYTn335zzymeRfprC1qasCprl9HM45qe+JGMrWLRRbEqEm1QrnET7Xi3K0adxrDAkA7WjsywSf4PexJB30sXlXcbWKPVJrTooLlXbwV95fsoWl07YDv74b7NNbk3KfBhCV1NBFoFkhRm2/1UfoEUicxAkBznf0ssMjpuPYx05ajGChlSZ9qXhdx0m0/XG3lOerkkd45lMFEd6QAHrkO5IUo4Su0kOLnfCKxcYkDXgeWIMZvAkBDeXCQr/pePbAzUH8PJOj1M5+cZCcyg0O+EfYDE6iu2qpwLP54d85r2AiEZQ6yei/m7ku3uwPW2LCbKSZlrqXM-----END RSA PRIVATE KEY-----';
// const rsa = new NodeRSA(pkey, { encryptionScheme: 'pkcs1_oaep' });



//     //   decrypt.setPrivateKey(privateKey);
// // Decrypt data with private key
// const decryptedAesKeyBase64 = rsa.decrypt(Buffer.from(encryptedAesKey, 'base64'), 'utf8');

// console.log('Decrypted:', decryptedAesKeyBase64);
  

// // // Convert the base64-encoded AES key to a Uint8List
// // const aesKey = Buffer.from(decryptedAesKeyBase64, 'base64');


// console.log('AES Key (Uint8List):', aesKey);
//     //   console.log(privateKey);

//     // const encryptedAesKeyBuffer = Buffer.from(encryptedAesKey, 'base64');
// // console.log('Decoded AES Key Buffer:', encryptedAesKeyBuffer);
// //       const decryptedAesKey = crypto.privateDecrypt(
// //         {
// //           key: privateKey,
// //           padding: crypto.constants.RSA_PKCS1_PADDING,
// //         },
// //         Buffer.from(encryptedAesKey, 'base64') // Assuming the encrypted AES key is base64 encoded
// //       );
//     // Convert the decrypted AES key to a string
//     const decryptedAesKeyString = decryptedAesKeyBase64.toString('base64');

//     // Update the patient document with the decrypted AES key
//     patient.AESkey = decryptedAesKeyString;
//     patient.iv = IV;
//     await patient.save();
//     res.status(200).json({ message: 'AES key stored successfully' });
//   } catch (error) {
//     console.error(error);
//     res.status(500).json({ message: 'An error occurred' });
//   }
// };
