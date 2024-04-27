class Failure implements Exception {
  final String message; //เก็บข้อความที่อธิบายเหตุผลของ Failure
  final int? code; //nullable int เพื่อเก็บรหัสข้อผิดพลาดที่เกี่ยวข้อง
  final Exception?
      exception; //nullable Exception เพื่อเก็บข้อมูล Exception ที่เกี่ยวข้อง

  //constructor ที่รับพารามิเตอร์ message เป็น required และ code, exception เป็น optional
  Failure({required this.message, this.code, this.exception});

  // Override เมธอด toString เพื่อให้ได้ข้อความที่อธิบาย Failure ในรูปแบบ String ที่มีรายละเอียด
  @override
  String toString() {
    return 'Failure(message: $message, code: $code, exception: $exception)';
  }
}
