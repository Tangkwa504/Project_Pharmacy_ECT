import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pharmacy_online/core/application/custom_platform.dart';
import 'package:pharmacy_online/utils/util/string_extension.dart';

final baseDateFormatterProvider =
    Provider<BaseDateFormatter>((_) => BaseDateFormatter());

class BaseDateFormatter {
  // แปลงวันที่เป็น datetime ท้องถิ่น ถ้าอยู่ในโหมดทดสอบให้ใช้ datetime เดิม
  DateTime _convertToLocal(DateTime dateTime) {
    return CustomPlatform.isTest ? dateTime : dateTime.toLocal();
  }

  /// Format [DateTime] to 'HH:mm:ss'
  /// ฟอร์แมตวันที่เป็น เวลาในรูปแบบ 'HH:mm:ss'
  String formatTime(DateTime date) {
    return DateFormat('HH:mm:ss').format(_convertToLocal(date));
  }

  /// Format [DateTime] to 'yyyy-MM-dd'
  /// ฟอร์แมตวันที่เป็น วันที่ในรูปแบบ 'yyyy-MM-dd'
  String formatDate(DateTime date) {
    return DateFormat('yyyy-MM-dd').format(_convertToLocal(date));
  }

  /// Format [DateTime] to 'yyyy-MM-dd HH:mm:ss'
  /// ฟอร์แมตวันที่เป็น วันที่และเวลาในรูปแบบ 'yyyy-MM-dd HH:mm:ss'
  String formatDateWithTime(DateTime date) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(_convertToLocal(date));
  }

  /// Format [DateTime] to 'dd MMM yy HH:mm'
  /// ฟอร์แมตวันที่เป็น 'dd MMM yy HH:mm' โดยแปลงเป็น พ.ศ. ถ้าภาษาเป็นไทย
  String formatDateTimeWithNameOfMonth(
    DateTime date,
    String format, {
    String lang = 'en',
  }) {
    if (lang == 'th' || lang == 'TH') {
      final buddhistYear = DateTime(
        // เพิ่มปี พ.ศ. 543
        date.year + 543,
        date.month,
        date.day,
        date.hour,
        date.minute,
        date.second,
      );
      // ฟอร์แมตปี พ.ศ. เป็น string
      final buddhistDateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'")
          .format(_convertToLocal(buddhistYear));

      // แปลง string ปี พ.ศ. กลับมาเป็น datetime แล้วฟอร์แมตตาม format ที่กำหนด
      return DateFormat(format)
          .format(_convertToLocal(DateTime.parse(buddhistDateFormat)));
    }

    // ฟอร์แมตตาม format ปกติ ถ้าภาษาไม่ใช่ภาษาไทย
    return DateFormat(format).format(_convertToLocal(date));
  }

  /// Format [DateTime] to 'dd/MM/yyyy HH:mm'
  String formatDateWithDateTime(DateTime date) {
    // แปลงวันที่เป็น datetime ท้องถิ่น
    return DateFormat('dd/MM/yyyy HH:mm').format(_convertToLocal(date));
  }

  /// Format [String] to [DateTime]
// แปลง String เป็น DateTime
  DateTime convertStringToDateTime(String date) {
    // แปลง String ให้เป็นรูปบบ yyyy-MM-dd HH:mm แล้วแปลงเป็น datetime ท้องถิ่น
    return _convertToLocal(DateFormat('yyyy-MM-dd HH:mm').parse(date));
  }

  /// Format [DateTime] with timeZone to 'yyyy-MM-dd HH:mm:ss'
// ฟอร์แมตวันที่พร้อม timeZone เป็น 'yyyy-MM-dd HH:mm:ss'
  String formatDateWithTimeAndTimeZone(DateTime date) {
    // แปลงวันที่เป็น datetime ท้องถิ่น และ UTC
    final localDate = date.toLocal();
    final utcDate = date.toUtc();

    // หา timeZone ปัจจุบัน ถ้าอยู่ในโหมดทดสอบใช้ค่า 7 ไม่งั้นหาจาก localDate และ utcDate
    final currentTimeZone = CustomPlatform.isTest
        ? 7
        : (DateTime(
            localDate.year,
            localDate.month,
            localDate.day,
            localDate.hour,
            localDate.minute,
          ))
            .difference(
              DateTime(
                utcDate.year,
                utcDate.month,
                utcDate.day,
                utcDate.hour,
                utcDate.minute,
              ),
            )
            .inHours;
    // ฟอร์แมตวันที่พร้อม timeZone
    return '${DateFormat('yyyy-MM-dd HH:mm:ss').format(date)} GMT${currentTimeZone >= 0 ? '+' : ''}$currentTimeZone';
  }

// ฟอร์แมตวันที่ตามรูปแบบที่กำหนด โดยใช้ DateFormat หรือ Jiffy
  String formatDateWithFreeStyleFormat(
    String format,
    DateTime date, {
    bool isJiffyFormat = false,
  }) {
    if (isJiffyFormat) {
      // ใช้ Jiffy ฟอร์แมต
      return Jiffy.parse('$date').format(pattern: format);
    }

    return DateFormat(format).format(_convertToLocal(date));
  }

// ฟอร์แมตวันที่เป็น 'dd MMM yyyy HH:mm:ss'
  String formatDateWithSecond(DateTime date) {
    return DateFormat('dd MMM yyyy HH:mm:ss').format(_convertToLocal(date));
  }

// สร้างข้อความช่วงวันที่ เช่น "15-20 พ.ย. 2567"
  String getDateGroupText(
    DateTime? start,
    DateTime? end,
  ) {
    if (start == null || end == null)
      return ''; // ถ้า start หรือ end เป็น null คืนค่าว่าง

    // ฟอร์แมต start และ end เป็น 'dd MMM yyyy'
    final startDate = formatDateWithFreeStyleFormat('dd MMM yyyy', start);
    final endDate = formatDateWithFreeStyleFormat('dd MMM yyyy', end);

    // ถ้า start และ end เป็นวันเดียวกัน คืนค่า endDate เท่านั้น
    if (startDate == endDate) {
      return endDate;
    }

    // แยกวันของ start ออกมา
    final dayOfStartDate = startDate.split(' ')[0];

    // รวมช่วงวันที่เป็น "วันของ start - endDate"
    return '$dayOfStartDate-$endDate';
  }

  /// Format [DateTime] to 'dd MM yyyy'
// ฟอร์แมตวันที่เป็น 'dd MM yyyy'
  String formatDateToDisplayDate(DateTime date) {
    String format = "dd MMM yyyy";
    return DateFormat(format).format(_convertToLocal(date));
  }

// แปลง String เป็น DateTime โดยแยกวันที่ตาม splitChar
  DateTime formatStringToDate(
    String date,
    String splitChar,
  ) {
    final splitDate = date.split(splitChar);

    // แปลงปี เดือน วัน จาก String เป็นตัวเลข แล้วสร้าง DateTime
    return DateTime(splitDate[2].pareInt /*ปี*/, splitDate[1].pareInt /*เดือน*/,
        splitDate[0].pareInt /*วัน*/);
  }

  DateTime convertTimeStringToDateTime(String timeString) {
    // Create a DateTime object for today with the given time
    DateTime now = DateTime.now();

    // Format the date and time string
    String formattedDateTimeString =
        '${now.year}-${now.month}-${now.day}T${timeString}Z';

    // Define the date format
    final DateFormat dateFormat = DateFormat('yyyy-MM-ddTHH:mmZ');

    // Parse the formatted string into a DateTime object using the specified format
    DateTime dateTime = dateFormat.parse(formattedDateTimeString);
    return dateTime;
  }
}
