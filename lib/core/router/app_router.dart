import 'package:flutter/material.dart';
import 'package:pharmacy_online/core/router/custom_page_route_builder.dart';
import 'package:pharmacy_online/feature/admin/page/admin_dashboard_screen.dart';
import 'package:pharmacy_online/feature/admin/page/pharmacy_store_detail_screen.dart';
import 'package:pharmacy_online/feature/admin/page/user_detail_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/banned_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/cosent_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/forgot_password_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_in_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_in_successful_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_up_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/sign_up_successful_screen.dart';
import 'package:pharmacy_online/feature/authentication/page/term_and_condition_screen.dart';
import 'package:pharmacy_online/feature/cart/page/address_delivery_screen.dart';
import 'package:pharmacy_online/feature/cart/page/my_cart_screen.dart';
import 'package:pharmacy_online/feature/cart/page/order_summary_screen.dart';
import 'package:pharmacy_online/feature/chat/page/chat_screen.dart';
import 'package:pharmacy_online/feature/chat/page/inbox_screen.dart';
import 'package:pharmacy_online/feature/chat/page/request_consult_screen.dart';
import 'package:pharmacy_online/feature/dashboard/page/dashboard_screen.dart';
import 'package:pharmacy_online/feature/home/page/home_screen.dart';
import 'package:pharmacy_online/feature/home/page/notification_screen.dart';
import 'package:pharmacy_online/feature/main/page/main_screen.dart';
import 'package:pharmacy_online/feature/order/page/add_review_screen.dart';
import 'package:pharmacy_online/feature/order/page/evidence_bank_transfer_screen.dart';
import 'package:pharmacy_online/feature/order/page/evidence_transportation_screen.dart';
import 'package:pharmacy_online/feature/order/page/order_detail_screen.dart';
import 'package:pharmacy_online/feature/order/page/orders_screen.dart';
import 'package:pharmacy_online/feature/order/page/upload_bank_transfer_screen.dart';
import 'package:pharmacy_online/feature/order/page/upload_transportation_screen.dart';
import 'package:pharmacy_online/feature/profile/page/change_password_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_profile_screen.dart';
import 'package:pharmacy_online/feature/profile/page/profile_screen.dart';
import 'package:pharmacy_online/feature/profile/page/edit_qr_code_screen.dart';
import 'package:pharmacy_online/feature/store/page/add_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/central_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/comment_screen.dart';
import 'package:pharmacy_online/feature/store/page/drug_detail_screen.dart';
import 'package:pharmacy_online/feature/store/page/edit_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/my_medicine_warehouse_screen.dart';
import 'package:pharmacy_online/feature/store/page/near_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/store/page/review_store_screen.dart';
import 'package:pharmacy_online/feature/store/page/search_result_pharmacy_store_screen.dart';
import 'package:pharmacy_online/feature/store/page/store_detail_screen.dart';

class AppRouter {
  // ชื่อของหน้าแรกที่จะถูกเรียกใช้
  static const initialRouterName = MainScreen.routeName;

