var exec = require('cordova/exec');

module.exports = {
  Scope: {
    FullName: 0,
    Email: 1
  },
  Operation: {
    Implicit: 0,
    Login: 1,
    Refresh: 2,
    Logout: 3,
  },
  CredentialState: {
    Revoked: 0,
    Authorized: 1,
    NotFound: 2,
    Transferred: 3
  },
  isAvailable: function() {
    return new Promise(function(resolve, reject) {
      cordova.exec(
          resolve,
          reject,
          'SignInWithApple',
          'isAvailable',
          []
      );
    });
  },
  request: function(options) {
    return new Promise(function(resolve, reject) {
      cordova.exec(
          resolve,
          reject,
          'SignInWithApple',
          'request',
          [options]
      );
    });
  },
  getCredentialState: function(options) {
    return new Promise(function(resolve, reject) {
      cordova.exec(
          resolve,
          reject,
          'SignInWithApple',
          'getCredentialState',
          [options]
      );
    });
  }
};
