import '../../../../common/menu/menu.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../generated/locales.g.dart';
import '../../../interface/command.dart';
import 'init_pattern.dart';

class InitCommand extends Command {
  @override
  String get commandName => 'init';

  @override
  Future<void> execute() async {
    await createInitPattern();

    final nullSafeMenu = Menu(
        [LocaleKeys.options_yes.tr, LocaleKeys.options_no.tr],
        title: LocaleKeys.ask_use_null_safe.tr);
    final nullSafeMenuResult = nullSafeMenu.choose();

    var useNullSafe = nullSafeMenuResult.index == 0;

    if (useNullSafe) {
      await ShellUtils.activatedNullSafe();
    } else {
      await ShellUtils.flutterAnalyze();
    }
  }

  @override
  String? get hint => Translation(LocaleKeys.hint_init).tr;

  @override
  bool validate() {
    super.validate();
    return true;
  }

  @override
  String? get codeSample => LogService.code('ftc init');

  @override
  int get maxParameters => 0;
}
