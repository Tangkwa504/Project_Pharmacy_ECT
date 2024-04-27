import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/feature/store/model/response/reviews_response.dart';
import 'package:pharmacy_online/feature/store/widget/review_item_widget.dart';

class ReviewListWidget extends ConsumerWidget {
  final List<ReviewsResponse> reviewList;
  const ReviewListWidget({
    super.key,
    required this.reviewList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviewList.length,
      itemBuilder: (context, index) {
        final reviewItem = reviewList[index];

        return ReviewItemWidget(
          reviewItem: reviewItem,
        );
      },
      separatorBuilder: (_, __) => const BaseDivider(),
    );
  }
}
