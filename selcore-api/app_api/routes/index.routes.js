var express = require('express');
var router = express.Router();
var ctrlParticles = require('../controllers/particle.controller.js');
var ctrlUser = require('../controllers/user.controller.js');
var ctrlImageUpload = require('../controllers/image.upload.controller.js');
var apiTokenAuthorization = require('../middleware/token.auth.middle.js');
var apiKeyAuthorization = require('../middleware/apikey.auth.middle.js');
var particleUserAuthorization = require('../middleware/particleuser.auth.middle.js');
var multipart = require('connect-multiparty');
var multipartMiddleware = multipart();
var fs = require('fs');

router.post('/login', apiKeyAuthorization, ctrlUser.userAuthenticate);
router.post('/user', apiKeyAuthorization, ctrlUser.userCreate);

router.post('/particle/upload/:particleid', multipartMiddleware, apiKeyAuthorization, apiTokenAuthorization, ctrlImageUpload.particleImage);
router.get('/particle', apiKeyAuthorization, apiTokenAuthorization, ctrlParticles.particleList);
router.post('/particle', apiKeyAuthorization, apiTokenAuthorization, ctrlParticles.particleCreate);
router.get('/particle/:particleid', apiKeyAuthorization, apiTokenAuthorization, ctrlParticles.particleReadOne);
router.put('/particle/:particleid', apiKeyAuthorization, apiTokenAuthorization, particleUserAuthorization, ctrlParticles.particleUpdateOne);
router.delete('/particle/:particleid', apiKeyAuthorization, apiTokenAuthorization, particleUserAuthorization, ctrlParticles.particleDeleteOne);


router.post('/upload', multipartMiddleware, function(req, res){
    console.log(req.body, req.files); // check console

    fs.readFile(req.files.photo.path, function (err, data) {

        var newPath = 'public/images/' + req.files.photo.originalFilename;
        console.log(newPath);
        fs.writeFile(newPath, data, function (err) {
            //res.redirect("back");
        });
    });


    res.status(200);
    res.json({status: 'good to go'});


});


module.exports = router;