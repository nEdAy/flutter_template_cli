import '../../../common/utils/logger/log_utils.dart';
import '../../../common/utils/pubspec/pubspec_utils.dart';
import '../../../common/utils/shell/shel.utils.dart';
import '../../../core/internationalization.dart';
import '../../../exception_handler/exceptions/cli_exception.dart';
import '../../../generated/locales.g.dart';
import '../../interface/command.dart';

class RemoveCommand extends Command {
  @override
  String get commandName => 'remove';

  @override
  Future<void> execute() async {
    for (var package in args) {
      PubspecUtils.removeDependencies(package);
    }
    await ShellUtils.pubGet();
  }

  @override
  String? get hint => Translation(LocaleKeys.hint_remove).tr;

  @override
  bool validate() {
    super.validate();
    if (args.isEmpty) {
      CliException(LocaleKeys.error_no_package_to_remove.tr,
          codeSample: codeSample);
    }
    return true;
  }

  @override
  String? get codeSample => LogService.code('ftc remove http');

  @override
  int get maxParameters => 999;

  @override
  List<String> get alias => ['-rm'];
}
