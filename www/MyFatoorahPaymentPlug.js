var exec = require('cordova/exec');

exports.presentPaymentModule = function (arg0, success, error) {
    exec(success, error, 'MyFatoorahPaymentPlug', 'presentPaymentModule', [arg0]);
};
