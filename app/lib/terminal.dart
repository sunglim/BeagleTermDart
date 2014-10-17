library beagle.terminal;

import 'dart:js' as js;
import 'dart:html';

Beagle BeagleObject = null;

class Hterm {
  static void init() { 
    //hterm.defaultStorage = new lib.Storage.Chrome(chrome.storage.sync);
    // TODO: Implement with dart. manually patch from hterm.PreferenceManager.
 
    // 1. Create an instance of hterm.Terminal:
    // var t = new hterm.Terminal(opt_profileName);
    var terminalObject = new js.JsObject(js.context['hterm']['Terminal'], ["NIKE"]);

    // Now we can listen #terminal div size changed event.
    terminalObject.callMethod('decorate', [querySelector("#terminal")]);

    // pass the Command instance.
    BeagleObject = new Beagle();
    js.context['Beagle'] = BeagleObject.Create;
    js.context['Beagle']['prototype']['run'] = BeagleObject.run;

    // Beagle.Create will be passed.
    terminalObject.callMethod('runCommandClass', [js.context['Beagle']]);
  }
}

class Beagle {
  Map argv_;
  int io;
  Map portInfo_;
  js.JsFunction ioFunction;

  Beagle() {
   // Hterm.init();
  }

  void Println(String message) {
    if (ioFunction == null)
      return;
    ioFunction.callMethod('println', [message]);
  }

  void Print(String message) {
    if (ioFunction == null)
      return;
    ioFunction.callMethod('print', [message]);
  }

  keystroke(str) {
    print("keystroke:" + str);
    Print(str);
  }

  Create(argv) {
    ioFunction = argv['io'];
    ioFunction['onVTKeystroke'] = this.keystroke;
    ioFunction['sendString'] = this.keystroke;

    io = null;
    argv_ = null;
    portInfo_ = null;
  }

  void run() {
    this.portInfo_ = null;
    //Println('nikeadidas');
  }
}
