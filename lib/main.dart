import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pharmacy_online/base_widget/restart_widget.dart';
import 'package:pharmacy_online/core/firebase/analytics/analytics.dart';
import 'package:pharmacy_online/core/firebase/crashlytics/crashlytics.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_storage_provider.dart';
import 'package:pharmacy_online/core/firebase/database/cloud_store_provider.dart';
import 'package:pharmacy_online/core/firebase/database/real_time_provider.dart';
import 'package:pharmacy_online/core/firebase/firebase_options_provider.dart';
import 'package:pharmacy_online/core/firebase/notification/firebase_push_notification.dart';
import 'package:pharmacy_online/core/firebase/notification/local_notification.dart';
import 'package:pharmacy_online/core/local/base_shared_preference.dart';
import 'package:pharmacy_online/core/logging/logging.dart';
import 'package:pharmacy_online/core/router/app_naviagor.dart';
import 'package:pharmacy_online/core/router/app_router.dart';
import 'package:pharmacy_online/core/widget/base_consumer_state.dart';
import 'package:pharmacy_online/feature/admin/page/admin_dashboard_screen.dart';
import 'package:pharmacy_online/feature/authentication/enum/authentication_type_enum.dart';
import 'package:pharmacy_online/feature/dashboard/page/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  await runZonedGuarded<Future<void>>(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      final sharedPrefs = await SharedPreferences.getInstance();

      final container = ProviderContainer(
        overrides: [
          sharedPreferences.overrideWithValue(sharedPrefs),
        ],
      );

      // Initialize Firebase base on current environment
      final firebaseOptions = container.read(firebaseOptionsProvider);
      await Firebase.initializeApp(
        options: firebaseOptions,
      );

      // You can automatically catch all errors that are thrown within the
      // Flutter framework by overriding
      FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

      // Firebase analytics setup
      final firebaseAnalytics = container.read(firebaseAnalyticsProvider);
      await firebaseAnalytics.logAppOpen();

      // Setup firebase crashlytics
      container.read(firebaseCrashlyticsProvider);

      final notification = container.read(firebasePushNotificationProvider);
      // Setup Local push notification
      container.read(localNotificationProvider);
      // Listen firebase notification on foreground
      notification.onFirebaseMessageReceived();
      // Listen firebase notification click listener from background
      notification.setupInteractedMessage();

      //Setup Firebase Real-Time
      container.read(firebaseRealTimeProvider);

      //Setup Firebase Cloud Store
      container.read(firebaseCloudStoreProvider);

      //Setup Firebase Cloud Storage
      container.read(firebaseCloudStorageProvider);

      await container.read(loggingProvider).init();

      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp],
      );

      container.read(sharedPreferences);

      runApp(
        UncontrolledProviderScope(
          container: container,
          child: const RestartWidget(
            child: RootRestorationScope(
              restorationId: 'root',
              child: MyApp(),
            ),
          ),
        ),
      );
    },
    (error, stack) =>
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends BaseConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    final _appNavigator = ref.watch(appNavigatorProvider);
    final hasUid = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.userId) !=
        null;

    final isAdmin = ref
            .read(baseSharePreferenceProvider)
            .getString(BaseSharePreferenceKey.role) ==
        AuthenticationType.admin.name;

    return ScreenUtilInit(
      builder: (_, child) {
        return MaterialApp(
          navigatorKey: _appNavigator.navigatorKey,
          debugShowCheckedModeBanner: false,
          initialRoute: hasUid
              ? (isAdmin
                  ? AdminDashboardScreen.routeName
                  : DashboardScreen.routeName)
              : AppRouter.initialRouterName,
          onGenerateRoute: AppRouter.router,
          title: 'Pharmacy Online',
          builder: (context, child) {
            return SizedBox(
              child: child,
            );
          },
        );
      },
    );
  }
}