  // เมธอดที่ให้บริการการนำทางตามชื่อของ route
  static Route<dynamic>? router(RouteSettings settings) {
    switch (settings.name) {
      // นำทางไปยังหน้า MainScreen
      case MainScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: MainScreen.routeName,
          builder: (ctx) => const MainScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า TermAndConditionScreen ไม่ได้ใช้แล้ว
      case TermAndConditionScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: TermAndConditionScreen.routeName,
          builder: (ctx) => const TermAndConditionScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า ConsentScreen ไม่ได้ใช้แล้ว
      case ConsentScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: ConsentScreen.routeName,
          builder: (ctx) => const ConsentScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า DashboardScreen
      case DashboardScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: DashboardScreen.routeName,
          builder: (ctx) => const DashboardScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า HomeScreen
      case HomeScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: HomeScreen.routeName,
          builder: (ctx) => const HomeScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า SignInScreen
      case SignInScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: SignInScreen.routeName,
          builder: (ctx) => const SignInScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า SignUpScreen
      case SignUpScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: SignUpScreen.routeName,
          builder: (ctx) => const SignUpScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า SignUpSuccessfulScreen
      case SignUpSuccessfulScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: SignUpSuccessfulScreen.routeName,
          builder: (ctx) => const SignUpSuccessfulScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า SignInSuccessfulScreen
      case SignInSuccessfulScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: SignInSuccessfulScreen.routeName,
          builder: (ctx) => const SignInSuccessfulScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า NotificationScreen
      case NotificationScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: NotificationScreen.routeName,
          builder: (ctx) => const NotificationScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า InboxScreen
      case InboxScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: InboxScreen.routeName,
          builder: (ctx) => const InboxScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า StoreDetailScreen
      case StoreDetailScreen.routeName:
        // ตรวจสอบว่า arguments เป็น StoreDetailArgs หรือเป็น null
        assert(
          settings.arguments is StoreDetailArgs || settings.arguments == null,
          'arguments must be StoreDetailArgs or null',
        );

        // ถ้า arguments เป็น StoreDetailArgs ให้แปลงเป็น StoreDetailArgs
        final args = settings.arguments as StoreDetailArgs;

        // สร้างและคืนค่า CustomPageRouteBuilder สำหรับเปิดหน้าจอ StoreDetailScreen
        return CustomPageRouteBuilder.route(
          name: StoreDetailScreen.routeName,
          // สร้างหน้าจอ StoreDetailScreen โดยให้ args เป็นข้อมูลที่ถูกส่งมา
          builder: (ctx) => StoreDetailScreen(args: args),
          // กำหนดว่าการเปลี่ยนหน้าจอจะใช้ fade effect
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า OrderDetailScreen
      case OrderDetailScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: OrderDetailScreen.routeName,
          builder: (ctx) => const OrderDetailScreen(),
          transitionType: RouteTransition.fade,
        );

      case OrdersScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: OrdersScreen.routeName,
          builder: (ctx) => const OrdersScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า UploadBankTransferScreen
      case UploadBankTransferScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: UploadBankTransferScreen.routeName,
          builder: (ctx) => const UploadBankTransferScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า UploadTransportationScreen
      case UploadTransportationScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: UploadTransportationScreen.routeName,
          builder: (ctx) => const UploadTransportationScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า EvidenceTransportationScreen
      case EvidenceTransportationScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: EvidenceTransportationScreen.routeName,
          builder: (ctx) => const EvidenceTransportationScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า EvidenceBankTransferScreen
      case EvidenceBankTransferScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: EvidenceBankTransferScreen.routeName,
          builder: (ctx) => const EvidenceBankTransferScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า AddReviewScreen
      case AddReviewScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: AddReviewScreen.routeName,
          builder: (ctx) => const AddReviewScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า EditQRCodeScreen
      case EditQRCodeScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: EditQRCodeScreen.routeName,
          builder: (ctx) => const EditQRCodeScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า ChangePasswordScreen
      case ChangePasswordScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: ChangePasswordScreen.routeName,
          builder: (ctx) => const ChangePasswordScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า EditProfileScreen
      case EditProfileScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: EditProfileScreen.routeName,
          builder: (ctx) => const EditProfileScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า ProfileScreen
      case ProfileScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: ProfileScreen.routeName,
          builder: (ctx) => const ProfileScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า EditPharmacyStoreScreen
      case EditPharmacyStoreScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: EditPharmacyStoreScreen.routeName,
          builder: (ctx) => const EditPharmacyStoreScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า ReviewStoreScreen
      case ReviewStoreScreen.routeName:
        assert(
          settings.arguments is StoreDetailArgs || settings.arguments == null,
          'arguments must be StoreDetailArgs or null',
        );

        final args = settings.arguments as StoreDetailArgs;

        return CustomPageRouteBuilder.route(
          name: ReviewStoreScreen.routeName,
          builder: (ctx) => ReviewStoreScreen(args: args),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า CommentScreen
      case CommentScreen.routeName:
        assert(
          settings.arguments is CommentArgs || settings.arguments == null,
          'arguments must be CommentArgs or null',
        );

        final args = settings.arguments as CommentArgs;
        return CustomPageRouteBuilder.route(
          name: CommentScreen.routeName,
          builder: (ctx) => CommentScreen(
            args: args,
          ),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า RequestConsultScreen
      case RequestConsultScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: RequestConsultScreen.routeName,
          builder: (ctx) => const RequestConsultScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า ChatScreen
      case ChatScreen.routeName:
        assert(
          settings.arguments is ChatArgs || settings.arguments == null,
          'arguments must be ChatArgs or null',
        );

        final args = settings.arguments as ChatArgs;

        return CustomPageRouteBuilder.route(
          name: ChatScreen.routeName,
          builder: (ctx) => ChatScreen(
            args: args,
          ),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า MyMedicineWarehouseScreen
      case MyMedicineWarehouseScreen.routeName:
        assert(
          settings.arguments is MyMedicineWarehouseArgs ||
              settings.arguments == null,
          'arguments must be MyMedicineWarehouseArgs or null',
        );

        final args = settings.arguments as MyMedicineWarehouseArgs;

        return CustomPageRouteBuilder.route<bool>(
          name: MyMedicineWarehouseScreen.routeName,
          builder: (ctx) => MyMedicineWarehouseScreen(args: args),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า CentralMedicineWarehouseScreen
      case CentralMedicineWarehouseScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: CentralMedicineWarehouseScreen.routeName,
          builder: (ctx) => const CentralMedicineWarehouseScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า AddMedicineWarehouseScreen
      case AddMedicineWarehouseScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: AddMedicineWarehouseScreen.routeName,
          builder: (ctx) => const AddMedicineWarehouseScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า EditMedicineWarehouseScreen
      case EditMedicineWarehouseScreen.routeName:
        assert(
          settings.arguments is MedicineWarehouseArgs ||
              settings.arguments == null,
          'arguments must be MedicineWarehouseArgs or null',
        );

        final args = settings.arguments as MedicineWarehouseArgs;

        return CustomPageRouteBuilder.route(
          name: EditMedicineWarehouseScreen.routeName,
          builder: (ctx) => EditMedicineWarehouseScreen(args: args),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า MyCartScreen
      case MyCartScreen.routeName:
        assert(
          settings.arguments is MyCartArgs || settings.arguments == null,
          'arguments must be MyCartArgs or null',
        );

        final args = settings.arguments as MyCartArgs;

        return CustomPageRouteBuilder.route<bool>(
          name: MyCartScreen.routeName,
          builder: (ctx) => MyCartScreen(args: args),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า DrugDetailScreen
      case DrugDetailScreen.routeName:
        assert(
          settings.arguments is DrugDetailArgs || settings.arguments == null,
          'arguments must be DrugDetailArgs or null',
        );

        final args = settings.arguments as DrugDetailArgs;
        return CustomPageRouteBuilder.route<bool>(
          name: DrugDetailScreen.routeName,
          builder: (ctx) => DrugDetailScreen(args: args),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า OrderSummaryScreen
      case OrderSummaryScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: OrderSummaryScreen.routeName,
          builder: (ctx) => const OrderSummaryScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า AddressDeliveryScreen
      case AddressDeliveryScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: AddressDeliveryScreen.routeName,
          builder: (ctx) => const AddressDeliveryScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า ForgotPasswordScreen
      case ForgotPasswordScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: ForgotPasswordScreen.routeName,
          builder: (ctx) => const ForgotPasswordScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า BannedScreen
      case BannedScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: BannedScreen.routeName,
          builder: (ctx) => const BannedScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า NearPharmacyStoreScreen
      case NearPharmacyStoreScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: NearPharmacyStoreScreen.routeName,
          builder: (ctx) => const NearPharmacyStoreScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า AdminDashboardScreen
      case AdminDashboardScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: AdminDashboardScreen.routeName,
          builder: (ctx) => const AdminDashboardScreen(),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า PharmacyStoreDetaillScreen
      case PharmacyStoreDetaillScreen.routeName:
        assert(
          settings.arguments is PharmacyArgs || settings.arguments == null,
          'arguments must be PharmacyArgs or null',
        );

        final args = settings.arguments as PharmacyArgs;

        return CustomPageRouteBuilder.route(
          name: PharmacyStoreDetaillScreen.routeName,
          builder: (ctx) => PharmacyStoreDetaillScreen(
            args: args,
          ),
          transitionType: RouteTransition.fade,
        );

      // นำทางไปยังหน้า UserDetailScreen
      case UserDetailScreen.routeName:
        assert(
          settings.arguments is PharmacyArgs || settings.arguments == null,
          'arguments must be PharmacyArgs or null',
        );

        final args = settings.arguments as PharmacyArgs;

        return CustomPageRouteBuilder.route(
          name: UserDetailScreen.routeName,
          builder: (ctx) => UserDetailScreen(
            args: args,
          ),
          transitionType: RouteTransition.fade,
        );

      case SearchResultPharmacyStoreScreen.routeName:
        return CustomPageRouteBuilder.route(
          name: SearchResultPharmacyStoreScreen.routeName,
          builder: (ctx) => const SearchResultPharmacyStoreScreen(),
          transitionType: RouteTransition.fade,
        );

      // case RoomAndRateScreen.routeName:
      //   assert(
      //     settings.arguments is RoomAndRateScreenArgs ||
      //         settings.arguments == null,
      //     'arguments must be RoomAndRateScreenArgs or null',
      //   );

      //   final args = settings.arguments as RoomAndRateScreenArgs;

      //   return CustomPageRouteBuilder.route(
      //     name: RoomAndRateScreen.routeName,
      //     builder: (ctx) => RoomAndRateScreen(
      //       args: args,
      //     ),
      //     transitionType: RouteTransition.slideVertically,
      //   );

      // กรณีที่ไม่ตรงกับเงื่อนไขใดเลย
      default:
        assert(false, 'this should not be reached');
        return null;
    }
  }
}
