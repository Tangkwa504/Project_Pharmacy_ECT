import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_bottom_navigation_widget.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
//import 'package:pharmacy_online/feature/authentication/page/sign_in_screen.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/chat/page/inbox_screen.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/home/page/home_screen.dart';
import 'package:pharmacy_online/feature/order/controller/order_controller.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/order/page/orders_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/profile/page/profile_screen.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  static const routeName = 'DashboardScreen';

  const DashboardScreen({
    Key? key,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends BaseConsumerState<DashboardScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await ref.read(profileControllerProvider.notifier).onGetUserInfo();
      await ref.read(profileControllerProvider.notifier).onGetPharmacyStore();
      await ref
          .read(storeControllerProvider.notifier)
          .onGetCentralMedicineWarehouse();
      await ref.read(storeControllerProvider.notifier).onGetMedicineWarehouse();
      await ref.read(storeControllerProvider.notifier).getPharmacyInfo();
      await ref.read(homeControllerProvider.notifier).onGetNotification();
    });
    super.initState();
  }

  int _currentPage = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    OrdersScreen(),
    InboxScreen(),
    ProfileScreen(),
  ];

  final List<String> pagesTitle = const [
    "Home",
    "Order",
    "Chat",
    "Profile",
  ];

  @override
  Widget build(BuildContext context) {
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );

    return BaseScaffold(
      bodyBuilder: (context, constraints) {
        return pages[_currentPage];
      },
      bottomNavigationBar: BottomNavigationWidget(
        onChange: (value) async {
          if (userInfo?.uid != null) {
            await ref
                .read(orderControllerProvider.notifier)
                .onGetAllOrder(isPharmacy);
            await ref.read(homeControllerProvider.notifier).onGetNotification();
            await ref.read(myCartControllerProvider.notifier).onGetAllMyCart(
                  OrderStatus.waitingConfirmOrder,
                  isPhamarcy: isPharmacy,
                );
            setState(() {
              _currentPage = value;
            });
          } else {
            if (value == 1 || value == 2) {
              setState(() {
                _currentPage = 0;
              });
              showDialog(
                context: context,
                builder: (_) {
                  return BaseDialog(
                    message: 'กรุณาเข้าสู่ระบบก่อนการใช้งาน',
                    hasCancel: true,
                    onClick: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        MainScreen.routeName,
                        (route) => false,
                        // SignInScreen.routeName,
                        // (route) => false,
                      );
                    },
                  );
                },
              );
            } else {
              setState(() {
                _currentPage = value;
              });
            }
          }
        },
      ),
    );
  }
}
