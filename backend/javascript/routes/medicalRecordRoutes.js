const express = require('express');
const router = express.Router();
const multer = require('multer');
const medicalRecordController = require('../controllers/medicalRecordController');

// Set up multer for file upload
const upload = multer();

router.post('/upload', upload.single('file'), medicalRecordController.uploadRecord);
router.get('/patient', medicalRecordController.getAllRecordsByPatient);
// Route to generate a temporary link for accessing patient records
router.get('/generate-link/', medicalRecordController.generateTemporaryLink);

// Route to access patient records via a temporary link
router.get('/temporary/:token', medicalRecordController.accessTemporaryLink);


router.get('/generate-code', medicalRecordController.generateVerificationCode);
router.post('/verify-code', medicalRecordController.verifyCodeAndRetrieveRecords);

module.exports = router;