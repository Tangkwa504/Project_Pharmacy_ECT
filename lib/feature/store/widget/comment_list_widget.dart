import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pharmacy_online/base_widget/base_divider.dart';
import 'package:pharmacy_online/feature/store/model/response/reviews_response.dart';
import 'package:pharmacy_online/feature/store/widget/comment_item_widget.dart';

class CommentListWidget extends ConsumerWidget {
  final List<CommentResponse> commentList;
  const CommentListWidget({
    super.key,
    required this.commentList,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListView.separated(
      physics: const ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: commentList.length,
      itemBuilder: (context, index) {
        final commentItem = commentList[index];
        return CommentItemWidget(
          commentItem: commentItem,
        );
      },
      separatorBuilder: (_, __) => const BaseDivider(),
    );
  }
}
