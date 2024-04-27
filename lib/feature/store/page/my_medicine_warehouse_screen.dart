import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/async_value_widget.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/cart/page/my_cart_screen.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
import 'package:pharmacy_online/feature/store/page/add_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/central_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/widget/medicine_warehouse_list_widget.dart';

// คลาสที่ใช้เก็บข้อมูลที่ส่งมาระหว่างหน้าจอคลังยาของผู้ใช้
class MyMedicineWarehouseArgs {
  final bool isFromChat; // บอกว่ามาจากหน้าแชทหรือไม่
  final ChatWithPharmacyResponse?
      chatWithPharmacyItem; // ข้อมูลแชทกับร้านหรือ null ถ้าไม่ได้มาจากหน้าแชท
  final CartResponse?
      cartResponse; // ข้อมูลตะกร้าหรือ null ถ้าไม่ได้มาจากหน้าตะกร้า
  final bool isFromOrder; // บอกว่ามาจากหน้ารายการสั่งซื้อหรือไม่

// หน้าจอคลังยาของผู้ใช้
  MyMedicineWarehouseArgs({
    this.isFromChat = false,
    this.chatWithPharmacyItem,
    this.cartResponse,
    this.isFromOrder = false,
  });
}

// State ของหน้าจอคลังยาของผู้ใช้
class MyMedicineWarehouseScreen extends ConsumerStatefulWidget {
  static const routeName = 'MyMedicineWarehouseScreen';

  final MyMedicineWarehouseArgs? args;

  const MyMedicineWarehouseScreen({
    super.key,
    this.args,
  });

  @override
  _MyMedicineWarehouseScreenState createState() =>
      _MyMedicineWarehouseScreenState();
}

class _MyMedicineWarehouseScreenState
    extends BaseConsumerState<MyMedicineWarehouseScreen> {
  bool isStayThisPage = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(storeControllerProvider.notifier).onSearchMyMedicine('');
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _onListen();

    final isFromChat = widget.args?.isFromChat ?? false;
    final chatWithPharmacyItem = widget.args?.chatWithPharmacyItem;
    final cartResponse = widget.args?.cartResponse;
    final uid = cartResponse?.uid ?? chatWithPharmacyItem?.uid;
    final isPharmacy = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.pharmacy.name;
    final _pharmacyId = ref
        .read(baseSharePreferenceProvider)
        .getString(BaseSharePreferenceKey.userId);
    final pharmacyId = isPharmacy
        ? _pharmacyId
        : (cartResponse?.pharmacyId ?? chatWithPharmacyItem?.pharmacyId);

// สร้างหน้าจอพื้นหลัง
    return BaseScaffold(
      appBar: BaseAppBar(
        elevation: 0,
        title: Text(
          'คลังยาร้าน',
          style: AppStyle.txtHeader3,
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop(true);
            setState(() {
              isStayThisPage = false;
            });
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 16.0,
          ),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        bgColor: AppColor.themeWhiteColor,
        actions: [
          if (!isFromChat) ...[
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(CentralMedicineWarehouseScreen.routeName);
              },
              child: Padding(
                padding: const EdgeInsets.all(16).r,
                child: Text(
                  'เพิ่มจากคลังยากลาง',
                  style: AppStyle.txtBody2,
                ),
              ),
            ),
          ],
        ],
      ),
      bgColor: AppColor.themeWhiteColor,
      bodyBuilder: (context, constrained) {
        final medicineList = ref.watch(
            storeControllerProvider.select((value) => value.medicineList));
        final searchMedicineList = ref.watch(storeControllerProvider
            .select((value) => value.searchMedicineList));

        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              AsyncValueWidget(
                value: medicineList,
                data: (_medicineList) {
                  if (_medicineList == null) {
                    return const SizedBox.shrink();
                  }

                  return Container(
                    padding: EdgeInsets.fromLTRB(
                      16,
                      70,
                      16,
                      MediaQuery.of(context).padding.bottom + 72,
                    ).r,
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: MedicineWarehouseListWidget(
                        onTap: (val) {
                          setState(() {
                            isStayThisPage = val;
                          });
                        },
                        isFromChat: isFromChat,
                        medicineList: searchMedicineList ?? _medicineList,
                        chatWithPharmacyItem: widget.args?.chatWithPharmacyItem,
                      ),
                    ),
                  );
                },
              ),
              Positioned(
                top: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16).w,
                  width: MediaQuery.of(context).size.width,
                  height: 50.h,
                  child: BaseTextField(
                    placeholder: 'ค้นหายา',
                    onChange: (val) {
                      ref
                          .read(storeControllerProvider.notifier)
                          .onSearchMyMedicine(val);
                    },
                  ),
                ),
              ),
              //ถ้าไม่ได้มาจากแชท
              if (!isFromChat) ...[
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16).r,
                    color: AppColor.themeWhiteColor,
                    child: BaseButton(
                      width: 60.w,
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(AddMedicineWarehouseScreen.routeName);
                      },
                      text: 'เพิ่มยา',
                    ),
                  ),
                ),
              ],
              //ถ้ามาจากแชท
              if (isFromChat) ...[
                Positioned(
                  bottom: 0,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.all(16).r,
                    color: AppColor.themeWhiteColor,
                    child: BaseButton(
                      width: 60.w,
                      onTap: () async {
                        final cartResponse = widget.args?.cartResponse;

                        await ref
                            .read(myCartControllerProvider.notifier)
                            .onGetCart(
                              '$uid',
                              '$pharmacyId',
                              OrderStatus.waitingConfirmOrder,
                              cartId: cartResponse?.id,
                            );
                      },
                      text: 'ไปที่หน้าตระกร้า',
                    ),
                  ),
                ),
              ]
            ],
          ),
        );
      },
    );
  }

