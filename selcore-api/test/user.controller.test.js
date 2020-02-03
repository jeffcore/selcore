var app = require('../app');
//require('../app_api/models/db.js');
var stest = require('supertest');
var should = require('should');
var mongoose = require('mongoose');
var Particle = mongoose.model('Particle');
var User = mongoose.model('User');
var api = stest('http://localhost:3000');
var config = require('../config');

describe('User Controller Unit Tests:', function(){
    var token = null;
    var user = null;
    var userID = null;

    before(function(done){
        user = {
            username: 'thetesterman7',
            password: '553399',
            email: 'tester@te9sterman.com'
        };
        done();
    });

    describe('Testing the POST Creation of a User', function(){

        it('Should be able create user with out any problems', function(done){

            api.post('/api/user')
                .set('Content-Type', 'application/x-www-form-urlencoded')
                .set('x-api-key', config.apiKey)
                .send(user)
                .expect(201)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                    should.not.exist(err);
                    res.body.should.have.property('success', true);

                    res.body.data.should.have.property('id');
                    res.body.data.should.have.property('username');
                    res.body.data.should.have.property('username', user.username);

                    res.body.should.have.property('token');

                    userID = res.body.data.id;

                    done();
                });
        });

    });

    after(function(done){
        User
            .findByIdAndRemove(userID)
            .exec(
                function(err, user) {
                    done();
                }
            );
    })

});