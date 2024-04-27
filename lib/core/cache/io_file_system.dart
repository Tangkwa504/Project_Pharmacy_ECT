import 'package:file/file.dart'; // Import ไลบรารี file สำหรับการทำงานกับไฟล์
import 'package:file/local.dart'; // Import ไลบรารี local สำหรับใช้ LocalFileSystem
import 'package:flutter_cache_manager/src/storage/file_system/file_system.dart'
    as c; // Import ไลบรารีและเปลี่ยนชื่อเป็น 'c' สำหรับการใช้ FileSystem
import 'package:path/path.dart'
    as p; // Import ไลบรารี path และเปลี่ยนชื่อเป็น 'p' สำหรับใช้ path.join
import 'package:path_provider/path_provider.dart'; // Import ไลบรารี path_provider สำหรับใช้ getTemporaryDirectory

/// การประมวลผล [c.FileSystem] ที่ใช้ระบบไฟล์ local (IO).
class IOFileSystem implements c.FileSystem {
  final Future<Directory> _fileDir;

  IOFileSystem(String key)
      // กำหนด _fileDir เป็น Future ของ Directory จากการสร้างไดเรกทอรี
      : _fileDir = createDirectory(key);

  /// สร้างไดเรกทอรีในไดเรกทอรีชั่วคราว
  static Future<Directory> createDirectory(String key) async {
    // ใช้ getTemporaryDirectory จาก path_provider เพื่อรับ Directory ของไดเรกทอรีชั่วคราว
    var baseDir = await getTemporaryDirectory();
    // ใช้ path.join จาก path เพื่อรวมเส้นทางของไดเรกทอรีและ key
    var path = p.join(baseDir.path, key);

    // สร้าง LocalFileSystem จากไลบรารี file
    var fs = const LocalFileSystem();
    // ใช้ LocalFileSystem ในการสร้าง Directory
    var directory = fs.directory((path));
    // สร้างไดเรกทอรีและสร้างโครงสร้างไฟล์ทั้งหมดในเส้นทาง ถ้ายังไม่ได้สร้างไว้
    await directory.create(recursive: true);
    return directory; // ส่งคืน Directory ที่ได้จากการสร้าง
  }

  @override
  Future<File> createFile(String name) async {
    // สร้างและส่งคืนไฟล์ในไดเรกทอรีที่กำหนด
    return (await _fileDir).childFile(name);
  }
}
