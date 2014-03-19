import 'package:chrome/chrome_app.dart' as chrome;

onReadHandler([chrome.SerialReceiveInfo info]) {
 var nike = info;
}

void main() {
  List<chrome.DeviceInfo> serialList;

  chrome.storage.onChanged.listen((_) {
  });

  chrome.serial.onReceive.listen((_) {
  });
  /*
  chrome.serial.onReceiveError.listen((_){
  });
*/
  chrome.serial.getDevices().then((infoList) {
    serialList = infoList;
    infoList.forEach((info) {
      print(info.path);
    });
  }).then((_) {
    print('connect 115200' + serialList.first.path);
    var option = new chrome.ConnectionOptions(name: 'nike', bitrate: 115200);
    return chrome.serial.connect(serialList.first.path, option);
  }).then((connectionInfo) {
    print('success to connect');
    var ret = connectionInfo;
  });
}

