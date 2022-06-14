import 'dart:io';

import 'package:pubspec/pubspec.dart';
import 'package:version/version.dart' as v;

import '../../../core/internationalization.dart';
import '../../../exception_handler/exceptions/cli_exception.dart';
import '../../../extensions.dart';
import '../../../generated/locales.g.dart';
import '../../menu/menu.dart';
import '../asset_fill/converter.dart';
import '../asset_fill/get_paths.dart';
import '../logger/log_utils.dart';
import '../pub_dev/pub_dev_api.dart';
import '../shell/shel.utils.dart';
import 'yaml_to.string.dart';

// ignore: avoid_classes_with_only_static_members
class PubspecUtils {
  static final _pubspecFile = File('pubspec.yaml');

  static PubSpec get pubSpec =>
      PubSpec.fromYamlString(_pubspecFile.readAsStringSync());

  /// separtor
  static final _mapSep = _PubValue<String>(() {
    var yaml = pubSpec.unParsedYaml!;
    if (yaml.containsKey('flutter_template_cli')) {
      if ((yaml['flutter_template_cli'] as Map).containsKey('separator')) {
        return (yaml['flutter_template_cli']['separator'] as String?) ?? '';
      }
    }

    return '';
  });

  static String? get separatorFileType => _mapSep.value;

  static final _mapName = _PubValue<String>(() => pubSpec.name?.trim() ?? '');

  static String? get projectName => _mapName.value;

  static final _extraFolder = _PubValue<bool?>(
    () {
      try {
        var yaml = pubSpec.unParsedYaml!;
        if (yaml.containsKey('flutter_template_cli')) {
          if ((yaml['flutter_template_cli'] as Map).containsKey('sub_folder')) {
            return (yaml['flutter_template_cli']['sub_folder'] as bool?);
          }
        }
      } on Exception catch (_) {}
      // ignore: avoid_returning_null
      return null;
    },
  );

  static bool? get extraFolder => _extraFolder.value;

  static Future<bool> addDependencies(String package,
      {String? version,
      bool isDev = false,
      bool runPubGet = true,
      bool isPubSiteCN = true}) async {
    var pubSpec = PubSpec.fromYamlString(_pubspecFile.readAsStringSync());

    if (containsPackage(package, isDev)) {
      LogService.info(
          LocaleKeys.ask_package_already_installed.trArgs([package]),
          false,
          false);
      final menu = Menu(
        [
          LocaleKeys.options_yes.tr,
          LocaleKeys.options_no.tr,
        ],
      );
      final result = menu.choose();
      if (result.index != 0) {
        return false;
      }
    }

    version = version == null || version.isEmpty
        ? await PubDevApi.getLatestVersionFromPackage(package,
            isPubSiteCN: isPubSiteCN)
        : '^$version';
    if (version == null) return false;
    if (isDev) {
      pubSpec.devDependencies[package] = HostedReference.fromJson(version);
    } else {
      pubSpec.dependencies[package] = HostedReference.fromJson(version);
    }
    _savePub(pubSpec);
    if (runPubGet) await ShellUtils.pubGet();
    LogService.success(LocaleKeys.success_package_installed.trArgs([package]));
    return true;
  }

  static Future<void> modifyFlutterAssets() async {
    var pubSpec = PubSpec.fromYamlString(_pubspecFile.readAsStringSync());
    // get structure
    final dir = Directory('assets');
    var dirs = await GetPaths.getDirs(dir.path);
    // convert to strings
    final converter = Converter(dirs: dirs);
    converter.doConvert();
    final paths = converter.result;
    // write them to yaml
    _writeDataToFlutterAssetsYAML(pubSpec, paths);
    _savePub(pubSpec);
  }

  static void _writeDataToFlutterAssetsYAML(
      PubSpec pubSpec, List<String> paths) {
    try {
      var yaml = pubSpec.unParsedYaml;
      if (yaml != null && yaml.containsKey('flutter')) {
        var flutterMap = yaml['flutter'] as Map;
        final newFlutterMap = {...flutterMap, 'assets': paths};
        yaml['flutter'] = newFlutterMap;
      }
    } on Exception catch (_) {}
  }

  static void removeDependencies(String package,
      {bool isDev = false, bool logger = true}) {
    if (logger) LogService.info('Removing package: "$package"');

    if (containsPackage(package, isDev)) {
      var dependencies = pubSpec.dependencies;
      var devDependencies = pubSpec.devDependencies;

      dependencies.removeWhere((key, value) => key == package);
      devDependencies.removeWhere((key, value) => key == package);
      var newPub = pubSpec.copy(
        devDependencies: devDependencies,
        dependencies: dependencies,
      );
      _savePub(newPub);
      if (logger) {
        LogService.success(
            LocaleKeys.success_package_removed.trArgs([package]));
      }
    } else if (logger) {
      LogService.info(LocaleKeys.info_package_not_installed.trArgs([package]));
    }
  }

  static bool containsPackage(String package, [bool isDev = false]) {
    var dependencies = isDev ? pubSpec.devDependencies : pubSpec.dependencies;
    return dependencies.containsKey(package.trim());
  }

  static bool get nullSafeSupport => !pubSpec.environment!.sdkConstraint!
      .allowsAny(HostedReference.fromJson('<2.12.0').versionConstraint);

  static v.Version? getPackageVersion(String package) {
    if (containsPackage(package)) {
      var version = pubSpec.allDependencies[package]!;
      try {
        final json = version.toJson();
        if (json is String) {
          return v.Version.parse(json);
        }
        return null;
      } on FormatException catch (_) {
        return null;
      } on Exception catch (_) {
        rethrow;
      }
    } else {
      throw CliException(
          LocaleKeys.info_package_not_installed.trArgs([package]));
    }
  }

  static void _savePub(PubSpec pub) {
    var value = CliYamlToString().toYamlString(pub.toJson());
    _pubspecFile.writeAsStringSync(value);
  }
}

/// avoids multiple reads in one file
class _PubValue<T> {
  final T Function() _setValue;
  bool _isChecked = false;
  T? _value;

  /// takes the value of the file,
  /// if not already called it will call the first time
  T? get value {
    if (!_isChecked) {
      _isChecked = true;
      _value = _setValue.call();
    }
    return _value;
  }

  _PubValue(this._setValue);
}
