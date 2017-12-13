'use strict';

var setDetectionInterval = function (seconds) {
  return function () {
    chrome.idle.setDetectionInterval(seconds);
  };
};

var queryState = function (seconds) {
  return function (cb) {
    return function () {
      chrome.idle.queryState(seconds, function (idleState) {
        cb(idleState)();
      });
    };
  };
};

var onStateChanged = function (cb) {
  return function () {
    chrome.idle.onStateChanged.addListener(function (idleState) {
      cb(idleState)();
    });
  };
};

exports.setDetectionInterval = setDetectionInterval;
exports.queryState = queryState;
exports.onStateChanged = onStateChanged;
exports.idle_state_active = "active";
exports.idle_state_idle = "idle";
exports.idle_state_locked = "locked";
