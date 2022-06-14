import 'dart:io';

import 'package:path/path.dart';

import '../../common/utils/logger/log_utils.dart';
import '../../common/utils/pubspec/pubspec_utils.dart';
import '../../core/internationalization.dart';
import '../../core/structure.dart';
import '../../generated/locales.g.dart';
import '../sorter_imports/sort.dart';

/// Create or edit the contents of a file
File writeFile(String path, String content,
    {bool overwrite = false,
    bool skipFormatter = false,
    bool logger = true,
    bool skipRename = false,
    bool useRelativeImport = false}) {
  var _file = File(Structure.replaceAsExpected(path: path));

  if (!_file.existsSync() || overwrite) {
    if (!skipFormatter) {
      if (path.endsWith('.dart')) {
        try {
          content = sortImports(
            content,
            renameImport: !skipRename,
            filePath: path,
            useRelative: useRelativeImport,
          );
        } on Exception catch (_) {
          if (_file.existsSync()) {
            LogService.info(LocaleKeys.error_invalid_dart.trArgs([_file.path]));
          }
          rethrow;
        }
      }
    }
    if (!skipRename && _file.path != 'pubspec.yaml') {
      var separatorFileType = PubspecUtils.separatorFileType!;
      if (separatorFileType.isNotEmpty) {
        _file = _file.existsSync()
            ? _file = _file
                .renameSync(replacePathTypeSeparator(path, separatorFileType))
            : File(replacePathTypeSeparator(path, separatorFileType));
      }
    }

    _file.createSync(recursive: true);
    _file.writeAsStringSync(content);
    if (logger) {
      LogService.success(
        LocaleKeys.success_file_created.trArgs(
          [basename(_file.path), _file.path],
        ),
      );
    }
  }
  return _file;
}

/// Replace the file name separator
String replacePathTypeSeparator(String path, String separator) {
  if (separator.isNotEmpty) {
    var index = path.indexOf(RegExp(r'controller.dart|model.dart|provider.dart|'
        'binding.dart|view.dart|widget.dart|repository.dart'));
    if (index != -1) {
      var chars = path.split('');
      index--;
      chars.removeAt(index);
      if (separator.length > 1) {
        chars.insert(index, separator[0]);
      } else {
        chars.insert(index, separator);
      }
      return chars.join();
    }
  }

  return path;
}
