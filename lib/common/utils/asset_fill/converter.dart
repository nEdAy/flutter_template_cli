import '../logger/log_utils.dart';

/// Converts folder structure to a list of strings
class Converter {
  final Map<String, dynamic> _dirs;
  final List<String> _result = [];

  Converter({required Map<String, dynamic> dirs}) : _dirs = dirs;

  void doConvert() {
    _result.clear();
    _convertOne(_dirs, '');
  }

  void _convertOne(Map<String, dynamic> source, String basic) {
    for (var key in source.keys) {
      final value = source[key];
      _convertOne(value as Map<String, dynamic>, basic + key);
      var dirName = 'assets${basic + key}/';
      if (!key.contains('.')) {
        _result.add(dirName);
        LogService.success('Declare asset in pubspec.yaml file: $dirName');
      } else {
        LogService.info('Ignore asset dir: $dirName');
      }
    }
  }

  List<String> get result => _result;
}
