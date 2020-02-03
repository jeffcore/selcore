var mongoose = require('mongoose')
var Schema = mongoose.Schema;

var feedbackSchema = new mongoose.Schema({
    particleID:  {
        type: Schema.Types.ObjectId,
        ref: 'Particle'
    },
    userID:  {
        type: Schema.Types.ObjectId,
        ref: 'User'
    },
    buyerID:  {
        type: Schema.Types.ObjectId,
        ref: 'User'
    },
    particleName: String,
    authorName: String,
    rating: {
        type: Number,
        required: true,
        min: 0,
        max: 5
    },
    reviewText: String,
    createdOn: {
        type: Date,
        default: Date.now
    }
});

var Feedback = mongoose.model('Feedback', feedbackSchema);