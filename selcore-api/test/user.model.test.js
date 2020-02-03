require('../app_api/models/db.js');
var should = require('should');
var mongoose = require('mongoose');
var User = mongoose.model('User');

describe('User Model Unit Tests:', function(){
    var user = null;
    var particle = null;

    beforeEach(function(done){

        user = new User({
           username: 'testermodel',
           password: '553399',
           email: 'testermodel@tester.com'
        });
        done();
    });

    describe('Testing the save method', function(){

        it('Should be able to save without problems', function(done){
            user.save(function(err){
                should.not.exist(err);
                done();
            });
        });

        it('Should not be able to save an article without a title', function(done){
            user.username = '';
            user.save(function(err){
                should.exist(err);
                done();
            });
        });

    });

    afterEach(function(done){
        user.remove(function() {
            done();
        });
    })

});






