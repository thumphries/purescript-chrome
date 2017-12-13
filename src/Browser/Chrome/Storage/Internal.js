'use strict';

var areaGet = function (area) {
  return function (arr) {
    return function (er) {
      return function (cb) {
        return function () {
          area.get(arr, function (res) {
            if (typeof chrome.runtime.lastError !== 'undefined') {
              er(chrome.runtime.lastError);
            } else {
              cb(res)();
            }
          });
        };
      };
    };
  };
};

var areaSet = function (area) {
  return function (obj) {
    return function (er) {
      return function (cb) {
        return function () {
          area.set(obj, function () {
            if (typeof chrome.runtime.lastError !== 'undefined') {
              er(chrome.runtime.lastError);
            } else {
              cb()();
            }
          });
        };
      };
    };
  };
};

exports.local = chrome.storage.local;
exports.sync = chrome.storage.sync;
exports.set = areaSet;
exports.get = areaGet;
