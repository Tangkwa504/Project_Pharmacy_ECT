import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:map_location_picker/map_location_picker.dart';
import 'package:pharmacy_online/base_widget/base_form_field.dart';
import 'package:pharmacy_online/core/loader/loader_controller.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/feature/cart/controller/state/my_cart_state.dart';
import 'package:pharmacy_online/feature/cart/enum/field_address_delivery_enum.dart';
import 'package:pharmacy_online/feature/cart/model/request/cart_request.dart';
import 'package:pharmacy_online/feature/cart/usecase/add_to_cart_usecase.dart';
import 'package:pharmacy_online/feature/cart/usecase/delete_item_in_cart.dart';
import 'package:pharmacy_online/feature/cart/usecase/edit_cart_usecase.dart';
import 'package:pharmacy_online/feature/cart/usecase/get_all_my_cart_usecase.dart';
import 'package:pharmacy_online/feature/cart/usecase/get_cart_usecase.dart';
import 'package:pharmacy_online/feature/cart/usecase/update_to_cart_usecase.dart';
import 'package:pharmacy_online/feature/order/enum/order_status_enum.dart';
import 'package:pharmacy_online/feature/profile/controller/profile_controller.dart';
import 'package:pharmacy_online/utils/util/base_utils.dart';
import 'package:uuid/uuid.dart';

final myCartControllerProvider =
    StateNotifierProvider<MyCartController, MyCartState>(
  (ref) {
    final baseFormData = ref.watch(baseFormDataProvider);
    final baseUtils = ref.watch(baseUtilsProvider);
    final appNavigator = ref.watch(appNavigatorProvider);
    final addToCartUsecase = ref.watch(addToCartUsecaseProvider);
    final deleteItemInCartUsecase = ref.watch(deleteItemInCartUsecaseProvider);
    final editCartUsecase = ref.watch(editCartUsecaseProvider);
    final getCartUsecase = ref.watch(getCartUsecaseProvider);
    final updateToCartUsecase = ref.watch(updateToCartUsecaseProvider);
    final getAllMyCartUsecase = ref.watch(getAllMyCartUsecaseProvider);

    return MyCartController(
      ref,
      const MyCartState(),
      baseFormData,
      baseUtils,
      appNavigator,
      addToCartUsecase,
      deleteItemInCartUsecase,
      editCartUsecase,
      getCartUsecase,
      updateToCartUsecase,
      getAllMyCartUsecase,
    );
  },
);

class MyCartController extends StateNotifier<MyCartState> {
  final Ref _ref;
  final BaseFormData _baseFormData;
  final LoaderController _loader;
  final BaseUtils _baseUtils;
  final AppNavigator _appNavigator;
  final AddToCartUsecase _addToCartUsecase;
  final DeleteItemInCartUsecase _deleteItemInCartUsecase;
  final EditCartUsecase _editCartUsecase;
  final GetCartUsecase _getCartUsecase;
  final UpdateToCartUsecase _updateToCartUsecase;
  final GetAllMyCartUsecase _getAllMyCartUsecase;

  MyCartController(
    this._ref,
    MyCartState state,
    this._baseFormData,
    this._baseUtils,
    this._appNavigator,
    this._addToCartUsecase,
    this._deleteItemInCartUsecase,
    this._editCartUsecase,
    this._getCartUsecase,
    this._updateToCartUsecase,
    this._getAllMyCartUsecase,
  )   : _loader = _ref.read(loaderControllerProvider.notifier),
        super(state);

  void onChanged(BaseFormData baseFormData) {
    final newData = _baseFormData.copyAndMerge(baseFormData);
    state = state.copyWith(baseFormData: newData);
  }

  void onGetLocation() async {
    final result = await _baseUtils.getLocation();

    result.when((success) {
      state = state.copyWith(
        googlePlex: CameraPosition(
          target: LatLng(success.latitude, success.longitude),
          zoom: 14.4746,
        ),
      );
    }, (error) {
      state = state.copyWith(errMsg: error.message);
    });
  }

  void clearForm() {
    state = state.copyWith(baseFormData: null);
  }

  Future<bool> onAddToCart(
    String storeId,
    String uid,
    String medicineId,
    String medicineImg,
    double medicinePrice,
    String medicineName,
    int quantity,
    String nameStore,
    String medicineSize,
    String medicineMaterial,
  ) async {
    bool isSuccess = false;
    _loader.onLoad();

    final result = await _addToCartUsecase.execute(
      CartRequest(
        id: state.generateCartId,
        storeId: storeId,
        uid: uid,
        medicineId: medicineId,
        quantity: quantity,
        medicineImg: medicineImg,
        medicineName: medicineName,
        medicinePrice: medicinePrice,
        nameStore: nameStore,
        medicineSize: medicineSize,
        medicineMaterial: medicineMaterial,
      ),
    );

    result.when(
      (success) {
        isSuccess = success;
        _loader.onDismissLoad();
      },
      (error) => _loader.onDismissLoad(),
    );

    return isSuccess;
  }

