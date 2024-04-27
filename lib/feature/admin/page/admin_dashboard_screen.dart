import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/admin/page/approve_pharmacy_screen.dart';
import 'package:pharmacy_online/feature/admin/widget/admin_bottom_navigation_widget.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/profile/page/profile_screen.dart';
import 'package:pharmacy_online/feature/store/page/central_medicine_warehouse_screen.dart';
//แผนที่
import 'package:pharmacy_online/feature/admin/page/admin_map_screen.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  static const routeName = 'AdminDashboardScreen';

  const AdminDashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  _AdminDashboardScreenState createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState
    extends BaseConsumerState<AdminDashboardScreen> {
  @override
  void initState() {
    // เมื่อ Widget ถูกสร้างขึ้นและทำการ Build เสร็จ
    // ใช้ addPostFrameCallback เพื่อให้โค้ดทำงานหลังจากที่ Widget ถูก render เสร็จ
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // เรียกใช้งาน notifier จาก provider เพื่อดึงข้อมูล user info
      await ref.read(profileControllerProvider.notifier).onGetUserInfo();
      // เรียกใช้งาน notifier จาก provider เพื่อดึงข้อมูลร้านขายยา
      await ref.read(profileControllerProvider.notifier).onGetPharmacyStore();
      //เพิ่มให้แผนที่
      await ref.read(storeControllerProvider.notifier).getPharmacyInfo();
    });
    super.initState();
  }

  int _currentPage = 0;

  final List<Widget> pages = const [
    ApprovePharmacyScreen(),
    CentralMedicineWarehouseScreen(),
    AdminMapScreen(),
    ProfileScreen(),
  ];

  final List<String> pagesTitle = const [
    "หน้าหลัก",
    "คลังยา",
    "แผนที่",
    "บัญชี",
  ];

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      // ใช้ BaseScaffold เป็น Widget หลักที่มีการกำหนดโครงสร้างหน้าจอพื้นฐาน
      bodyBuilder: (context, constraints) {
        return pages[_currentPage]; // แสดงหน้าที่เลือกตาม _currentPage
      },
      bottomNavigationBar: AdminBottomNavigationWidget(
        // Widget ที่แสดง Bottom Navigation Bar สำหรับนำทางระหว่างหน้าจอ
        onChange: (value) {
          // Callback function เมื่อมีการเปลี่ยนแปลงหน้า
          setState(() {
            _currentPage = value; // กำหนดหน้าปัจจุบันตามค่าที่ถูกเลือก
          });
        },
      ),
    );
  }
}
