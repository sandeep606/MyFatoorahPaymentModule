var exec = require('cordova/exec');

module.exports.initialisePaymentDetails = function (arg0, success, error) {
    exec(success, error, 'MyFatoorahPaymentPlug', 'initialisePaymentDetails', [arg0]);
};

module.exports.payNow = function (arg0, success, error) {
    exec(success, error, 'MyFatoorahPaymentPlug', 'payNow', [arg0]);
};
