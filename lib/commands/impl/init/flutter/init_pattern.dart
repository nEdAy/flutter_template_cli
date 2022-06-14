import '../../../../common/menu/menu.dart';
import '../../../../common/utils/logger/log_utils.dart';
import '../../../../common/utils/shell/shel.utils.dart';
import '../../../../core/internationalization.dart';
import '../../../../functions/create/create_main.dart';
import '../../../../generated/locales.g.dart';
import '../../install/install_pattern.dart';

Future<void> createInitPattern() async {
  var canContinue = await createMain();
  if (!canContinue) return;

  await ShellUtils.copyFromTemplate();

  await modifyFlutterAssets();

  final pubSiteMenu = Menu(['pub.flutter-io.cn', 'pub.dev'],
      title: LocaleKeys.ask_use_pub_site.tr);
  final pubSiteMenuResult = pubSiteMenu.choose();

  var isPubSiteCN = pubSiteMenuResult.index == 0;

  await installDependencies(isPubSiteCN: isPubSiteCN);
  await installDevDependencies(isPubSiteCN: isPubSiteCN);

  await cleanDependencies();

  await ShellUtils.pubGet();

  await ShellUtils.buildRunnerBuild();

  LogService.success(Translation(LocaleKeys.success_pattern_generated));
}
