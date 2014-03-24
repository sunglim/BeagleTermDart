library beagle.terminal;

import 'package:js/js.dart' as jsdart;
import 'dart:js' as js;
import 'dart:html';

Beagle BeagleObject = null;

class Hterm {
  static void init() {
    var htermJs = jsdart.context['hterm'];
    var initJs = htermJs['init'];
    initJs(_htermInitCallback);
  }

  static void _htermInitCallback() {
       // Useful for console debugging.
       //window.term_ = terminal;
    var htermJs = js.context['hterm']['Terminal'];

    js.JsObject terminalObject = new js.JsObject(htermJs, ['nike']);

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

  Create(argv) {
    ioFunction = argv['io'];
    io = null;
    argv_ = null;
    portInfo_ = null;
  }

  void run() {
    this.portInfo_ = null;
    //Println('nikeadidas');
  }
}