import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/rating_start_widget.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/admin/model/response/pharmacy_info_response.dart';
import 'package:pharmacy_online/feature/authentication/model/response/pharmacy_store_response.dart';
import 'package:pharmacy_online/feature/authentication/model/response/user_info_response.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_in_screen.dart';
import 'package:pharmacy_online/feature/chat/controller/chat_controller.dart';
import 'package:pharmacy_online/feature/chat/page/chat_screen.dart';
import 'package:pharmacy_online/feature/dashboard/page/dashboard_screen.dart';
import 'package:pharmacy_online/feature/home/controller/home_controller.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/profile/page/edit_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/page/review_store_screen.dart';
//admin
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';

class StoreDetailArgs {
  final PharmacyInfoResponse? pharmacyInfoResponse;

  StoreDetailArgs({
    required this.pharmacyInfoResponse,
  });
}

class StoreDetailScreen extends ConsumerStatefulWidget {
  static const routeName = 'StoreDetailScreen';
  final StoreDetailArgs? args;

  const StoreDetailScreen({
    super.key,
    this.args,
  });

  @override
  _StoreDetailScreenState createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends BaseConsumerState<StoreDetailScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final pharmacyStoreInfo = widget.args?.pharmacyInfoResponse;
      final userInfo = ref.watch(
        profileControllerProvider.select((value) => value.userInfo),
      );

      await ref
          .read(storeControllerProvider.notifier)
          .onGetReview('${pharmacyStoreInfo?.uid ?? userInfo?.uid}');

      await ref
          .read(storeControllerProvider.notifier)
          .onCheckRequestChatAlready(
            '${pharmacyStoreInfo?.uid ?? userInfo?.uid}',
          );
      await ref
          .read(storeControllerProvider.notifier)
          .onCheckRequestChatWaiting(
            '${pharmacyStoreInfo?.uid ?? userInfo?.uid}',
          );
      await ref.read(storeControllerProvider.notifier).onGetPharmacyDetail(
            '${pharmacyStoreInfo?.uid}',
          );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final pharmacyInfoResponse = widget.args?.pharmacyInfoResponse;
    final userInfo = ref.watch(
      profileControllerProvider.select((value) => value.userInfo),
    );
    final pharmacyStoreInfo = ref.watch(
      profileControllerProvider.select((value) => value.pharmacyStore),
    );

    final pharmacyStoreImg =
        pharmacyInfoResponse?.storeImg ?? pharmacyStoreInfo?.storeImg;

    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'รายละเอียดร้านขายยา',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bodyBuilder: (context, constrained) {
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              BaseImageView(
                url: pharmacyStoreImg,
                width: MediaQuery.of(context).size.width,
                height: 250.h,
                fit: BoxFit.contain,
                border: Border.all(
                    color: const Color.fromARGB(0, 19, 202, 135), width: 1.2),
                radius: BorderRadius.circular(30),
              ),
              StoreDetailContent(
                pharmacyInfoResponse: pharmacyInfoResponse,
                pharmacyStoreInfo: pharmacyStoreInfo,
                userInfo: userInfo,
              ),
            ],
          ),
        );
      },
    );
  }
}

class StoreDetailContent extends ConsumerWidget {
  final PharmacyInfoResponse? pharmacyInfoResponse;
  final PharmacyStoreResponse? pharmacyStoreInfo;
  final UserInfoResponse? userInfo;

