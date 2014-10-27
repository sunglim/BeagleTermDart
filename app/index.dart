import 'dart:async';
import 'dart:html';

import 'package:chrome/chrome_app.dart' as chrome;
import 'lib/terminal.dart' as terminal;
import 'lib/utils.dart' as utils;

void main() {
  List<chrome.DeviceInfo> serialList;

  terminal.Hterm.init();

  ConnectionDialog dialog = ConnectionDialog.Instance();
  dialog.LoadBitrate();
}

class ConnectionDialog {
  SelectElement elem = querySelector('#port-picker');
  SelectElement bitrateElem = querySelector('#bitrate-picker');
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
      infoList.forEach((info) {
        elem.appendHtml('<option value="' + info.path + '">' + info.path + '</option>');
      });
    });

    querySelector("#btnAccept").onClick.listen((_) {
      var option =
          new chrome.ConnectionOptions(name: 'BeagleConnectionId', bitrate: int.parse(bitrateElem.value));
      var portName = elem.value;
      terminal.BeagleObject.Println("Trying connect to " + portName + "...");
      chrome.serial.connect(portName, option).then((connectionInfo) {
        terminal.BeagleObject.setSerialConnection(connectionInfo.connectionId);
        Stream<chrome.SerialReceiveInfo> stream = chrome.serial.onReceive;
        stream.listen((value) {
          terminal.BeagleObject.ReceiveString(utils.ArraybufferToString(value.data));
        });
      });
    });
  }
  LoadBitrate() {
    chrome.storage.local.get('bit_rate').then((result) {
      bitrateElem.value = result['bit_rate'] != null ? result['bit_rate'] : "115200";
    });
  }
  SaveBitrate(bitrate) {
    var obj = {};
    obj['bit_rate'] = bitrate;
    chrome.storage.local.set(obj);
  }
}