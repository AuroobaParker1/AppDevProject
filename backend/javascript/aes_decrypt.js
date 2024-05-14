const crypto = require('crypto');

async function decryptTextUsingAESKey(encryptedText, aesKeyBase64, ivBase64) {
    try {
        // Convert the base64 encoded AES key and IV to buffers
        const aesKey = Buffer.from(aesKeyBase64, 'base64');
        const iv = Buffer.from(ivBase64, 'base64');

        // Create a decipher object
        const decipher = crypto.createDecipheriv('aes-256-cbc', aesKey, iv);

        // Decrypt the text
        let decryptedText = decipher.update(encryptedText, 'base64', 'utf8');

        decryptedText += decipher.final('utf8');    

        console.log('Text decrypted successfully:', decryptedText);
        return decryptedText;
    } catch (error) {
        console.error('Error decrypting text:', error);
        return null;
    }
}

// Usage
const encryptedText = 'heIjb12t86IdWnvV1cHjHw=='; // Encrypted text to decrypt
const aesKeyBase64 = 'hE0c3BHQUm6Met9fkWTwYkVFC/zf6Co62cACiviwFUI='; // Base64 encoded AES key retrieved from Flutter storage
const ivBase64 = 'PD85GupXYd6PY8c1DOhf2g=='; // Base64 encoded IV retrieved from Flutter storage

decryptTextUsingAESKey(encryptedText, aesKeyBase64, ivBase64);
