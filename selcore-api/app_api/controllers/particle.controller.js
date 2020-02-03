var mongoose = require('mongoose');
var Particle = mongoose.model('Particle');
var User = mongoose.model('User');

/*  Standard Response function */
var sendJSONResponse = function(res, status, content) {
    res.status(status);
    res.json(content);
};

/*
    GET a list of particles
    /api/particle/
 */
module.exports.particleList = function(req, res) {
    Particle
        .find()
        .populate('userID', 'username')
        .exec(function(err, particle) {
            if (!particle) {
                sendJSONresponse(res, 404, {
                    success: false,
                    message: "particle id not found"
                });
                return;
            } else if (err) {
                console.log(err);
                sendJSONresponse(res, 404, {
                    success: false,
                    message: "error loading particles"
                });
                return;
            }
            console.log(particle);
            sendJSONResponse(res, 200, {data: particle});
        }
    );
};

/*
    POST - create a new particle
    /api/particle/
*/
module.exports.particleCreate = function(req, res) {
    console.log(req.body);
    Particle
        .create({
            name: req.body.name,
            description: req.body.description,
            userID: req.decoded._id,
            sold_user_id: "0",
            price: req.body.price
        }, function(err, particle) {
            if (err) {
                console.log(err);
                sendJSONResponse(res, 400, err);
            } else {
                console.log(particle);

                User.findByIdAndUpdate(
                    req.decoded._id,
                    {$push: {particles: particle._id}},
                    {safe: true, upsert: true},
                    function(err, model) {
                        console.log(err);
                    }
                );
                sendJSONResponse(res, 201, {data: particle});
            }
        });
};

/*
    GET a particle by id
    /api/particle/:particleid
*/
module.exports.particleReadOne = function(req, res) {
    if (req.params && req.params.particleid) {
        Particle
            .findById(req.params.particleid)
            .populate('userID', 'username')
            .exec(function(err, particle){
                sendJSONResponse(res, 200, {data: particle});
            }
        )
    } else {
        console.log('No locationid specified');
        sendJSONResponse(res, 404, {
            "message": "No particleid in request"
        });
    }
};

/*
    UPDATE a particle by id
    /api/particle/:particleid
*/
module.exports.particleUpdateOne = function(req, res) {
    if (req.params && req.params.particleid) {
        Particle
            .findById(req.params.particleid)
            .populate('userID', 'username')
            .exec(function(err, particle){
                if(!particle){
                    sendJSONResponse(res, 400, {
                        message: 'locationid not found'
                    });
                    return;
                } else if(err) {
                    sendJSONResponse(res, 400, err);
                    return;
                }
                particle.name = req.body.name;
                particle.description = req.body.description;
                particle.sold_user_id = '0';
                particle.price = req.body.price;

                particle.save(function(err, location) {
                    if (err) {
                        sendJSONResponse(res, 400, err);
                    } else {
                        sendJSONResponse(res, 200, {data: particle});
                    }
                });
            }
        );
    } else {
        console.log('No particleid specified');
        sendJSONResponse(res, 400, {
            message: 'No particleid in request'
        });
    }
};

/*
    DELETE a particle by id
    /api/particle/:particleid
*/
module.exports.particleDeleteOne = function(req, res) {
    var particleid = req.params.particleid;
    if (particleid) {
        Particle
            .findByIdAndRemove(particleid)
            .exec(
                function(err, particle) {
                    if (err) {
                        console.log(err);
                        sendJSONResponse(res, 404, err);
                        return;
                    }
                    console.log("Location id " + particleid + " deleted");

                    User.findByIdAndUpdate(
                        req.decoded._id,
                        {$pull: {particles: particle._id}},
                        function(err, model) {
                            console.log(err);
                        }
                    );

                    sendJSONResponse(res, 204, {message: 'successfully deleted particle'});
                }
            );
    }
};