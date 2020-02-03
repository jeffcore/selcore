var config = require('../../config'); // get our config file

module.exports = function(req, res, next){

    var apiKey = req.body.apikey || req.params.apikey || req.headers['x-api-key'];

    if (apiKey) {
        // verifies api-key`
        if( apiKey === config.apiKey ){
                next();
        } else {
            return res.status(401).send({
                success: false,
                message: 'Invalid api-key'
            });
        }
    } else {
        // if there is no token
        // return an error
        return res.status(403).send({
            success: false,
            message: 'Could not find your api key'
        });
    }
};