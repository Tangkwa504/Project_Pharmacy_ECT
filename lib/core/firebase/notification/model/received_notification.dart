/// When you create a notification the instance of this class is required
/// [id] unique id for this notification
/// [payload] is used when user click on the notification
class ReceivedNotification {
  final int id; // รหัสที่ไม่ซ้ำกันเพื่อระบุการแจ้งเตือนแต่ละรายการ
  final String? title; // หัวเรื่องของการแจ้งเตือน
  final String? body; // เนื้อหาของการแจ้งเตือน
  final String? payload; // ข้อมูลที่จะถูกใช้เมื่อผู้ใช้คลิกที่การแจ้งเตือน
  final String? imageUrl; // URL ของรูปภาพที่เกี่ยวข้องกับการแจ้งเตือน

  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
    this.imageUrl,
  });
}
