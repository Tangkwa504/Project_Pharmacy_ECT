extension StringExtension on String {
  //สำหรับแปลงสตริงเป็นเลขฐานสิบ
  int get pareInt {
    // ใช้ฟังก์ชัน `int.parse()` เพื่อแปลงสตริงเป็นเลขฐานสิบ
    // และคืนค่าผลลัพธ์
    return int.parse(this);
  }

//สำหรับแปลงตัวอักษรตัวแรกเป็นอักษรตัวใหญ่
  String get capitalize {
    // คืนค่าสตริงที่มีตัวอักษรตัวแรกเป็นอักษรตัวใหญ่
    // โดยการตัดสตริงออกตั้งแต่ตำแหน่งที่ 1 เป็นต้นไป
    return this[0].toUpperCase();
  }
}
