'use strict';

var onFocusChanged = function (cb) {
  return function () {
    chrome.windows.onFocusChanged.addListener(function (windowId) {
      cb(windowId)();
    });
  };
};

exports.onFocusChanged = onFocusChanged;
exports.window_id_none = chrome.windows.WINDOW_ID_NONE;
