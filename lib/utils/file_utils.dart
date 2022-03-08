import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// @Author: cuishuxiang
/// @Date: 2022/3/8 2:49 下午
/// @Description: 文件相关 utils

class FileUtil {
  static Future<String> getCacheSize() async {
    var tempDir = await getTemporaryDirectory();

    double size = await _getTotalSizeOfFilesInDir(tempDir);

    return _renderSize(size);
  }

  ///计算文件大小
  static Future<double> _getTotalSizeOfFilesInDir(FileSystemEntity file) async {
    try {
      if (file is File) {
        int length = await file.length();
        return double.parse(length.toString());
      }
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        double total = 0;
        if (children != null)
          for (FileSystemEntity child in children) {
            total += await _getTotalSizeOfFilesInDir(child);
          }
        return total;
      }
      return 0;
    } catch (e) {
      print(e);
      return 0;
    }
  }

  ///格式化文件大小
  static _renderSize(double value) {
    if (null == value) {
      return 0;
    }
    List<String> unitArr = ['B', 'K', 'M', 'G'];
    int index = 0;
    while (value > 1024) {
      index++;
      value = value / 1024;
    }
    String size = value.toStringAsFixed(2);
    return size + unitArr[index];
  }

  ///递归方式删除目录
  static Future delDir(FileSystemEntity file) async {
    try {
      if (file is Directory) {
        final List<FileSystemEntity> children = file.listSync();
        for (final FileSystemEntity child in children) {
          await delDir(child);
        }
      }
      await file.delete();
    } catch (e) {
      print(e);
    }
  }
}
