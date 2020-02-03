var mongoose = require('mongoose');
var Particle = mongoose.model('Particle');

/*  Standard Response function */
var sendJSONResponse = function(res, status, content) {
    res.status(status);
    res.json(content);
};

module.exports = function(req, res, next){

    if (req.params && req.params.particleid) {
        Particle
            .findById(req.params.particleid)
            .populate('userID', 'username')
            .exec(function(err, particle) {
                console.log('decoded id - ' + req.decoded._id );
                console.log('particl id - ' + particle.userID._id);
                if (req.decoded._id == particle.userID._id) {
                    next();
                } else {
                    sendJSONResponse(res, 401, {
                        message: 'You are not allowed to edit this particle.'
                    });

                }
            }
        )
    } else {
        console.log('No locationid specified');
        sendJSONResponse(res, 404, {
            message: "No particleid in request"
        });
    }

};
