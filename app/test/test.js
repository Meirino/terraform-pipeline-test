const assert = require('assert');
const api_controller = require('../controllers/API_controller');


describe('API Controller', function () {
    describe('Hello World', function () {
        it('Should return a "hello world" string', () => {
            assert.equal(api_controller.hello_world(), 'hello world');
        });
    });
});