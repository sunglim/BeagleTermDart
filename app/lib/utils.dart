library beagle.utils;

import 'dart:convert';

import 'package:chrome/chrome_app.dart' as chrome;

String ArraybufferToString(chrome.ArrayBuffer buffer) {
  // TODO(sunglim): Write Test. [48, 56, 49, 51]
  AsciiDecoder ad = new AsciiDecoder();
  return ad.convert(buffer.getBytes());
}

chrome.ArrayBuffer StringToArraybuffer(String str) {
  return new chrome.ArrayBuffer.fromBytes(UTF8.encode(str));
}