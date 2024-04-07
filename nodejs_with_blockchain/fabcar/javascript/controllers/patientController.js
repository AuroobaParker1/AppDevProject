// const User = require('./../models/user');
// const bcrypt = require('bcrypt');
// const nodemailer = require('nodemailer');
// const randomstring = require('randomstring');
// const register = require('./../registerUser'); // Replace 'originalFile.js' with the actual filename

// // Hash the user's password before saving
// const hashPassword = async (password) => {
//   const salt = await bcrypt.genSalt(10);
//   return bcrypt.hash(password, salt);
// };

// // Register a new user
// const registerUser = async (req, res) => {
//   try {
//     const { name, email, password } = req.body;
//     const hashedPassword = await hashPassword(password);
//     const x509Identity =  await register(email);
//     console.log(typeof x509Identity);
//     // console.log(x509Identity.credentials.certificate);
//     console.log(x509Identity);
    
//     const user = new User({ 
//       name,
//       email,
//       password: hashedPassword ,
//       credentials: {
//         certificate: x509Identity.credentials.certificate,
//         privateKey: x509Identity.credentials.privateKey,
//       },
//       mspId: x509Identity.mspId,
//       type: x509Identity.type,
//       version: 1
//     });

//     // console.log(x509Identity);
//     await user.save();


//     res.status(201).json({ message: 'User registered successfully' });
//   } catch (error) {
//     res.status(500).json({ error: 'Registration failed' });
//   }
// };

// // Compare a candidate password with the hashed password in the database
// const comparePassword = async (candidatePassword, hashedPassword) => {
//   return bcrypt.compare(candidatePassword, hashedPassword);
// };

// // Login a user
// const loginUser = async (req, res) => {
//   try {
//     const { email, password } = req.body;
//     const user = await User.findOne({ email });

//     if (!user || !(await comparePassword(password, user.password))) {
//       return res.status(401).json({ error: 'Invalid email or password' });
//     }

//     res.status(200).json({ message: 'Login successful' });
//   } catch (error) {
//     res.status(500).json({ error: 'Login failed' });
//   }
// };

// // Function to generate a random OTP
// const generateOTP = () => {
//     return randomstring.generate({ length: 4, charset: 'numeric' }); // You can adjust the OTP length as needed
//   };

// // Function to send an OTP to the user's email
// const sendOTPByEmail = async (email, otp) => {
//   // Configure your email service (e.g., Gmail) here
//   const transporter = nodemailer.createTransport({
//     service: 'Gmail',
//     auth: {
//       user: 'ahmedrazasst@gmail.com',
//       pass: 'cnsq ibwj gncc auhc',
//     },
//   });

//   // Define email data
//   const mailOptions = {
//     from: 'ahmedrazasst@gmail.com',
//     to: email,
//     subject: 'Password Reset OTP',
//     text: `Your OTP for password reset is: ${otp}`,
//   };

//   transporter.sendMail(mailOptions, (error, info) => {
//     if (error) {
//       console.log('Email sending failed:', error);
//     } else {
//       console.log('Email sent:', info.response);
//     }
//   });
// };


// const forgotPassword = async (req, res) => {
//     const { email } = req.body;
//     const otp = generateOTP(); // Generate a random OTP
  
//     try {
//       // Update the user in the database with the generated OTP
//       const user = await User.findOne({ email });
//       if (!user) {
//         return res.status(404).json({ error: 'User not found' });
//       }
  
//       user.otp = otp;
//       user.otpExpiry = new Date(Date.now() + 600000); // Set OTP expiry to 10 minutes from now
//       await user.save();
  
//       // Send the OTP to the user's email
//       sendOTPByEmail(email, otp);
  
//       res.status(200).json({ message: 'OTP sent to your email for password reset' });
//     } catch (error) {
//       res.status(500).json({ error: 'Password reset failed' });
//     }
//   };



// // Controller function for changing the password using OTP
// const changePasswordWithOTP = async (req, res) => {
//     const { email, otp, newPassword } = req.body;
  
//     try {
//       // Find the user by email
//       const user = await User.findOne({ email });
  
//       if (!user) {
//         return res.status(404).json({ error: 'User not found' });
//       }
  
//       // Verify if the OTP is correct and not expired
//       if (user.otp !== otp || user.otpExpiry <= new Date()) {
//         return res.status(400).json({ error: 'Invalid or expired OTP' });
//       }
//     // Hash the new password
//     const hashedPassword = await bcrypt.hash(newPassword, 10);
//       // Update the password and clear the OTP
//       user.password = hashedPassword;
//       user.otp = undefined;
//       user.otpExpiry = undefined;
//       await user.save();
  
//       res.status(200).json({ message: 'Password changed successfully' });
//     } catch (error) {
//       res.status(500).json({ error: 'Password change failed' });
//     }
//   };

// module.exports = {
//   registerUser,
//   loginUser,
//   forgotPassword,
//   changePasswordWithOTP,
// };
require('dotenv').config();
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const nodemailer = require('nodemailer');
const Patient = require('../models/patient');
const register = require('../registerUser');

exports.signup = async (req, res) => {
    try {

        // const { name, email, password } = req.body;
        //     const hashedPassword = await hashPassword(password);
            


        const { name, email, mobileNumber, password } = req.body;
        console.log(name, email, mobileNumber, password);
        const hashedPassword = await bcrypt.hash(password, 10);
        
        const x509Identity =  await register(email);
        const patient = new Patient({
            name,
            email,
            mobileNumber,
            password: hashedPassword,
            credentials: {
                        certificate: x509Identity.credentials.certificate,
                        privateKey: x509Identity.credentials.privateKey,
                      },
                      mspId: x509Identity.mspId,
                      type: x509Identity.type,
                      version: 1,
        });

        await patient.save();
      
 


        res.status(201).json({ message: 'Patient created successfully' });
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
};

exports.login = async (req, res) => {
    try {
        const { email, password } = req.body;
        const patient = await Patient.findOne({ email });
        if (!patient) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }
        const isPasswordMatch = await bcrypt.compare(password, patient.password);
        if (!isPasswordMatch) {
            return res.status(401).json({ message: 'Invalid email or password' });
        }
        const token = jwt.sign({ userId: patient._id }, process.env.SECRET_KEY, { expiresIn: '1h' });
        res.status(200).json({ token, expiresIn: 3600, userId: patient._id});
    } catch (error) {
        res.status(500).json({ error: error.message });
    }
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