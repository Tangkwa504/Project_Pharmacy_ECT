class ParsingUtils {
  // เมธอด `parseDouble()` สำหรับแปลงสตริงเป็นเลขฐานสิบ
  static double parseDouble(String number) {
    // ใช้ฟังก์ชัน `tryParse()` เพื่อแปลงสตริงเป็นเลขฐานสิบ
    // หากแปลงสำเร็จ คืนค่าผลลัพธ์
    // หากแปลงไม่สำเร็จ คืนค่า 0
    return double.tryParse(number) ?? 0.0;
  }

// เมธอด `parseInt()` สำหรับแปลงสตริงหรือตัวเลขเป็นเลขฐานสิบ
  static int parseInt(dynamic number) {
    // ถ้า `number` เป็นตัวเลขอยู่แล้ว ให้คืนค่าโดยตรง
    if (number is int) return number;
    // ถ้า `number` เป็นสตริง ให้แปลงเป็นเลขฐานสิบ
    if (number is String) return int.tryParse(number) ?? 0;

    return 0; // กรณีอื่นๆ ให้คืนค่า 0
  }
}
