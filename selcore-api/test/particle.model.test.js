require('../app_api/models/db.js');
var should = require('should');
var mongoose = require('mongoose');
var Particle = mongoose.model('Particle');
var User = mongoose.model('User');

describe('Particle Model Unit Tests:', function(){
    var user = null;
    var particle = null;


    beforeEach(function(done){
        user = new User({
           username: 'testerted3',
           password: '553399',
           email: 'tester@tester.com3'
        });

        user.save(function(){
           particle = new Particle({
               name: 'xbox',
               description: 'this is cool',
               userID: user._id,
               price: 33.33,
               alive: 1
           });

           done();
        });
    });

    describe('Testing the save method', function(){
        it('Should be able to save without problems', function(){
            particle.save(function(err){
                should.not.exist(err);
            });
        });

        it('Should not be able to save an particle without a name', function(){
            particle.name = '';
            particle.save(function(err){
                should.exist(err);
            });
        });
    });

    afterEach(function(done){
        particle.remove(function() {
            user.remove(function() {
                done();
            }); });

    })

});






