import 'package:http/http.dart';
import 'package:recase/recase.dart';

import '../../core/generator.dart';

mixin ArgsMixin {
  final List<String> _args = FlutterTemplateCli.arguments;

  /// all arguments
  ///
  /// example run
  /// `ftc create module`
  ///
  /// ```
  /// print(args); // [module]
  /// ```
  List<String> args = _getArgs();

  /// all flags
  ///
  /// example run
  /// `ftc sort . --skipRename --relative`
  ///
  /// ```
  /// print(flags); // [--skipRename, --relative]
  /// ```
  List<String> flags = _getFlags();

  /// return parameter `name`
  ///
  /// example run
  /// `ftc create gx`
  /// `ftc create app gx`
  /// `ftc create module gx`
  ///
  /// ```
  /// print(name); // gx
  /// ```
  String get name {
    var args = List.of(_args);
    _removeDefaultArgs(args);
    if (args.length > 1) {
      if (args[0] == 'create') {
        var name = args[1];
        if (name == 'app' || name == 'module') {
          if (args.length > 2) {
            name = args[2];
          } else {
            name = '.';
          }
        }
        return name.isEmpty ? '.' : name.snakeCase;
      }
    }
    return '.';
  }

  /// return parameter `type`
  ///
  /// example run
  /// `ftc create gx`
  /// `ftc create app gx`
  /// `ftc create module gx`
  ///
  /// ```
  /// print(type); // app
  /// print(type); // app
  /// print(type); // module
  /// ```
  String get type {
    var args = List.of(_args);
    _removeDefaultArgs(args);
    if (args.length > 1) {
      if (args[0] == 'create') {
        var type = args[1];
        if (type == 'app' || type == 'module') {
          return type;
        }
      }
    }
    return 'app';
  }

  /// return [true] if contains flags
  ///
  /// example run
  /// `ftc sort . --skipRename`
  ///
  /// ```
  /// print(containsArg('--skipRename')); // true
  /// print(containsArg('--relative')); // false
  /// ```
  bool containsArg(String flag) {
    return _args.contains(flag);
  }
}

List<String> _getArgs() {
  var args = List.of(FlutterTemplateCli.arguments);
  _removeDefaultArgs(args);
  args.removeWhere((element) => element.startsWith('-'));
  return args;
}

void _removeDefaultArgs(List<String> args) {
  var defaultArgs = ['on', 'from', 'with'];

  for (var arg in defaultArgs) {
    var indexArg = args.indexWhere((element) => (element == arg));
    if (indexArg != -1 && indexArg < args.length) {
      args.removeAt(indexArg);
      if (indexArg < args.length) {
        args.removeAt(indexArg);
      }
    }
  }
}

List<String> _getFlags() {
  var args = List.of(FlutterTemplateCli.arguments);
  var flags = args.where((element) {
    return element.startsWith('-') && element != '--debug';
  }).toList();

  return flags;
}

int _getIndexArg(String arg) {
  return FlutterTemplateCli.arguments.indexWhere((element) => element == arg);
}

String _getArg(String arg) {
  var index = _getIndexArg(arg);
  if (index != -1) {
    if (index + 1 < FlutterTemplateCli.arguments.length) {
      index++;
      return FlutterTemplateCli.arguments[index];
    } else {
      throw ClientException("the '$arg' argument is empty");
    }
  }

  return '';
}
