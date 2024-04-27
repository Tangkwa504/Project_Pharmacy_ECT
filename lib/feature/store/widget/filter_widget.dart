import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_switch_button.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/search_result_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/store/widget/filter_distance_widget.dart';
import 'package:pharmacy_online/feature/store/widget/filter_reviewer_widget.dart';

class FilterWidget extends ConsumerStatefulWidget {
  const FilterWidget({super.key});

  @override
  _FilterWidgetState createState() => _FilterWidgetState();
}

class _FilterWidgetState extends BaseConsumerState<FilterWidget> {
  // สร้าง controller สำหรับจัดการค่าของค้นหาชื่อร้าน
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    // ทำลาย nameController เมื่อหน้านี้ปิด เพื่อไม่ให้เปลือง memomry
    nameController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ดึงค่า search distance ที่ได้ทำการค้นหาไปเพื่อทำเป็น initial value
    final distance = ref
        .watch(storeControllerProvider.select((value) => value.searchDistance));
    // ดึงค่า search review score ที่ได้ทำการค้นหาไปเพื่อทำเป็น initial value
    final reviewScore = ref.watch(
        storeControllerProvider.select((value) => value.searchReviewScore));
    // ดึงค่า search count reviewer ที่ได้ทำการค้นหาไปเพื่อทำเป็น initial value
    final countReviewer = ref.watch(
        storeControllerProvider.select((value) => value.searchCountReviewer));
    // ดึงค่า search opening time ที่ได้ทำการค้นหาไปเพื่อทำเป็น initial value
    final opeingTime = ref.watch(
        storeControllerProvider.select((value) => value.searchOpeningTime));
    // ดึงค่า search closing time ที่ได้ทำการค้นหาไปเพื่อทำเป็น initial value
    final closingTime = ref.watch(
        storeControllerProvider.select((value) => value.searchClosingTime));

    final searchTimeOpen = ref
        .watch(storeControllerProvider.select((value) => value.searchTimeOpen));

    return /*Scaffold(
      body: SingleChildScrollView(
        child: Container(*/
        Container(
      // ทำการ re-render หน้านี้ทุกครั้งเมื่อมีการเปลี่ยนแปลงค่า
      key: ValueKey((distance ??
              reviewScore ??
              countReviewer ??
              opeingTime ??
              closingTime ??
              searchTimeOpen)
          .hashCode),
      color: AppColor.themeWhiteColor,
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 8.h,
          ),
          Text(
            'ตัวกรองช่วยค้นหาร้านขายยา',
            style: AppStyle.txtBody,
          ),
          SizedBox(
            height: 8.h,
          ),
          // input ค้นหาร้านยา
          Text(
            'ชื่อร้านขายยา',
            style: AppStyle.txtBody2,
          ),
          BaseTextField(
            // label: 'ค้นหาร้านยา',
            // isShowLabelField: true,
            initialValue: nameController.text,
            onChange: (val) {
              nameController.text = val;
            },
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            'ระยะทาง (กิโลเมตร)',
            style: AppStyle.txtBody2,
          ),
          // Filter distance
          FilterDistanceWidget(
            initial: distance,
            onUpdate: (val) {
              // ทุกครั้งที่ update value ให้ทำการเก็บค่าใน onSetSearchDistance
              ref
                  .read(storeControllerProvider.notifier)
                  .onSetSearchDistance(val);
            },
          ),
          SizedBox(
            height: 8.h,
          ),

