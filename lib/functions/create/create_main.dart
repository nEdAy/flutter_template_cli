import 'dart:io';

import '../../common/menu/menu.dart';
import '../../common/utils/logger/log_utils.dart';
import '../../core/internationalization.dart';
import '../../core/structure.dart';
import '../../generated/locales.g.dart';

Future<bool> createMain() async {
  var _fileModel = Structure.model('', 'init', false);

  var _main = File('${_fileModel.path}main.dart');

  if (_main.existsSync()) {
    final menu = Menu([LocaleKeys.options_yes.tr, LocaleKeys.options_no.tr],
        title: LocaleKeys.ask_lib_not_empty.tr);
    final result = menu.choose();
    if (result.index == 1) {
      LogService.info(LocaleKeys.info_no_file_overwritten.tr);
      return false;
    }
    if (Directory('assets').existsSync()) {
      await Directory('assets').delete(recursive: true);
    }
    if (Directory('lib').existsSync()) {
      await Directory('lib').delete(recursive: true);
    }
  }
  return true;
}
