import '../../../common/utils/logger/log_utils.dart';
import '../../../common/utils/pubspec/pubspec_utils.dart';

const dependencies = [
  'cupertino_icons',
  'get',
  'dio',
  'retrofit',
  'dio_http_formatter',
  'network_inspector',
  'json_annotation',
  'logger',
  'bot_toast',
  'sentry'
];

const devDependencies = [
  'flutter_lints',
  'build_runner',
  'retrofit_generator',
  'json_serializable'
];

Future<void> modifyFlutterAssets() async {
  LogService.info('Modifying flutter asset …');
  await PubspecUtils.modifyFlutterAssets();
}

Future<void> installDependencies(
    {bool runPubGet = false, bool isPubSiteCN = true}) async {
  for (var dependency in dependencies) {
    PubspecUtils.removeDependencies(dependency, logger: false);
    await PubspecUtils.addDependencies(dependency,
        runPubGet: runPubGet, isPubSiteCN: isPubSiteCN);
  }
}

Future<void> installDevDependencies(
    {bool runPubGet = false, bool isPubSiteCN = true}) async {
  for (var devDependency in devDependencies) {
    PubspecUtils.removeDependencies(devDependency, isDev: true, logger: false);
    await PubspecUtils.addDependencies(devDependency,
        isDev: true, runPubGet: runPubGet, isPubSiteCN: isPubSiteCN);
  }
}

Future<void> cleanDependencies() async {
  PubspecUtils.removeDependencies('lints', isDev: true, logger: false);
}
