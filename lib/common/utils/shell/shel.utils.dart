import 'dart:io';

import 'package:process_run/shell_run.dart';

import '../../../core/generator.dart';
import '../../../core/internationalization.dart';
import '../../../generated/locales.g.dart';
import '../logger/log_utils.dart';
import '../pub_dev/pub_dev_api.dart';
import '../pubspec/pubspec_lock.dart';

class ShellUtils {
  static Future<List<ProcessResult>> getPubGlobalList() async {
    return await run('dart pub global list', verbose: false);
  }

  static Future<void> copyFromTemplate() async {
    LogService.info('Running `git clone` …');
    await run('git clone https://github.com/nEdAy/flutter-getx-with-null-safety-template.git .template',
        verbose: true);

    await run('mv .template/lib lib', verbose: false);
    await run('mv .template/assets assets', verbose: false);
    await run('rm -rf .template', verbose: false);

    LogService.success('Copying from template success!');
  }

  static Future<void> pubGet() async {
    LogService.info('Running `flutter pub get` …');
    await run('flutter pub get', verbose: true);
  }

  static Future<void> buildRunnerBuild() async {
    LogService.info('Running `flutter packages pub run build_runner build` …');
    await run('flutter packages pub run build_runner build', verbose: true);
  }

  static Future<void> flutterAnalyze() async {
    LogService.info('Running `flutter analyze` …');
    await run('flutter analyze', verbose: true);
  }

  static Future<void> activatedNullSafe() async {
    await run('dart migrate --apply-changes --skip-import-check',
        verbose: true);
  }

  static Future<void> flutterCreateApp(
    String path,
    String? org,
    String iosLang,
    String androidLang,
  ) async {
    LogService.info('Running `flutter create app $path` …');

    await run(
        'flutter create -t app --no-pub -i $iosLang -a $androidLang --org $org'
        ' "$path"',
        verbose: true);
  }

  static Future<void> flutterCreatePlugin(
    String path,
    String? org,
    String iosLang,
    String androidLang,
  ) async {
    LogService.info('Running `flutter create plugin $path` …');

    await run(
        'flutter create -t plugin --no-pub -i $iosLang -a $androidLang --org $org'
        ' "$path"',
        verbose: true);
  }

  static Future<void> flutterCreatePackage(
    String path,
    String? org,
  ) async {
    LogService.info('Running `flutter create package $path` …');

    await run(
        'flutter create -t package --no-pub --org $org'
        ' "$path"',
        verbose: true);
  }

  static Future<void> flutterCreateModule(
    String path,
    String? org,
  ) async {
    LogService.info('Running `flutter create module $path` …');

    await run(
        'flutter create -t module --no-pub --org $org'
        ' "$path"',
        verbose: true);
  }

  static Future<void> update(
      [bool isGit = false, bool forceUpdate = false]) async {
    isGit = FlutterTemplateCli.arguments.contains('--git');
    forceUpdate = FlutterTemplateCli.arguments.contains('-f');
    if (!isGit && !forceUpdate) {
      var versionInPubDev =
          await PubDevApi.getLatestVersionFromPackage('flutter_template_cli');

      var versionInstalled = await PubspecLock.getVersionCli(disableLog: true);

      if (versionInstalled == versionInPubDev) {
        return LogService.info(
            Translation(LocaleKeys.info_cli_last_version_already_installed.tr)
                .toString());
      }
    }

    LogService.info('Upgrading flutter_template_cli …');

    try {
      if (Platform.script.path.contains('flutter')) {
        if (isGit) {
          await run(
              'flutter pub global activate -sgit https://github.com/nEdAy/flutter_template_cli/',
              verbose: true);
        } else {
          await run('flutter pub global activate flutter_template_cli',
              verbose: true);
        }
      } else {
        if (isGit) {
          await run(
              'flutter pub global activate -sgit https://github.com/nEdAy/flutter_template_cli/',
              verbose: true);
        } else {
          await run('flutter pub global activate flutter_template_cli',
              verbose: true);
        }
      }
      return LogService.success(LocaleKeys.success_update_cli.tr);
    } on Exception catch (err) {
      LogService.info(err.toString());
      return LogService.error(LocaleKeys.error_update_cli.tr);
    }
  }
}
