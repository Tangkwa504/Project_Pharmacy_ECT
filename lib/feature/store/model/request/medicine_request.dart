import 'package:image_picker/image_picker.dart';

class MedicineRequest {
  final String? id;
  final String? name;
  final double? price;
  final XFile? medicineImg;
  final String? currentMedicineImg;
  final String? size;
  final String? material;

  MedicineRequest({
    this.id,
    this.name,
    this.price,
    this.medicineImg,
    this.currentMedicineImg,
    this.size,
    this.material,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'medicineImg': medicineImg,
      'currentMedicineImg': currentMedicineImg,
      'material': material,
      'size': size,
    };
  }
}
