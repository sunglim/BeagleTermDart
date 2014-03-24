import 'package:chrome/chrome_app.dart' as chrome;

import 'lib/terminal.dart' as terminal;

//Beagle BeagleObject = null;

void main() {
  List<chrome.DeviceInfo> serialList;

  terminal.Hterm.init();

  chrome.serial.onReceive.listen((_) {
  });

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
    terminal.BeagleObject.Println('success to connect');
    var ret = connectionInfo;
  });

}
