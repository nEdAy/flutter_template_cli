import '../../../core/internationalization.dart';
import '../../../functions/version/check_dev_version.dart';
import '../../../generated/locales.g.dart';
import '../logger/log_utils.dart';
import '../shell/shel.utils.dart';

class PubspecLock {
  static Future<String?> getVersionCli({bool disableLog = false}) async {
    try {
      var version = '0.0.0';
      var pubGlobalListCliResult = await ShellUtils.getPubGlobalList();
      var pubGlobalList = pubGlobalListCliResult[0].stdout;
      if (pubGlobalList != null &&
          pubGlobalList is String &&
          pubGlobalList.contains('flutter_template_cli')) {
        pubGlobalList.split('\n').forEach((depWithVersion) {
          if (depWithVersion.contains('flutter_template_cli')) {
            version = depWithVersion.split(' ')[1];
          }
        });
      }
      if (version == '0.0.0') {
        if (isDevVersion()) {
          if (!disableLog) {
            LogService.info('Development version');
          }
        }
      }
      return version;
    } on Exception catch (_) {
      if (!disableLog) {
        LogService.error(
            Translation(LocaleKeys.error_cli_version_not_found).tr);
      }
      return null;
    }
  }
}
