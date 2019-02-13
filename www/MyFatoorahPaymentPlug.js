var exec = require('cordova/exec');

module.exports.presentPaymentModule = function (arg0, success, error) {
    exec(success, error, 'MyFatoorahPaymentPlug', 'presentPaymentModule', [arg0]);
};

module.exports.testMethod =  function (arg0, success, error) {
    exec(success, error, 'MyFatoorahPaymentPlug', 'testMethod', [arg0]);
};
