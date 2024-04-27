import 'package:image_picker/image_picker.dart';

class UserInfoRequest {
  final String? email;
  final String? password;
  final String? role;
  final XFile? profileImg;
  final String? currentProfileImg;
  final String? fullName;
  final String? address;
  final String? licensePharmacy;
  final XFile? storeImg;
  final XFile? licensePharmacyImg;
  final String? currentStoreImg;
  final String? currentLicensePharmacyImg;
  final String? nameStore;
  final String? phone;
  final String? phoneStore;
  final double? latitude;
  final double? longtitude;
  final String? timeOpening;
  final String? timeClosing;
  final String? licenseStore;
  final XFile? licenseStoreImg;
  final XFile? qrCodeImg;
  final String? currentLicenseStoreImg;
  final String? currentQrCodeImg;
  final String? allergy;

  UserInfoRequest({
    this.email,
    this.password,
    this.role,
    this.profileImg,
    this.currentProfileImg,
    this.fullName,
    this.address,
    this.licensePharmacy,
    this.licensePharmacyImg,
    this.currentStoreImg,
    this.currentLicensePharmacyImg,
    this.nameStore,
    this.phone,
    this.latitude,
    this.longtitude,
    this.timeOpening,
    this.timeClosing,
    this.licenseStore,
    this.licenseStoreImg,
    this.qrCodeImg,
    this.phoneStore,
    this.storeImg,
    this.currentLicenseStoreImg,
    this.currentQrCodeImg,
    this.allergy,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'role': role,
      'profileImg': profileImg,
      'currentProfileImg': currentProfileImg,
      'fullName': fullName,
      'address': address,
      'licensePharmacy': licensePharmacy,
      'licensePharmacyImg': licensePharmacyImg,
      'nameStore': nameStore,
      'currentStoreImg': currentStoreImg,
      'currentLicensePharmacyImg': currentLicensePharmacyImg,
      'phone': phone,
      'latitude': latitude,
      'longtitude': longtitude,
      'timeOpening': timeOpening,
      'timeClosing': timeClosing,
      'licenseStore': licenseStore,
      'licenseStoreImg': licenseStoreImg,
      'qrCodeImg': qrCodeImg,
      'phoneStore': phoneStore,
      'storeImg': storeImg,
      'currentLicenseStoreImg': currentLicenseStoreImg,
      'currentQrCodeImg': currentQrCodeImg,
      'allergy': allergy,
    };
  }
}
