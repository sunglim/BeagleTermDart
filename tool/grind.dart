// Sungguk Lim(limasdf@gmail.com) all rights reserved.

import 'dart:io';

import 'package:csp_fixer/csp_fixer.dart' as CspFix;
import 'package:grinder/grinder.dart';

final Directory BUILD_DIR = new Directory('build');
final Directory APP_DIR = new Directory('app');

void main([List<String> args]) {
  task('setup', setup);
  task('deploy', deploy, ['setup']);

  startGrinder(args);
}

void _compile([GrinderContext context]) {
  // Generate dart.js (doens't support eval), but actually use precompiled
  // version(support eval) from chrome-dart bootstrap.
  List<String> arg = ['index.dart', '--out=index.dart.js'];
  context.log('Run: ' + _dart2jsName() + ' ' + arg.join(' '));
  ProcessResult result =
      Process.runSync(_dart2jsName(), arg, workingDirectory: BUILD_DIR.path);
  if (result.stdout != null && !result.stdout.isEmpty) {
    context.log(result.stdout);
  }
  if (result.stderr != null && !result.stderr.isEmpty) {
     context.log(result.stderr);
   }
  // TODO(sunglim) : Remove deps, map and js output.
}

void setup(GrinderContext context) {
  Pub.get(context);

  // copy from ./packages to ./app/packages
  copyDirectory(getDir('packages'), getDir('app/packages'), context);
  CspFix.Fix(getDir('app/packages'));
}

void deploy([GrinderContext context]) {
  if (context != null) {
    context.log("Copy App directory to BUILD directory");
  }
  if (BUILD_DIR.existsSync()) {
    BUILD_DIR.deleteSync(recursive: true);
  }

  BUILD_DIR.createSync();
  copyDirectory(APP_DIR, BUILD_DIR);

  _compile(context);
}

String _dart2jsName() {
  return (Platform.isWindows) ? 'dart2js.bat' : 'dart2js';
}
