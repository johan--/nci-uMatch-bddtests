/**
 * Created by raseel.mohamed on 6/3/16
 */

var chai, chaiAsPromised, World
chai = require('chai');
chaiAsPromised = require ('chai-as-promised');

World = function World(callback) {
    chai.use(chaiAsPromised);
    global.expect = chai.expect;
    global.assert = chai.assert;
    callback;
};

module.exports.World = World;
