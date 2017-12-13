'use strict';

var get = function (tabId) {
  return function (cb) {
    return function () {
      chrome.tabs.get(tabId, function (tab) {
        cb(tab.url)();
      });
    };
  };
};

var getWindowActive = function (windowId) {
  return function (cb) {
    return function () {
      chrome.tabs.query({ windowId: windowId, active: true }, function (res) {
        cb(res[0].id)();
      });
    };
  };
};

var onActivated = function (cb) {
  return function () {
    chrome.tabs.onActivated.addListener(function (activeInfo) {
      cb(activeInfo.tabId)(activeInfo.windowId)();
    });
  };
};

var onRemoved = function (cb) {
  return function () {
    chrome.tabs.onRemoved.addListener(function (tabId, removeInfo) {
      cb(tabId)(removeInfo.windowId)(removeInfo.isWindowClosing)();
    });
  };
};

var onUpdated = function (cb) {
  return function () {
    chrome.tabs.onUpdated.addListener(function (tabId, changeInfo, tab) {
      cb(tabId)(tab.url)();
    });
  };
};

exports.get = get;
exports.getWindowActive = getWindowActive;
exports.onActivated = onActivated;
exports.onRemoved = onRemoved;
exports.onUpdated = onUpdated;
exports.tab_id_none = chrome.tabs.TAB_ID_NONE;
