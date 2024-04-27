import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/core/cache/io_file_system.dart';

// สร้าง Provider สำหรับ DefaultCacheManager
final defaultCacheManagerProvider = Provider((ref) => DefaultCacheManager());

// สร้าง Provider สำหรับ BaseCustomCacheManager
final baseCustomCacheManagerProvider =
    Provider((ref) => BaseCustomCacheManager());

// Example code if you'd like manual code
// https://stackoverflow.com/questions/60306287/save-network-images-in-flutter-to-load-them-offline
// https://github.com/Baseflow/flutter_cache_manager/issues/238

// Class ที่สืบทอดมาจาก CacheManager และ ImageCacheManager
class BaseCustomCacheManager extends CacheManager with ImageCacheManager {
  static const String key = "customCache";

  // กำหนดตัวแปร instance ของ BaseCustomCacheManager สำหรับ Singleton Pattern
  static BaseCustomCacheManager? _instance;

  // Constructor ภายใน private ทำให้ไม่สามารถสร้าง instance จากภายนอกได้
  BaseCustomCacheManager._()
      : super(
          Config(
            key,
            stalePeriod: const Duration(seconds: 1),
            maxNrOfCacheObjects: 1000,
            repo: JsonCacheInfoRepository(databaseName: key),
            fileSystem: IOFileSystem(key),
            fileService: HttpFileService(),
          ),
        );

  // Factory method สำหรับสร้าง instance ของ BaseCustomCacheManager
  factory BaseCustomCacheManager() {
    return _instance ??= BaseCustomCacheManager._();
  }
}
