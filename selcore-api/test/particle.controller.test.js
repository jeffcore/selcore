var app = require('../app');
//require('../app_api/models/db.js');
var request = require('supertest');
var should = require('should');
var mongoose = require('mongoose');
var Particle = mongoose.model('Particle');
var User = mongoose.model('User');
var api = request('http://localhost:3000');
var config = require('../config');

describe('Particle Controller Unit Tests:', function(){
    var token = null;
    var user = null;
    var particle = null;
    var particleID = null;
    var particle_update_data = null;
    before(function(done){
        user = new User({
            username: 'testerted',
            password: '553399',
            email: 'tester@tester.com'
        });

        user.save(function(err){
            particle = new Particle({
                name: 'xbox',
                description: 'this is cool',
                userID: user._id,
                price: 33.33,
                alive: 1
            });

            particle_update_data = {
                name: 'Xbox Updated',
                description: 'This is the new description',
                user_id: user._id,
                price: '22.22'
            };

            particle.save(function(err){
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


    //describe('Testing Authentication', function(){
    //    it('Should be able authenticate with out any problems', function(done){
    //        api
    //            .post('/api/login')
    //            .set('Accept', 'application/x-www-form-urlencoded')
    //            .set('x-api-key', 'aD7WrqSxV8ur7C59Ig6gf72O5El0mz04')
    //            .send({ username: user.username, password: '553399'})
    //            .expect(201)
    //            .expect('Content-Type', /json/)
    //            .end(function(err, res) {
    //                should.not.exist(err);
    //                token = res.body.token;
    //                should.exist(token);
    //                done();
    //            });
    //    });
    //});

    describe('Testing the GET Methods - Get Particle List', function(){

        it('Should be able to get a list of particles', function(done){
            api.get('/api/particle/')
                .set('x-api-key', config.apiKey)
                .set('x-access-token', token)
                .expect(200)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                    //res.body.should.be.an.Array.and.have.lengthOf(1);
                    res.body.should.have.property('data');
                    res.body.data[0].should.have.property('name');
                    done();
                });
        });

    });

    describe('Testing the GET Methods - Get One Particle', function(){

        it('Should be able to get a one particle', function(done){
            api.get('/api/particle/' + particle._id)
                .set('x-api-key', config.apiKey)
                .set('x-access-token', token)
                .expect(200)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                    //res.body.should.be.an.Array.and.have.lengthOf(1);
                    res.body.should.have.property('data');
                    res.body.data.should.have.property('name');
                    done();
                });
        });

    });

    describe('Testing the PUT Methods - Update a Particle', function(){
        it('Should be able to update a particle', function(done){
            api.put('/api/particle/' + particle._id)
                .set('x-api-key', config.apiKey)
                .set('x-access-token', token)
                .send(particle_update_data)
                .expect(200)
                .expect('Content-Type', /json/)
                .end(function(err, res) {
                    //res.body.should.be.an.Array.and.have.lengthOf(1);
                    res.body.data.should.have.property('name', 'Xbox Updated');
                    res.body.data.should.have.property('description', 'This is the new description');
                    res.body.data.should.have.property('price', 22.22);

                    done();
                });
        });

    });


    after(function(done){
        particle.remove(function() {
            user.remove(function() {
                done();
            });
        });

    })

});






