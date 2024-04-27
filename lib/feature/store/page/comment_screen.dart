import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_app_bar.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_scaffold.dart';
import 'package:pharmacy_online/base_widget/base_text_field.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/reviews_response.dart';
import 'package:pharmacy_online/feature/store/widget/comment_list_widget.dart';

// คลาส CommentArgs ใช้สำหรับส่งข้อมูลรีวิวไปยังหน้าจอ CommentScreen
class CommentArgs {
  final ReviewsResponse
      reviewItem; // ข้อมูลรีวิวที่จะแสดงในหน้าจอ CommentScreen

  CommentArgs({
    required this.reviewItem,
  });
}

// คลาส CommentScreen เป็นหน้าจอสำหรับแสดงความคิดเห็นเกี่ยวกับรีวิว
class CommentScreen extends ConsumerStatefulWidget {
  static const routeName = 'CommentScreen';
  final CommentArgs args;

  const CommentScreen({
    super.key,
    required this.args,
  });

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

// State ของหน้าจอ CommentScreen
class _CommentScreenState extends BaseConsumerState<CommentScreen> {
  // Controller สำหรับช่องกรอกข้อความ
  TextEditingController messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose(); // Dispose controller เมื่อปิดหน้าจอ
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final reviewItem = widget.args.reviewItem; // ดึงข้อมูลรีวิวจาก args

    final commentList = ref
        // อ่านรายการ comment จาก riverpod
        .watch(storeControllerProvider.select((value) => value.commentList))
        .value;

    return BaseScaffold(
      appBar: BaseAppBar(
        title: Text(
          'ตอบกลับรีวิว',
          style: AppStyle.txtHeader3,
        ),
        bgColor: AppColor.themeWhiteColor,
      ),
      bgColor: AppColor.themLineColor,
      bodyBuilder: (context, constrained) {
        return SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [
              if (commentList != null) ...[
                // แสดงรายการความคิดเห็นถ้ามีข้อมูล
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 72).r,
                  child: CommentListWidget(
                    commentList: commentList,
                  ),
                ),
              ],
              // ส่วนล่างของหน้าจอสำหรับกรอกและส่งคอมเมนต์
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.all(16).r,
                  color: AppColor.themeWhiteColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: BaseTextField(
                          controller:
                              messageController, // เชื่อม controller กับช่องกรอกข้อความ
                          //label: 'comment',
                          //isShowLabelField: true,
                        ),
                      ),
                      SizedBox(
                        width: 8.w,
                      ),
                      BaseButton(
                        width: 60.w,
                        onTap: () async {
                          final uid = ref
                              .read(baseSharePreferenceProvider)
                              .getString(BaseSharePreferenceKey.userId);

                          if (messageController.text.isEmpty) {
                            return; // ถ้าข้อความว่าง ให้ยกเลิก
                          }

                          // ส่งคอมเมนต์
                          await ref
                              .read(storeControllerProvider.notifier)
                              .onAddComment(
                                '${reviewItem.id}',
                                '${reviewItem.pharmacyId}',
                                '$uid',
                                messageController.text,
                              );

                          // โหลดรายการความคิดเห็นใหม่หลังส่ง
                          await ref
                              .read(storeControllerProvider.notifier)
                              .onGetComment('${reviewItem.id}');

                          messageController.clear(); // ล้างช่องกรอกข้อความ
                        },
                        text: 'ส่ง',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