          // BaseSwitchButton คล้ายหน้า sign up screen
          BaseSwitchButton(
            isSwitchButton: true,
            label: "คะแนนรีวิว",
            minWidth: 100.w,
            contentPadding: const EdgeInsets.symmetric(
              vertical: 8,
            ).w,
            initialValue: [
              SwitchButtonItem(
                id: reviewScore?.id ?? 0,
                value: '${reviewScore?.value}',
                content: '${reviewScore?.content}',
              ),
            ],
            listItem: const [
              SwitchButtonItem(
                id: 5,
                value: '5',
                content: "5 ดาว",
              ),
              SwitchButtonItem(
                id: 4,
                value: '4',
                content: "4 ดาว",
              ),
              SwitchButtonItem(
                id: 3,
                value: '3',
                content: "3 ดาว",
              ),
              SwitchButtonItem(
                id: 2,
                value: '2',
                content: "2 ดาว",
              ),
              SwitchButtonItem(
                id: 1,
                value: '1',
                content: "1 ดาว",
              ),
              // SwitchButtonItem(
              //   id: 6,
              //   value: '0',
              //   content: "0 ดาว",
              // ),
            ],
            onChange: (val) {
              ref
                  .read(storeControllerProvider.notifier)
                  .onSetSearchRaiting(val);
            },
          ),
          SizedBox(
            height: 8.h,
          ),
          Text(
            'จำนวนคนรีวิว',
            style: AppStyle.txtBody2,
          ),
          // Text(
          //   '(ถ้าค้นหา 100 รีวิวขึ้นไปจะแสดงค่าที่ค้นหาและมากกว่าขึ้นไป)',
          //   style: AppStyle.txtCaptionlight,
          // ),
          SizedBox(
            height: 4.h,
          ),
          // Filter reviewer
          FilterReviewerWidget(
            initial: countReviewer,
            onUpdate: (val) {
              // ทุกครั้งที่ update value ให้ทำการเก็บค่าใน onSetSearchCountReviewer
              ref
                  .read(storeControllerProvider.notifier)
                  .onSetSearchCountReviewer(val);
            },
          ),
          SizedBox(
            height: 8.h,
          ),
          // BaseSwitchButton คล้ายหน้า sign up screen
          BaseSwitchButton(
            label: "สถานะร้านขายยา ",
            minWidth: 100.w,
            initialValue: [
              SwitchButtonItem(
                id: searchTimeOpen ? 1 : 0,
                value: searchTimeOpen ? '1' : '',
                content: searchTimeOpen ? "เปิดทำการ" : '',
              ),
            ],
            listItem: const [
              SwitchButtonItem(
                id: 1,
                value: '1',
                content: "เปิดทำการ",
              ),
            ],
            onChangeBool: (val) {
              ref
                  .read(storeControllerProvider.notifier)
                  .onSetSearchOpenPharmarcy(val);
            },
          ),
          SizedBox(
            height: 10.h,
          ),
          // ปุุ่มค้นหา
          BaseButton(
            onTap: () async {
              if ((distance == null || distance <= 0) &&
                  nameController.text.isEmpty &&
                  reviewScore == null &&
                  countReviewer == null &&
                  opeingTime == null &&
                  closingTime == null &&
                  !searchTimeOpen) {
                Fluttertoast.showToast(
                  msg: "กรุณาเลือกตัวกรองเพื่อค้นหาร้านขายยา\nที่ท่านต้องการ",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );

                return;
              }

              // เคลียร์ข้อมูลเพื่อร้านข้อมูลเก่าใน search ทิ้ง
              ref
                  .read(storeControllerProvider.notifier)
                  .onClearSelectedPharmacyStore();

              // เริ่มการค้นหาข้อมูล
              // nameController ไม่สามารถทำแบบการค้นหาอื่นๆได้ เนื่องจาก nameController จำเป็นต้องใช้ในหน้า Stateful เท่านั้นห
              ref
                  .read(storeControllerProvider.notifier)
                  .onSearchPharmacyStore(name: nameController.text);

              // ดึงร้านค่าที่ค้นหาเจอ
              final searchPharmacyInfoList = ref.watch(
                storeControllerProvider.select(
                  (value) => value.searchPharmacyInfoList,
                ),
              );

              // ตรวจสอบว่าค้นหาร้านค้าเจอ
              if (searchPharmacyInfoList != null &&
                  searchPharmacyInfoList.isNotEmpty) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  SearchResultPharmacyStoreScreen.routeName,
                );
              } else {
                // ถ้าไม่เจอก็ทำ error message มา แสดง
                final result = ref.read(
                  storeControllerProvider.select(
                    (value) => value.searchError,
                  ),
                );

                Fluttertoast.showToast(
                  msg: result ?? "ไม่พบร้านขายยา",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );

                ref.read(storeControllerProvider.notifier).onClearError();
              }
            },
            text: 'ค้นหา',
          ),
          SizedBox(
            height: 8.h,
          ),
          // ค้นหาทุกร้าน
          BaseButton(
            buttonType: ButtonType.secondary,
            onTap: () async {
              ref
                  .read(storeControllerProvider.notifier)
                  .onClearSelectedPharmacyStore();
              ref
                  .read(storeControllerProvider.notifier)
                  .onSearchPharmacyStore(isAll: true);

              final searchPharmacyInfoList = ref.watch(
                storeControllerProvider.select(
                  (value) => value.searchPharmacyInfoList,
                ),
              );

              if (searchPharmacyInfoList != null &&
                  searchPharmacyInfoList.isNotEmpty) {
                Navigator.of(context).pop();
                Navigator.of(context).pushNamed(
                  SearchResultPharmacyStoreScreen.routeName,
                );
              } else {
                final result = ref.read(
                  storeControllerProvider.select(
                    (value) => value.searchError,
                  ),
                );

                Fluttertoast.showToast(
                  msg: result ?? "ไม่พบเจอร้านเภสัช",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                );

                ref.read(storeControllerProvider.notifier).onClearError();
              }
            },
            text: 'ค้นหาทุกร้าน',
          ),
          SizedBox(
            height: 8.h,
          ),
          BaseButton(
            buttonType: ButtonType.danger,
            onTap: () async {
              ref.read(storeControllerProvider.notifier).onClearSearch();
            },
            text: 'ล้างการค้นหา',
          ),
        ],
      ),
      //   ),
      // ),
    );
  }
}
