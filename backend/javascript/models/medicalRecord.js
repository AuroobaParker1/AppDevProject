
// const mongoose = require('mongoose');

// const medicalRecordSchema = new mongoose.Schema({
//     patient: {
//         type: mongoose.Schema.Types.ObjectId,
//         ref: 'Patient',
//         required: true
//     },
//     filename: {
//         type: String,
//         required: true
//     },
//     contentType: {
//         type: String,
//         required: true
//     },
//     uploadDate: {
//         type: Date,
//         default: Date.now
//     },
//     length: {
//         type: Number,
//         required: true
//     },
//     data: {
//         type: Buffer,
//         required: true
//     }
// });

// const MedicalRecord = mongoose.model('MedicalRecord', medicalRecordSchema);

// module.exports = MedicalRecord;
const mongoose = require('mongoose');

const medicalRecordSchema = new mongoose.Schema({
    patient: {
        type: mongoose.Schema.Types.ObjectId,
        required: true,
        ref: 'Patient'
    },
    records: [
        {
            filename: {
                type: String,
                required: true
            },
            contentType: {
                type: String,
                required: true
            },
            uploadDate: {
                type: Date,
                default: Date.now
            },
            length: {
                type: Number,
                required: true
            },
            data: {
                type: Buffer,
                required: true
            },
            
        }
    ],
    files_hashes: [
        {
            hash: {
                type: String,
                required: true,
            }
        }
    ]
});

const MedicalRecord = mongoose.model('MedicalRecord', medicalRecordSchema);

module.exports = MedicalRecord;

// const mongoose = require('mongoose');

// const medicalRecordSchema = new mongoose.Schema({
   
//     hash: {
//         type: String,
//         required: true
//     },
//             filename: {
//                 type: String,
//                 required: true
//             },
//             contentType: {
//                 type: String,
//                 required: true
//             },
//             uploadDate: {
//                 type: Date,
//                 default: Date.now
//             },
//             length: {
//                 type: Number,
//                 required: true
//             },
//             data: {
//                 type: Buffer,
//                 required: true
//             },
        
    
// });

// const MedicalRecord = mongoose.model('MedicalRecord', medicalRecordSchema);

// module.exports = MedicalRecord;


// const mongoose = require('mongoose');

// const recordSchema = new mongoose.Schema({
//     filename: {
//         type: String,
//         required: true
//     },
//     contentType: {
//         type: String,
//         required: true
//     },
//     uploadDate: {
//         type: Date,
//         default: Date.now
//     },
//     length: {
//         type: Number,
//         required: true
//     },
//     data: {
//         type: Buffer,
//         required: true
//     }
// }, { _id: false });

// const medicalRecordSchema = new mongoose.Schema({
//     patient: {
//         type: mongoose.Schema.Types.ObjectId,
//         required: true,
//         ref: 'Patient'
//     },
//     records: {
//         type: Map,
//         of: recordSchema,
//         default: {}
//     }
// });

// const MedicalRecord = mongoose.model('MedicalRecord', medicalRecordSchema);

// module.exports = MedicalRecord;
