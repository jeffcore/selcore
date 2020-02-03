var mongoose = require('mongoose');
var bcrypt = require('bcrypt');
var Schema = mongoose.Schema;
var Particle = require('./particle.model.js');
var SALT_WORK_FACTOR = 10;

var userSchema = mongoose.Schema({
    username: {
        type: String,
        required: true,
        index: { unique: true }
    },
    password: {
        type: String,
        required: true
    },
    email: {
        type: String,
        unique: true,
        required: true,
        lowercase: true,
        trim: true
    },
    particles: [{
        type: Schema.Types.ObjectId,
        ref: 'Particle'
    }],
    feedback: [{
        type: Schema.Types.ObjectId,
        ref: 'Feedback',
        default: null
    }],
    numberTransactions: {
        type: Number,
        default: 0
    },
    rating: {
        type: Number,
        default: 0
    },
    createdOn: {
        type: Date,
        "default": Date.now
    }
});

userSchema.pre('save', function(next) {
    var user = this;

    // only hash the password if it has been modified (or is new)
    if (!user.isModified('password')) return next();

    // generate a salt
    bcrypt.genSalt(SALT_WORK_FACTOR, function(err, salt) {
        if (err) return next(err);

        // hash the password along with our new salt
        bcrypt.hash(user.password, salt, function(err, hash) {
            if (err) return next(err);

            // override the cleartext password with the hashed one
            user.password = hash;
            next();
        });
    });
});

userSchema.methods.comparePassword = function(candidatePassword, cb) {
    bcrypt.compare(candidatePassword, this.password, function(err, isMatch) {
        if (err) return cb(err);
        cb(null, isMatch);
    });
};

userSchema.statics.findByUsername = function (username, cb) {
    this.findOne({ username: username }, cb);
};

var User = mongoose.model('User', userSchema);