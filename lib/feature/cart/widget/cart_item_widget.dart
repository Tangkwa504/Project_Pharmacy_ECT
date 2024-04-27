import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/base_image_view.dart';
import 'package:pharmacy_online/core/app_color.dart';
import 'package:pharmacy_online/core/app_style.dart';
import 'package:pharmacy_online/feature/cart/controller/my_cart_controller.dart';
import 'package:pharmacy_online/feature/cart/model/response/cart_response.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/feature/store/model/response/medicine_response.dart';
import 'package:pharmacy_online/feature/store/page/drug_detail_screen.dart';
import 'package:pharmacy_online/feature/store/widget/quantity_widget.dart';
import 'package:pharmacy_online/generated/assets.gen.dart';

// ignore: must_be_immutable
class CartItemWidget extends ConsumerWidget {
  final bool isPharmacy;
  final MedicineResponse medicineItem;
  final CartResponse myCart;
  final bool isFromOrder;

  CartItemWidget({
    super.key,
    required this.isPharmacy,
    required this.medicineItem,
    required this.myCart,
    required this.isFromOrder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _quantity =
        ref.watch(myCartControllerProvider.select((value) => value.quantity));
    final pharmacyStoreInfo = ref.watch(
        profileControllerProvider.select((value) => value.pharmacyStore));

    return Container(
      padding: const EdgeInsets.all(16).r,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12).r,
        border: Border.all(
          width: 1.w,
          color: AppColor.themePrimaryColor,
        ),
        color: AppColor.themeWhiteColor,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: () async {
              await Navigator.of(context).pushNamed<bool>(
                DrugDetailScreen.routeName,
                arguments: DrugDetailArgs(
                  medicineItem: medicineItem,
                  isOnlyDetail: true,
                ),
              );
            },
            child: BaseImageView(
              url: medicineItem.medicineImg,
              width: 80.w,
              height: 80.h,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).pushNamed<bool>(
                            DrugDetailScreen.routeName,
                            arguments: DrugDetailArgs(
                              medicineItem: medicineItem,
                              isOnlyDetail: true,
                            ),
                          );
                        },
                        child: Text(
                          '${medicineItem.name}',
                          style: AppStyle.txtBody,
                        ),
                      ),
                    ),
                    if (isPharmacy) ...[
                      GestureDetector(
                        onTap: () async {
                          // กดเพื่อลบสินค้าออกจากตะกร้า
                          final result = await ref
                              .read(myCartControllerProvider.notifier)
                              .onDeleteItemCart(
                                '${myCart.id}',
                                '${medicineItem.cartMedicineId}',
                              );

                          if (result) {
                            ref
                                .read(myCartControllerProvider.notifier)
                                .onGetCart(
                                  '${myCart.uid}',
                                  '${myCart.pharmacyId}',
                                  OrderStatus.waitingConfirmOrder,
                                  cartId: myCart.id,
                                );

                            if (isFromOrder) {
                              final myCart = ref
                                  .watch(myCartControllerProvider
                                      .select((value) => value.myCart))
                                  .value;

                              if (myCart == null ||
                                  myCart.medicineList!.isNotEmpty) {
                                Navigator.of(context).pop();
                              }
                            }
                          }
                        },
                        child: Assets.icons.icDelete.svg(),
                      ),
                    ],
                  ],
                ),
                // SizedBox(
                //   height: 4.h,
                // ),
                // Text(
                //   '20pcs',
                //   style: AppStyle.txtCaption.copyWith(
                //     color: AppColor.themeGrayLight,
                //   ),
                // ),
                SizedBox(
                  height: 16.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //แสดงจำนวนสินค้า
                    if (isPharmacy) ...[
                      QuantityWidget(
                        initial: _quantity?['${medicineItem.id}'] ??
                            medicineItem.quantity,
                        maximum: 100,
                        itemSized: 24,
                        onUpdate: (val) async {
                          //อัปเดตจำนวนสินค้าในตะกร้า
                          await ref
                              .read(myCartControllerProvider.notifier)
                              .onAddToCart(
                                '${myCart.pharmacyId}',
                                '${myCart.uid}',
                                '${medicineItem.id}',
                                '${medicineItem.medicineImg}',
                                medicineItem.price ?? 0.0,
                                '${medicineItem.name}',
                                val,
                                '${pharmacyStoreInfo?.nameStore}',
                                '${medicineItem.size}',
                                '${medicineItem.material}',
                              );

                          ref
                              .read(myCartControllerProvider.notifier)
                              .setQuantity('${medicineItem.id}', val);

                          ref.read(myCartControllerProvider.notifier).onGetCart(
                                '${myCart.uid}',
                                '${myCart.pharmacyId}',
                                OrderStatus.waitingConfirmOrder,
                                isLoading: true,
                                cartId: myCart.id,
                              );
                        },
                      ),
                    ] else ...[
                      GestureDetector(
                        onTap: () async {
                          await Navigator.of(context).pushNamed<bool>(
                            DrugDetailScreen.routeName,
                            arguments: DrugDetailArgs(
                              medicineItem: medicineItem,
                              isOnlyDetail: true,
                            ),
                          );
                        },
                        child: Text(
                          'จำนวน ${medicineItem.quantity}',
                          style: AppStyle.txtBody2,
                        ),
                      ),
                    ],
                    GestureDetector(
                      onTap: () async {
                        await Navigator.of(context).pushNamed<bool>(
                          DrugDetailScreen.routeName,
                          arguments: DrugDetailArgs(
                            medicineItem: medicineItem,
                            isOnlyDetail: true,
                          ),
                        );
                      },
                      child: Text(
                        '${(medicineItem.price ?? 0.0) * ((medicineItem.quantity ?? 0.0) * 1.0)} บาท',
                        style: AppStyle.txtBody2,
                      ),
                    ),
                  ],
                ),
                // ] else ...[
                //   Text(
                //     'ราคา: ${medicineItem.price} บาท',
                //     style: AppStyle.txtBody2,
                //   ),
                // ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