  Future<bool> onDeleteItemCart(
    String cartId,
    String cartMedicineId,
  ) async {
    bool isSuccess = false;

    final result = await _deleteItemInCartUsecase.execute(
      CartRequest(
        id: cartId,
        cartMedicineId: cartMedicineId,
      ),
    );

    result.when(
      (success) => isSuccess = success,
      (error) => null,
    );

    return isSuccess;
  }

  Future<bool> onEditCart(
    String cartId,
    String medicineId,
    String medicineImg,
    double medicinePrice,
    String medicineName,
    int quantity,
    String medicineSize,
    String medicineMaterial,
  ) async {
    bool isSuccess = false;

    final result = await _editCartUsecase.execute(
      CartRequest(
        id: cartId,
        medicineId: medicineId,
        quantity: quantity,
        medicineImg: medicineImg,
        medicineName: medicineName,
        medicinePrice: medicinePrice,
        medicineSize: medicineSize,
        medicineMaterial: medicineMaterial,
      ),
    );

    result.when(
      (success) => isSuccess = success,
      (error) => null,
    );

    return isSuccess;
  }

  Future<void> onGetCart(
    String uid,
    String pharmacyId,
    OrderStatus orderStatus, {
    String? cartId,
    bool isLoading = true,
  }) async {
    if (isLoading) {
      _loader.onLoad();
    }

    final result = await _getCartUsecase.execute(
      CartRequest(
        pharmacyId: pharmacyId,
        uid: uid,
        id: cartId,
        status: orderStatus,
      ),
    );

    result.when(
      (success) {
        state = state.copyWith(myCart: AsyncValue.data(success));
        _loader.onDismissLoad();
      },
      (error) {
        state = state.copyWith(myCart: const AsyncValue.data(null));
        _loader.onDismissLoad();
      },
    );
  }

  Future<bool> onUpdateCart(
    String cartId,
    String vatFee,
    String deliveryFee,
    String totalPrice,
    String summaryPrice,
    OrderStatus status,
  ) async {
    bool isSuccess = false;
    final baseFormData = state.baseFormData;
    final userInfo =
        _ref.watch(profileControllerProvider.select((value) => value.userInfo));
    final _fullName = userInfo?.fullName;
    final _phone = userInfo?.phone;
    final _address = userInfo?.address;

    final fullName =
        baseFormData?.getValue(FieldAddressDelivery.fullName) ?? _fullName;
    final phone = baseFormData?.getValue(FieldAddressDelivery.phone) ?? _phone;
    final address =
        baseFormData?.getValue(FieldAddressDelivery.address) ?? _address;
    final district = baseFormData?.getValue(FieldAddressDelivery.district);
    final subDistrict =
        baseFormData?.getValue(FieldAddressDelivery.subDistrict);
    final province = baseFormData?.getValue(FieldAddressDelivery.province);
    final post = baseFormData?.getValue(FieldAddressDelivery.post);

    final result = await _updateToCartUsecase.execute(
      CartRequest(
        id: cartId,
        vatFee: vatFee,
        deliveryFee: deliveryFee,
        totalPrice: totalPrice,
        summaryPrice: summaryPrice,
        status: status,
        fullName: fullName,
        phone: phone,
        address: address,
        district: district,
        subDistrict: subDistrict,
        province: province,
        postNumber: post,
      ),
    );

    result.when(
      (success) => isSuccess = success,
      (error) => null,
    );

    return isSuccess;
  }

  void setQuantity(String medicineId, int quantity) {
    state = state.copyWith(quantity: {medicineId: quantity});
  }

  Future<void> onGetAllMyCart(
    OrderStatus orderStatus, {
    bool isPhamarcy = false,
  }) async {
    final result = await _getAllMyCartUsecase.execute(
      CartRequest(
        isPharmacy: isPhamarcy,
        status: orderStatus,
      ),
    );

    result.when(
      (success) {
        state = state.copyWith(cartList: AsyncValue.data(success));
      },
      (error) {
        state = state.copyWith(cartList: const AsyncValue.data([]));
      },
    );
  }

  void onGenerateCartId() {
    const uuid = Uuid();

    state = state.copyWith(generateCartId: uuid.v4());
  }

  void onClearCartId() {
    const uuid = Uuid();

    state = state.copyWith(
      generateCartId: uuid.v4(),
      myCart: const AsyncValue.data(null),
    );
  }
}
