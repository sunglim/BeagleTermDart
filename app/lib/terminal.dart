library beagle.terminal;

import 'dart:js' as js;
import 'dart:html';

Beagle BeagleObject = null;

class Hterm {
  static void init() {
    var htermJs = js.context['hterm'];
    htermJs.callMethod('init', [_htermInitCallback]);
  }

  static void _htermInitCallback() {
    // 1. Create an instance of hterm.Terminal:
    // var t = new hterm.Terminal(opt_profileName);
    var terminalObject = new js.JsObject(js.context['hterm']['Terminal'], ['opt_profileName']);

    // Now we can listen #terminal div size changed event.
    terminalObject.callMethod('decorate', [querySelector("#terminal")]);

    //Timer.run(terminalInitialize);
    terminalObject.callMethod('setCursorPosition', [0, 0]);
    terminalObject.callMethod('setCursorVisible', [true]);

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
