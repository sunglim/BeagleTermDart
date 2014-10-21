library beagle.terminal;

import 'dart:js' as js;
import 'dart:html';

Beagle BeagleObject = null;

// Settings to use Hterm.
class Hterm {
  static var instance;
  static void init() { 
    //hterm.defaultStorage = new lib.Storage.Chrome(chrome.storage.sync);
    // TODO: Implement with dart. manually patch from hterm.PreferenceManager.
 
    // 1. Create an instance of hterm.Terminal:
    // var t = new hterm.Terminal(opt_profileName);
    Hterm.instance = new js.JsObject(js.context['hterm']['Terminal'], ["NIKE"]);

    // 2. Decorate. this makes black div.
    // t.decorate(document.querySelector('#terminal'));
    Hterm.instance.callMethod('decorate', [querySelector("#terminal")]);

    // 3. Register a callback which is called when terminal is ready.
    // t.onTerminalReady = function() {
    Hterm.instance['onTerminalReady'] = Hterm.onTerminalReady;
  }
  
  // Called when terminal is ready.
  static onTerminalReady() {
    print('Terminal is ready');
    
    // t.runCommandClass(Crosh, document.location.hash.substr(1));
    // return true;

    // Pass the Command instance.
    BeagleObject = new Beagle();
    js.context['Beagle'] = BeagleObject.Create;
    js.context['Beagle']['prototype']['run'] = BeagleObject.run;

    // Beagle.Create will be passed.
    Hterm.instance.callMethod('runCommandClass', [js.context['Beagle']]);
  }
}

// Interface calss to use Hterm functions.
// To use Hterm APIs, use this class's adapter functions.
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
    print('Beagle::run');
  }
}