  const StoreDetailContent({
    super.key,
    this.pharmacyInfoResponse,
    this.pharmacyStoreInfo,
    this.userInfo,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final checkRequestChatAlready = ref.watch(
      storeControllerProvider.select((value) => value.checkRequestChatAlready),
    );
    final checkRequestChatWaiting = ref.watch(
      storeControllerProvider.select((value) => value.checkRequestChatWaiting),
    );
    final hasUserInfo = ref
            .watch(
              profileControllerProvider.select((value) => value.userInfo),
            )
            ?.uid !=
        null;

    final pharmacyDetail = ref
        .watch(storeControllerProvider.select((value) => value.pharmacyDetail))
        .value;

    final reviewList =
        pharmacyInfoResponse?.countReviewer ?? pharmacyStoreInfo?.countReviewer;

    final rating = pharmacyDetail?.ratingScore ??
        pharmacyInfoResponse?.ratingScore ??
        pharmacyStoreInfo?.ratingScore;

    final pharmacyId = pharmacyInfoResponse?.uid ?? pharmacyStoreInfo?.uid;
    final userId = userInfo?.uid ?? userInfo?.uid;

    final uid = ref
        .read(baseSharePreferenceProvider)
        .getString(BaseSharePreferenceKey.userId);

    final nameStore =
        pharmacyInfoResponse?.nameStore ?? pharmacyStoreInfo?.nameStore;

    final addressStore =
        pharmacyStoreInfo?.address ?? pharmacyInfoResponse?.addressStore;

    final timeOpening =
        pharmacyInfoResponse?.timeOpening ?? pharmacyStoreInfo?.timeOpening;
    final timeClosing =
        pharmacyInfoResponse?.timeClosing ?? pharmacyStoreInfo?.timeClosing;
    final fullname = pharmacyInfoResponse?.fullName ?? userInfo?.fullName;
    final licensePharmacy = pharmacyInfoResponse?.licensePharmacy ??
        pharmacyStoreInfo?.licensePharmacy;
    final licensePharmacyImg = pharmacyInfoResponse?.licensePharmacyImg ??
        pharmacyStoreInfo?.licensePharmacyImg;

//เพิ่มใหม่
    final phoneStore =
        pharmacyInfoResponse?.phoneStore ?? pharmacyStoreInfo?.phoneStore;
    final profileImg = pharmacyInfoResponse?.profileImg ?? userInfo?.profileImg;
    final licenseStore =
        pharmacyInfoResponse?.licenseStore ?? pharmacyStoreInfo?.licenseStore;
    final licenseStoreImg = pharmacyInfoResponse?.licenseStoreImg ??
        pharmacyStoreInfo?.licenseStoreImg;

    // ตรวจสอบว่าผู้ใช้เป็นแอดมินหรือไม่
    final isAdmin = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    return Padding(
      padding: const EdgeInsets.all(16).r,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'ร้าน$nameStore',
                  style: AppStyle.txtHeader3,
                ),
              ),
              GestureDetector(
                //รีวิว
                onTap: () {
                  Navigator.of(context).pushNamed(
                    ReviewStoreScreen.routeName,
                    arguments: StoreDetailArgs(
                      pharmacyInfoResponse: pharmacyInfoResponse,
                    ),
                  );
                },
                child: RatingStartWidget(
                  itemSize: 24,
                  initialRating: rating ?? 0,
                  onRatingUpdate: (val) {},
                  isReadable: true,
                ),
              ),
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          Text(
            "ที่อยู่",
            style: AppStyle.txtBody,
          ),
          SizedBox(
            //width: MediaQuery.of(context).size.width * 0.4,
            width: MediaQuery.of(context).size.width,
            child: Text(
              '$addressStore',
              style: AppStyle.txtBody2,
            ),
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            children: [
              Text(
                'เวลาเปิดทำการ ',
                style: AppStyle.txtBody2bold,
              ),
              Text(
                '  $timeOpening น. - $timeClosing น. ',
                style: AppStyle.txtBody2,
              ),
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          Row(
            children: [
              Text(
                'เบอร์โทรศัพท์ร้าน',
                style: AppStyle.txtBody2bold,
              ),
              Text(
                '  $phoneStore',
                style: AppStyle.txtBody2,
              ),
            ],
          ),

          SizedBox(
            height: 16.h,
          ),
          Row(
            //mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'เลขที่ใบอนุญาตร้าน',
                style: AppStyle.txtBody2bold,
              ),
              Text(
                ' $licenseStore',
                style: AppStyle.txtBody2,
              ),
            ],
          ),
          SizedBox(
            height: 16.h,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  'เภสัชกรประจำร้าน',
                  style: AppStyle.txtBody2bold,
                ),
              ],
            ),
          ),
          SizedBox(
            height: 8.h,
          ),
          //รูปเภสัช
          BaseImageView(
            url: profileImg,
            width: 250.w,
            height: 250.h,
            fit: BoxFit.cover,
            alignment: Alignment.center,
            border: Border.all(
                color: const Color.fromARGB(0, 19, 202, 135), width: 1.2),
            radius: BorderRadius.circular(30),
          ),
          SizedBox(
            height: 8.h,
          ),
          Center(
            child: Column(
              children: [
                Text(
                  '$fullname  ภ.$licensePharmacy',
                  style: AppStyle.txtBody2,
                ),
              ],
            ),
          ),
          // SizedBox(
          //   height: 16.h,
          // ),
          //รูปใบอนุญาตเภสัช
          // InteractiveViewer(
          //   child: BaseImageView(
          //     url: licensePharmacyImg,
          //     width: 300.w,
          //     //height: 250.h,
          //     fit: BoxFit.contain,
          //     alignment: Alignment.center,
          //   ),
          // ),
          // //ร้าน
          // SizedBox(
          //   height: 16.h,
          // ),

          //รูปใบอนุญาตร้าน
          // InteractiveViewer(
          //   child: BaseImageView(
          //     url: licenseStoreImg,
          //     width: 300.w,
          //     //height: 250.h,
          //     fit: BoxFit.contain,
          //     alignment: Alignment.center,
          //   ),
          // ),
          SizedBox(
            height: 30.h,
          ),
          if (pharmacyInfoResponse != null && !isAdmin) ...[
            BaseButton(
              onTap: () async {
                if (checkRequestChatWaiting) {
                  return;
                }

                if (checkRequestChatAlready) {
                  final result = await ref
                      .read(chatControllerProvider.notifier)
                      .onGetChatDetail('$pharmacyId', '$uid');
                  final id = result.id;
                  if (id != null && id.isNotEmpty) {
                    Navigator.of(context).pushNamed(
                      ChatScreen.routeName,
                      arguments: ChatArgs(
                        chatWithPharmacyItem: result,
                        isNotification: true,
                      ),
                    );
                  }
                  return;
                }

                if (hasUserInfo) {
                  final result = await ref
                      .read(storeControllerProvider.notifier)
                      .onRequestChatWithPharmacy(
                        '${pharmacyInfoResponse?.uid}',
                      );

                  if (result) {
                    await ref
                        .read(homeControllerProvider.notifier)
                        .onPostNotification(
                          '${userInfo?.fullName} ได้ส่งคำขอปรึกษากับคุณ',
                          'warningChat',
                          '$pharmacyId',
                        );
                    await ref
                        .read(homeControllerProvider.notifier)
                        .onPostNotification(
                          'ส่งคำขอรับการปรึกษาร้าน$nameStore',
                          'warningChat',
                          '$userId',
                        );

                    Fluttertoast.showToast(
                      msg: "ส่งคำขอสำเร็จ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      DashboardScreen.routeName,
                      (route) => false,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "ส่งคำขอไม่สำเร็จ",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                    );
                  }
                } else {
                  showDialog(
                    context: context,
                    builder: (_) {
                      return BaseDialog(
                        message: 'กรุณาเข้าสู่ระบบก่อนการใช้งาน',
                        hasCancel: true,
                        onClick: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                            SignInScreen.routeName,
                            (route) => false,
                          );
                        },
                      );
                    },
                  );
                }
              },
              text: checkRequestChatWaiting
                  ? 'ส่งคำขอแล้วกรุณารอร้านตอบรับ'
                  : (checkRequestChatAlready ? 'สนทนา' : 'ส่งคำขอรับการปรึกษา'),
            ),
          ] else if (isAdmin) ...[
            Container(),
          ] else ...[
            BaseButton(
              onTap: () {
                Navigator.of(context)
                    .pushNamed(EditPharmacyStoreScreen.routeName);
              },
              text: 'แก้ไขข้อมูลร้าน',
            ),
          ],
        ],
      ),
    );
  }
}
