import 'dart:io';

/// Get folder structure
class GetPaths {
  static Future<Map<String, dynamic>> getDirs(String path) async {
    final res = <String, dynamic>{};
    final dir = Directory(path);
    final entities = (await dir.list().toList());
    final subDirs = entities.whereType<Directory>().toList();
    // make them alphabetical
    subDirs.sort((first, second) {
      return first.path.compareTo(second.path);
    });
    for (var subDir in subDirs) {
      res[subDir.path.replaceAll(path, '')] = await getDirs(subDir.path);
    }
    return res;
  }
}