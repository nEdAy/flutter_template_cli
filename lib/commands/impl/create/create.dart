import 'dart:io';

import 'package:cli_dialog/cli_dialog.dart';
import 'package:path/path.dart' as p;
import 'package:recase/recase.dart';

import '../../../common/menu/menu.dart';
import '../../../common/utils/shell/shel.utils.dart';
import '../../../core/internationalization.dart';
import '../../../core/structure.dart';
import '../../../generated/locales.g.dart';
import '../../interface/command.dart';
import '../init/flutter/init.dart';

class CreateCommand extends Command {
  @override
  String get commandName => 'create';

  @override
  Future<void> execute() async {
    String? nameProject = name;
    if (name == '.') {
      final dialog = CLI_Dialog(questions: [
        [LocaleKeys.ask_name_to_project.tr, 'name']
      ]);
      nameProject = dialog.ask()['name'] as String?;
    }

    var path = Structure.replaceAsExpected(
        path: Directory.current.path + p.separator + nameProject!.snakeCase);
    await Directory(path).create(recursive: true);

    Directory.current = path;

    final dialog = CLI_Dialog(questions: [
      [
        '${LocaleKeys.ask_company_domain.tr} \x1B[33m '
            '${LocaleKeys.example.tr} com.yourCompany \x1B[0m',
        'org'
      ]
    ]);
    var org = dialog.ask()['org'] as String?;

    if (type == 'app' || type == 'plugin') {
      final iosLangMenu =
          Menu(['Swift', 'Objective-C'], title: LocaleKeys.ask_ios_lang.tr);
      final iosResult = iosLangMenu.choose();
      var iosLang = iosResult.index == 0 ? 'swift' : 'objc';

      final androidLangMenu =
          Menu(['Kotlin', 'Java'], title: LocaleKeys.ask_android_lang.tr);
      final androidResult = androidLangMenu.choose();
      var androidLang = androidResult.index == 0 ? 'kotlin' : 'java';

      if (type == 'app') {
        await ShellUtils.flutterCreateApp(path, org, iosLang, androidLang);
      } else if (type == 'plugin') {
        await ShellUtils.flutterCreatePlugin(path, org, iosLang, androidLang);
      }
    } else if (type == 'package') {
      await ShellUtils.flutterCreatePackage(path, org);
    } else if (type == 'module') {
      await ShellUtils.flutterCreateModule(path, org);
    }

    File('test/widget_test.dart').writeAsStringSync('');

    await InitCommand().execute();
  }

  @override
  String? get hint => LocaleKeys.hint_create_project.tr;

  @override
  bool validate() {
    return true;
  }

  @override
  String get codeSample => '''
      ftc create <app-name>;
      ftc create app <app-name>;
      ftc create plugin <plugin-name>;
      ftc create package <package-name>;
      ftc create module <module-name>
''';

  @override
  int get maxParameters => 0;
}
