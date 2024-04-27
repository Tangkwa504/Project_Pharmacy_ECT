import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/authentication/controller/authentication_controller.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/chat/controller/chat_controller.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/profile/page/change_password_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_profile_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_qr_code_screen.dart';
import 'package:pharmacy_online/feature/profile/widget/profile_image_widget.dart';
import 'package:pharmacy_online/feature/profile/widget/profile_menu_widget.dart';
import 'package:pharmacy_online/feature/store/page/store_detail_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

// หน้าจอแสดงข้อมูลโปรไฟล์ผู้ใช้
class ProfileScreen extends ConsumerStatefulWidget {
  static const routeName = 'ProfileScreen';

  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    // ดึงข้อมูลผู้ใช้
    final userInfo =
        ref.watch(profileControllerProvider.select((value) => value.userInfo));
    // ดึงข้อมูลร้าน
    final pharmacyStore = ref.watch(
        profileControllerProvider.select((value) => value.pharmacyStore));

    // ดึงข้อมูลเภสัชกร
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));

    // ดึงข้อมูลรูปโปรไฟล์และชื่อผู้ใช้
    final profileImg = userInfo?.profileImg;
    final phone = userInfo?.phone;
    final fullName = userInfo?.fullName;
    final nameStore = pharmacyStore?.nameStore;

    // ตรวจสอบว่าผู้ใช้เป็น Admin หรือไม่
    final isAdmin = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    // สร้างหน้าจอด้วย BaseScaffold
    return BaseScaffold(
      bodyBuilder: (context, constrianed) {
        return SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // แสดงข้อมูลโปรไฟล์สำหรับผู้ใช้ทั่วไป
                if (!isAdmin && userInfo?.uid != null) ...[
                  Text(
                    'My Profile',
                    style: AppStyle.txtHeader3,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // แสดงรูปโปรไฟล์และชื่อผู้ใช้
                  ProfileImageWidget(
                    imageUrl: '$profileImg',
                    name: !isPharmacy
                        ? '$fullName\n$phone'
                        : '$fullName\n   ร้าน$nameStore',
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  // ปุ่มเพื่อแก้ไขข้อมูลส่วนตัว
                  ProfileMenuWidget(
                    onTap: () {
                      ref.read(profileControllerProvider.notifier).clearForm();
                      Navigator.of(context).pushNamed(
                        EditProfileScreen.routeName,
                      );
                    },
                    prefixIcon: Assets.icons.icPersion.svg(),
                    label: 'แก้ไขข้อมูลส่วนตัว',
                  ),
                  // แสดงเมนูการแก้ไขข้อมูลเภสัชกร
                  if (isPharmacy) ...[
                    const BaseDivider(),
                    ProfileMenuWidget(
                      onTap: () async {
                        ref
                            .read(profileControllerProvider.notifier)
                            .clearForm();

                        await ref
                            .read(profileControllerProvider.notifier)
                            .onGetPharmacyStore();

                        Navigator.of(context).pushNamed(
                          StoreDetailScreen.routeName,
                          arguments: StoreDetailArgs(
                            pharmacyInfoResponse: null,
                          ),
                        );
                      },
                      prefixIcon: Assets.imgs.imgStore.image(
                        width: 42,
                      ),
                      label: 'แก้ไขข้อมูลร้าน',
                    ),
                    const BaseDivider(),
                    ProfileMenuWidget(
                      onTap: () {
                        Navigator.of(context)
                            .pushNamed(EditQRCodeScreen.routeName);
                      },
                      prefixIcon: Assets.imgs.imgQrcode.image(
                        width: 42,
                      ),
                      label: 'แก้ไข QRcode',
                    ),
                  ],
                  const BaseDivider(),
                  ProfileMenuWidget(
                    onTap: () {
                      Navigator.of(context)
                          .pushNamed(ChangePasswordScreen.routeName);
                    },
                    prefixIcon: Assets.icons.icSettings.svg(),
                    label: 'เปลี่ยนรหัสผ่าน',
                  ),
                  const BaseDivider(),
                ],
                // แสดงข้อมูลสำหรับ Admin
                if (isAdmin) ...[
                  Assets.icons.icAdministrator.svg(),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'Admin',
                    style: AppStyle.txtHeader3,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  const BaseDivider(),
                ],
                // แสดงข้อมูลสำหรับผู้ที่ยังไม่ได้ลงทะเบียนหรือเข้าสู่ระบบ
                if (userInfo?.uid == null) ...[
                  SizedBox(
                    height: 36.h,
                  ),
                  Assets.icons.icPersion.svg(
                    width: 108.w,
                    height: 108.h,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  Text(
                    'GUEST',
                    style: AppStyle.txtHeader3,
                  ),
                  SizedBox(
                    height: 16.h,
                  ),
                  const BaseDivider(),
                ],
                // เมนูออกจากระบบ
                ProfileMenuWidget(
                  onTap: () {
                    showBaseDialog(
                      context: context,
                      builder: (ctx) {
                        return BaseDialog(
                          dialogLogo: Assets.icons.icLogout.svg(),
                          message: 'ต้องการออกจากระบบ',
                          onClick: () async {
                            ref
                                .read(chatControllerProvider.notifier)
                                .onClearChat();
                            await ref
                                .read(authenticationControllerProvider.notifier)
                                .onLogout();
                            Navigator.of(context).pop();
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              MainScreen.routeName,
                              (route) => false,
                            );
                          },
                          hasCancel: true,
                        );
                      },
                    );
                  },
                  prefixIcon: Assets.icons.icWarning.svg(),
                  label: 'ออกจากระบบ',
                ),
                const BaseDivider(),
                if (isPharmacy) ...[
                  SizedBox(
                    height: 75.h,
                  ),
                  Text(
                    'ติดต่อเราได้ที่ email: pharmapp.admn@gmail.com',
                    style: AppStyle.txtCaptionlight,
                  ),
                ],
                if (!isAdmin && userInfo?.uid != null && !isPharmacy) ...[
                  SizedBox(
                    height: 175.h,
                  ),
                  Text(
                    'ติดต่อเราได้ที่ email: pharmapp.admn@gmail.com',
                    style: AppStyle.txtCaptionlight,
                  ),
                ],
                if (userInfo?.uid == null) ...[
                  SizedBox(
                    height: 317.h,
                  ),
                  Text(
                    'ติดต่อเราได้ที่ email: pharmapp.admn@gmail.com',
                    style: AppStyle.txtCaptionlight,
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