// ฟังก์ชันนี้ทำงานเมื่อเริ่มฟังการเปลี่ยนแปลงของ myCartControllerProvider
  void _onListen() {
    // ฟังการเปลี่ยนแปลงของ myCartControllerProvider
    ref.listen(myCartControllerProvider, (previous, next) async {
      // รับค่า cartResponse และ isFromOrder จาก arguments ของ widget
      final cartResponse = widget.args?.cartResponse;
      final isFromOrder = widget.args?.isFromOrder;

      // ถ้ายังอยู่ในหน้าเดิม
      if (isStayThisPage) {
        // ถ้ามีสินค้าในตะกร้า (next.myCart.value?.id != null)
        if (next.myCart.value?.id != null) {
          // ถ้ามี cartResponse และ ไม่ได้มาจากหน้าสั่งซื้อ
          if (cartResponse != null) {
            if (!isFromOrder!) {
              // ตั้งค่า isStayThisPage เป็น false และ pushNamedAndRemoveUntil
              // ไปหน้า MyCartScreen พร้อมส่ง аргуเมนต์ isPharmacy: true
              // และ pop จนกว่าถึง routeName ของ MyCartScreen
              setState(() {
                isStayThisPage = false;
              });
              final result =
                  await Navigator.of(context).pushNamedAndRemoveUntil<bool>(
                MyCartScreen.routeName,
                arguments: MyCartArgs(isPharmacy: true),
                (route) => route.settings.name == MyCartScreen.routeName,
              );
              // ถ้า result เป็น true ก็ตั้งค่า isStayThisPage เป็น result
              if (result!) {
                setState(() {
                  isStayThisPage = result;
                });
              }
            }
          } else {
            // ถ้าไม่มี cartResponse หรือมาจากหน้าสั่งซื้อ
            // ถ้าไม่ใช่มาจากหน้าสั่งซื้อ
            if (!isFromOrder!) {
              // ตั้งค่า isStayThisPage เป็น false และ pushNamed
              // ไปหน้า MyCartScreen พร้อมส่ง аргуเมนต์ isPharmacy: true
              setState(() {
                isStayThisPage = false;
              });
              final result = await Navigator.of(context).pushNamed<bool>(
                MyCartScreen.routeName,
                arguments: MyCartArgs(isPharmacy: true),
              );

              // ถ้า result เป็น true ก็ตั้งค่า isStayThisPage เป็น result
              if (result!) {
                setState(() {
                  isStayThisPage = result;
                });
              }
            }
          }
        } else {
          // ถ้าไม่มีสินค้าในตะกร้า
          setState(() {
            // ตั้งค่า isStayThisPage เป็น false และแสดง Toast "ไม่มีของในตะกร้า"
            isStayThisPage = false;
          });
          Fluttertoast.showToast(
            msg: "ไม่มีของในตะกร้า",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
          );
        }
      }
    });
  }
}
