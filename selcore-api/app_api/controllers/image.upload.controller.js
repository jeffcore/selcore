var mongoose = require('mongoose');
var Particle = mongoose.model('Particle');
var User = mongoose.model('User');
var fs = require('fs');
var uuid = require('node-uuid');

/*  Standard JSON Response function */
var sendJSONResponse = function(res, status, content) {
    res.status(status);
    res.json(content);
};

/*
 POST particle image
 /api/particle/upload
 */
module.exports.particleImage = function(req, res) {

    console.log(req.body, req.files); // check console
    var filename = uuid.v4() + '.jpg';

    console.log(filename);

    if (req.params && req.params.particleid) {
        Particle.findByIdAndUpdate(
            req.params.particleid,
            {$push: {images: filename}},
            {safe: true, upsert: true},
            function(err, particle) {

                console.log(err);
            }
        );
    } else {
        console.log('No locationid specified');
        sendJSONResponse(res, 404, {
            "message": "No particleid in request"
        });
    }

    fs.readFile(req.files.photo.path, function (err, data) {
        var newPath = 'public/images/' + filename;
        console.log(newPath);
        fs.writeFile(newPath, data, function (err) {

            sendJSONResponse(res, 201, {
                message: "Upload ok",
                filename : filename
            });

        });
    });

};