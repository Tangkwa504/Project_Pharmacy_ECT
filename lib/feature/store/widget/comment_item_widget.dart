import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/reviews_response.dart';
import 'package:pharmacy_online/feature/store/widget/commet_header_widget.dart';

class CommentItemWidget extends ConsumerWidget {
  final CommentResponse commentItem;

  const CommentItemWidget({
    super.key,
    required this.commentItem,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isPharmacy = ref
        .watch(profileControllerProvider.select((value) => value.isPharmacy));
    final uid = ref
        .read(baseSharePreferenceProvider)
        .getString(BaseSharePreferenceKey.userId);

    return Container(
      color: AppColor.themeWhiteColor,
      padding: const EdgeInsets.all(16).r,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          BaseImageView(
            url: '${commentItem.profileImg}',
            width: 60.w,
            height: 70.h,
            radius: BorderRadius.circular(150 / 2),
            fit: BoxFit.cover,
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CommentHeaderWidget(
                  reviewItem: ReviewsResponse(
                    id: '${commentItem.reviewId}',
                    uid: '${commentItem.uid}',
                    pharmacyId: '${commentItem.pharmacyId}',
                    fullName: '${commentItem.fullName}',
                    profileImg: '${commentItem.profileImg}',
                    commentId: '${commentItem.commentId}',
                  ),
                  isShowRating: false,
                ),
                if (!isPharmacy && uid != commentItem.uid) ...[
                  SizedBox(
                    height: 16.h,
                  ),
                ],
                Text(
                  '${commentItem.message}',
                  style: AppStyle.txtBody2
                      .copyWith(color: AppColor.themeGrayLight),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
