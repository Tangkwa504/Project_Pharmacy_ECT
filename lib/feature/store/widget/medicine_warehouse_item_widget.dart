import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pharmacy_online/base_widget/base_button.dart';
import 'package:pharmacy_online/base_widget/base_dialog.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/feature/store/controller/store_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/chat_with_pharmacy_response.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/page/drug_detail_screen.dart';
import 'package:pharmacy_online/feature/store/page/edit_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

class MedicineWarehouseItemWidget extends ConsumerWidget {
  final MedicineResponse medicineItem;
  final bool isCentral;
  final bool isFromChat;
  final ChatWithPharmacyResponse? chatWithPharmacyItem;
  final Function(bool result) onTap;

  const MedicineWarehouseItemWidget({
    super.key,
    required this.medicineItem,
    required this.isCentral,
    required this.isFromChat,
    this.chatWithPharmacyItem,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = medicineItem.uid;
    final _uid = ref
        .read(baseSharePreferenceProvider)
        .getString(BaseSharePreferenceKey.userId);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            if (isFromChat) {
              onTap(false);

              final result = await Navigator.of(context).pushNamed<bool>(
                DrugDetailScreen.routeName,
                arguments: DrugDetailArgs(
                  medicineItem: medicineItem,
                  chatWithPharmacyItem: chatWithPharmacyItem,
                ),
              );
              onTap(result!);
              return;
            } else {
              await Navigator.of(context).pushNamed<bool>(
                DrugDetailScreen.routeName,
                arguments: DrugDetailArgs(
                  medicineItem: medicineItem,
                  isOnlyDetail: true,
                ),
              );
            }
          },
          child: BaseImageView(
            url: '${medicineItem.medicineImg}',
            width: 120.w,
            height: 120.h,
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(
          width: 16.w,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        if (isFromChat) {
                          onTap(false);

                          final result =
                              await Navigator.of(context).pushNamed<bool>(
                            DrugDetailScreen.routeName,
                            arguments: DrugDetailArgs(
                              medicineItem: medicineItem,
                              chatWithPharmacyItem: chatWithPharmacyItem,
                            ),
                          );

                          onTap(result!);
                          return;
                        } else {
                          await Navigator.of(context).pushNamed<bool>(
                            DrugDetailScreen.routeName,
                            arguments: DrugDetailArgs(
                              medicineItem: medicineItem,
                              isOnlyDetail: true,
                            ),
                          );
                        }
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            '${medicineItem.name}',
                            style: AppStyle.txtBody,
                          ),
                          Text(
                            medicineItem.size == null
                                ? ''
                                : '${medicineItem.size}',
                            style: AppStyle.txtBody,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isCentral && uid != _uid) ...[
                    BaseButton(
                      width: 50.w,
                      onTap: () async {
                        final result = await ref
                            .read(storeControllerProvider.notifier)
                            .onAddCentralMedicineToMyWarehouse(medicineItem);

                        if (result) {
                          Fluttertoast.showToast(
                            msg: "เพิ่มสำเร็จ",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                          );

                          ref
                              .read(storeControllerProvider.notifier)
                              .onGetMedicineWarehouse();
                        }
                      },
                      iconWidget: Padding(
                        padding: const EdgeInsets.only(top: 4).h,
                        child: Assets.icons.icPlus.svg(),
                      ),
                    ),
                  ],
                  if (uid == _uid && !isFromChat) ...[
                    SizedBox(
                      width: 8.w,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          EditMedicineWarehouseScreen.routeName,
                          arguments: MedicineWarehouseArgs(
                            medicineItem: medicineItem,
                          ),
                        );
                      },
                      child: Assets.icons.icEdit.svg(
                        width: 32.w,
                        height: 32.h,
                      ),
                    ),
                    SizedBox(
                      width: 8.w,
                    ),
                    GestureDetector(
                      onTap: () async {
                        final isConfirm = await showDialog<bool>(
                          context: context,
                          builder: (_) {
                            return BaseDialog(
                              message: 'ต้องการลบรายการนี้หรือไม่',
                              hasCancel: true,
                            );
                          },
                        );

                        if (isConfirm != null && isConfirm) {
                          final result = await ref
                              .read(storeControllerProvider.notifier)
                              .deleteMedicineWarehouse(medicineItem.id);

                          if (result) {
                            await ref
                                .read(storeControllerProvider.notifier)
                                .onGetCentralMedicineWarehouse();
                            await ref
                                .read(storeControllerProvider.notifier)
                                .onGetMedicineWarehouse();
                          }
                        }
                      },
                      child:
                          Assets.icons.icDelete.svg(width: 48.w, height: 48.h),
                    ),
                  ],
                ],
              ),
              if (!isCentral) ...[
                SizedBox(
                  height: 8.h,
                ),
                GestureDetector(
                  onTap: () async {
                    onTap(false);

                    if (isFromChat) {
                      onTap(false);

                      final result =
                          await Navigator.of(context).pushNamed<bool>(
                        DrugDetailScreen.routeName,
                        arguments: DrugDetailArgs(
                          medicineItem: medicineItem,
                          chatWithPharmacyItem: chatWithPharmacyItem,
                        ),
                      );

                      onTap(result!);
                      return;
                    } else {
                      await Navigator.of(context).pushNamed<bool>(
                        DrugDetailScreen.routeName,
                        arguments: DrugDetailArgs(
                          medicineItem: medicineItem,
                          isOnlyDetail: true,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'ราคา ${medicineItem.price}',
                    style: AppStyle.txtBody,
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
