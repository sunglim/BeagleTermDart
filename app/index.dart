import 'dart:async';
import 'dart:html';

import 'package:chrome/chrome_app.dart' as chrome;
import 'package:paper_elements/paper_button.dart';
import 'package:paper_elements/paper_dialog.dart';
import 'package:paper_elements/paper_dialog_transition.dart';
import 'lib/terminal.dart' as terminal;

void main() {
  List<chrome.DeviceInfo> serialList;

  terminal.Hterm.init();

  ConnectionDialog dialog = ConnectionDialog.Instance();
  dialog.LoadBitrate();

  /*
  (new Future.delayed(const Duration(milliseconds: 500), () => "500")).then((_) {
    chrome.serial.getDevices().then((infoList) {
      serialList = infoList;
      infoList.forEach((info) {
        print(info.path);
      });
    }).then((_) {
      serialList.forEach((item) {
        terminal.BeagleObject.Println('Has ports ' + item.path);
      });
      terminal.BeagleObject.Println('connect 115200' + serialList.first.path);
      var option = new chrome.ConnectionOptions(name: 'nike', bitrate: 115200);
      return chrome.serial.connect(serialList.first.path, option);
    }).then((connectionInfo) {
      terminal.BeagleObject.Println('success to connected to : ' + connectionInfo.name);
    });
  });
  */
}

class ConnectionDialog {
  static ConnectionDialog _instance;

  static ConnectionDialog Instance() {
    if (_instance == null)
      _instance = new ConnectionDialog();
    return _instance;
  }

  ConnectionDialog() {
    _init();
  }

  _init() {
    chrome.serial.getDevices().then((infoList) {
      Element elem = querySelector('#port-picker');
      infoList.forEach((info) {
        print('Has ports ' + info.path);
        elem.appendHtml('<option value="' + info.path + '">' + info.path + '</option>');
      });
    });
  }
  LoadBitrate() {
    chrome.storage.local.get('bit_rate').then((result) {
      SelectElement elem = querySelector('#bitrate-picker');
      elem.value =  result['bit_rate'] != null ? elem.value = result['bit_rate'] : "115200";
    });
  }
  SaveBitrate(bitrate) {
    var obj = {};
    obj['bit_rate'] = bitrate;
    chrome.storage.local.set(obj);
  }
}