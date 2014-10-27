chrome.app.runtime.onLaunched.addListener(function(launchData) {
  var connectedSerialId = -1;
  chrome.app.window.create(
    'index.html',
    {
      'id': '_mainWindow', 'bounds': {'width': 1024, 'height': 768 }
    },
    function(win) {
      win.contentWindow.AddConnectedSerialId = function(id) {
        connectedSerialId = id;
      };
      win.onClosed.addListener(function() {
        chrome.serial.disconnect(connectedSerialId, function () {
        });
      });
    }
   );
});
