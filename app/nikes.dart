import 'package:chrome/chrome_app.dart' as chrome;

import 'lib/terminal.dart' as terminal;
import 'dart:async';

void main() {
  List<chrome.DeviceInfo> serialList;

  terminal.Hterm.init();
  (new Future.delayed(const Duration(milliseconds: 500), () => "500")).then((_) {
    chrome.serial.getDevices().then((infoList) {
      serialList = infoList;
      infoList.forEach((info) {
        print(info.path);
      });
    }).then((_) {
      terminal.BeagleObject.Println('connect 115200' + serialList.first.path);
      var option = new chrome.ConnectionOptions(name: 'nike', bitrate: 115200);
      return chrome.serial.connect(serialList.first.path, option);
    }).then((connectionInfo) {
      terminal.BeagleObject.Println('success to connected to : ' + connectionInfo.name);
    });
  });
}
