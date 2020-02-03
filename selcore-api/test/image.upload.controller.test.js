var app = require('../app');
//require('../app_api/models/db.js');
var request = require('supertest');
var should = require('should');
var api = request('http://localhost:3000');
var mongoose = require('mongoose');
var Particle = mongoose.model('Particle');
var User = mongoose.model('User');
var config = require('../config');
var fs = require('fs');

describe('Image Upload Controller Unit Tests:', function(){
    var token = null;
    var user = null;
    var particle = null;
    var particleID = null;
    var particle_update_data = null;
    var filename = 'x.jpeg';
    var filename_after = '';

    before(function(done){

        user = new User({
            username: 'testertedupload',
            password: '553399',
            email: 'testerupload@tester.com'
        });

        user.save(function(err){
            particle = new Particle({
                name: 'xbox',
                description: 'this is cool',
                userID: user._id,
                price: 33.33,
                alive: 1
            });

            particle.save(function(err){
                particleID = particle._id;
                done();
            });
        });

    });

    before(function(done){

        api
            .post('/api/login')
            .set('Accept', 'application/x-www-form-urlencoded')
            .set('x-api-key', config.apiKey)
            .send({ username: user.username, password: '553399'})
            .end(function(err, res) {
                token = res.body.token;
                done();
            });

    });

    describe('Testing the POST Image upload Methods - Particle Photo', function(){

        it('Should be able to upload photo', function(done){

            api.post('/api/particle/upload/' + particleID)
                .set('Content-Type', 'multipart/form-data')
                .set('x-api-key', config.apiKey)
                .set('x-access-token', token)
                .attach('photo',  __dirname + '/' + filename)
                .expect(201)
                .end(function(err, res){
                    if (err) {
                        return done(err);
                    } else {
                        filename_after = res.body.filename
                    }
                    done()
                });
        });

        it('Image Should appear in Particle images array', function(done){
            Particle
                .findById(particle._id)
                .exec(function(err, particle2){
                    particle2.images.should.have.property(filename_after);
                });

            done();
        });

    });

    after(function(done){
        fs.unlink('./public/images/' + filename_after, function() {

        });


        particle.remove(function() {
            user.remove(function() {
                done();
            });
        });

    })
});