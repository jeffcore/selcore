var mongoose = require('mongoose');
var Schema = mongoose.Schema;

var particleSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true
    },
    description: String,
    userID: {
        type: Schema.Types.ObjectId,
        ref: 'User'
    },
    price: Number,
    soldUserID: {
        type: Schema.Types.ObjectId,
        default: null
    },
    images: [
        {
            type: String,
            lowercase: true,
            trim: true
        }
    ],
    soldDate: {
        type: Date,
        default: null
    },
    alive: Boolean,
    createdOn: {
        type: Date,
        default: Date.now
    }
});

var Particle = mongoose.model('Particle', particleSchema);