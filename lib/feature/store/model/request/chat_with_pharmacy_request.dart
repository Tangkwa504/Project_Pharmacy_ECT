import 'package:image_picker/image_picker.dart';

class ChatWithPharmacyRequest {
  final String? id;
  final String? message;
  final String? uid;
  final String? pharmacyId;
  final XFile? chatImg;
  final bool? isApprove;

  ChatWithPharmacyRequest({
    this.id,
    this.message,
    this.uid,
    this.pharmacyId,
    this.chatImg,
    this.isApprove,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'uid': uid,
      'pharmacyId': pharmacyId,
      'chatImg': chatImg,
      'isApprove': isApprove,
    };
  }
}
