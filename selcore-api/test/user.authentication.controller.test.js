var app = require('../app');
//require('../app_api/models/db.js');
var request = require('supertest');
var should = require('should');
var mongoose = require('mongoose');
var Particle = mongoose.model('Particle');
var User = mongoose.model('User');
var api = request('http://localhost:3000');
var config = require('../config');

//create test for duplicate username and emails

describe('User Authentication Tests:', function(){
    var token = null;
    var user = null;
    var userID = null;

    before(function(done){
        user = new User({
            username: 'tester',
            password: '553399',
            email: 'tester@test.com'
        });
        user.save(function(err){
           done();
        });
    });

    describe('Testing the Authentication POST in User Controller - Login of User Valid', function(){

        it('Should be able authenticate without any problems', function(done){
            api
                .post('/api/login')
                .set('Accept', 'application/x-www-form-urlencoded')
                .set('x-api-key', config.apiKey)
                .send({ username: user.username, password: '553399'})
                .expect(201)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                    should.not.exist(err);
                    token = res.body.token;
                    should.exist(token);
                    done();
                });
        });

        it('Should be able to get authentication token', function(done) {
            should.exist(token);
            done();
        });

    });

    describe('Testing the Authentication POST in User Controller - Login of User with Invalid API Key', function(){

        it('Should not be able to authenticate', function(done){
            api
                .post('/api/login')
                .set('Accept', 'application/x-www-form-urlencoded')
                .set('x-api-key', 'dfefef')
                .send({ username: user.username, password: '553399'})
                .expect(401)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                    should.exist(res.body.message);
                    done();
                });
        });

    });

    describe('Testing the Authentication POST in User Controller - Login of User with No API Key', function(){

        it('Should not be able to authenticate', function(done){
            api
                .post('/api/login')
                .set('Accept', 'application/x-www-form-urlencoded')
                .set('x-api-key', '')
                .send({ username: user.username, password: '553399'})
                .expect(403)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                    should.exist(res.body.message);
                    done();
                });
        });

    });


    describe('Testing the Authentication POST in User Controller - Login of User with No Username', function(){

        it('Should not be able to authenticate', function(done){
            api
                .post('/api/login')
                .set('Accept', 'application/x-www-form-urlencoded')
                .set('x-api-key', config.apiKey)
                .send({ username: '', password: '553399'})
                .expect(401)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                    should.exist(res.body.message);
                    done();
                });
        });

    });

    describe('Testing the Authentication POST in User Controller - Login of Invalid Username', function(){

        it('Should not be able to authenticate', function(done){
            api
                .post('/api/login')
                .set('Accept', 'application/x-www-form-urlencoded')
                .set('x-api-key', config.apiKey)
                .send({ username: 'no_possible_way_this_name_exisits', password: '553399'})
                .expect(401)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                    should.exist(res.body.message);
                    done();
                });
        });

    });


    describe('Testing the Authentication POST in User Controller - Login of User Invalid Password', function(){

        it('Should be able authenticate without any problems', function(done){
            api
                .post('/api/login')
                .set('Accept', 'application/x-www-form-urlencoded')
                .set('x-api-key', config.apiKey)
                .send({ username: user.username, password: '444444'})
                .expect(401)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                    should.exist(res.body.message);
                    done();
                });
        });

    });

    after(function(done){
        user.remove(function() {
            done();
        });
    })

});