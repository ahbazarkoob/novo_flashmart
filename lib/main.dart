import 'dart:async';
import 'dart:io';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:meta_seo/meta_seo.dart';
import 'package:novo_flashMart/features/auth/controllers/auth_controller.dart';
import 'package:novo_flashMart/features/cart/controllers/cart_controller.dart';
import 'package:novo_flashMart/features/language/controllers/language_controller.dart';
import 'package:novo_flashMart/features/splash/controllers/splash_controller.dart';
import 'package:novo_flashMart/common/controllers/theme_controller.dart';
import 'package:novo_flashMart/features/favourite/controllers/favourite_controller.dart';
import 'package:novo_flashMart/features/notification/domain/models/notification_body_model.dart';
import 'package:novo_flashMart/helper/address_helper.dart';
import 'package:novo_flashMart/helper/auth_helper.dart';
import 'package:novo_flashMart/helper/notification_helper.dart';
import 'package:novo_flashMart/helper/responsive_helper.dart';
import 'package:novo_flashMart/helper/route_helper.dart';
import 'package:novo_flashMart/theme/dark_theme.dart';
import 'package:novo_flashMart/theme/light_theme.dart';
import 'package:novo_flashMart/util/app_constants.dart';
import 'package:novo_flashMart/util/messages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:novo_flashMart/features/home/widgets/cookies_view.dart';
import 'package:url_strategy/url_strategy.dart';
import 'helper/get_di.dart' as di;

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  if (ResponsiveHelper.isMobilePhone()) {
    HttpOverrides.global = MyHttpOverrides();
  }
  setPathUrlStrategy();
  WidgetsFlutterBinding.ensureInitialized();

  // Pass all uncaught "fatal" errors from the framework to Crashlytics
  // FlutterError.onError = (errorDetails) {
  //   FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  // };

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  // PlatformDispatcher.instance.onError = (error, stack) {
  //   FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  //   return true;
  // };

  if (GetPlatform.isWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyC1EVwE4R9LLmSV5n3JCNRpSNMjDnzT5gw",
            authDomain: "novo-flashmart.firebaseapp.com",
            projectId: "novo-flashmart",
            storageBucket: "novo-flashmart.appspot.com",
            messagingSenderId: "155652134190",
            appId: "1:155652134190:web:66931d96299d09ae6b96bf",
            measurementId: "G-R767W7WVQP"
            // databaseURL: "https://ammart-8885e-default-rtdb.firebaseio.com",
            ));
    MetaSEO().config();
  } else if (GetPlatform.isAndroid) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC1EVwE4R9LLmSV5n3JCNRpSNMjDnzT5gw",
        appId: "1:155652134190:android:2ef7b2f3978290986b96bf",
        messagingSenderId: "155652134190",
        projectId: "novo-flashmart",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  Map<String, Map<String, String>> languages = await di.init();

  NotificationBodyModel? body;
  try {
    if (GetPlatform.isMobile) {
      final RemoteMessage? remoteMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (remoteMessage != null) {
        body = NotificationHelper.convertNotification(remoteMessage.data);
      }
      await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
      FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
    }
  } catch (_) {}

  if (ResponsiveHelper.isWeb()) {
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "380903914182154",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }
  await NotificationHelper.initialize(flutterLocalNotificationsPlugin);
  runApp(MyApp(languages: languages, body: body));
}

class MyApp extends StatefulWidget {
  final Map<String, Map<String, String>>? languages;
  final NotificationBodyModel? body;
  const MyApp({super.key, required this.languages, required this.body});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    _route();
  }

  void _route() async {
    if (GetPlatform.isWeb) {
      Get.find<SplashController>().initSharedData();
      if (AddressHelper.getUserAddressFromSharedPref() != null &&
          AddressHelper.getUserAddressFromSharedPref()!.zoneIds == null) {
        Get.find<AuthController>().clearSharedAddress();
      }

      // if(!AuthHelper.isLoggedIn() && !AuthHelper.isGuestLoggedIn() /*&& !ResponsiveHelper.isDesktop(Get.context!)*/) {
      //   await Get.find<AuthController>().guestLogin();
      // }

      if ((AuthHelper.isLoggedIn()) &&
          Get.find<SplashController>().cacheModule != null) {
        Get.find<CartController>().getCartDataOnline();
      }
    }
    Get.find<SplashController>()
        .getConfigData(loadLandingData: GetPlatform.isWeb)
        .then((bool isSuccess) async {
      if (isSuccess) {
        // if (Get.find<AuthController>().isLoggedIn()) {
        Get.find<AuthController>().updateToken();
        if (Get.find<SplashController>().module != null) {
          await Get.find<FavouriteController>().getFavouriteList();
          // }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ThemeController>(builder: (themeController) {
      return GetBuilder<LocalizationController>(builder: (localizeController) {
        return GetBuilder<SplashController>(builder: (splashController) {
          return (GetPlatform.isWeb && splashController.configModel == null)
              ? const SizedBox()
              : GetMaterialApp(
                  title: AppConstants.appName,
                  debugShowCheckedModeBanner: false,
                  navigatorKey: Get.key,
                  scrollBehavior: const MaterialScrollBehavior().copyWith(
                    dragDevices: {
                      PointerDeviceKind.mouse,
                      PointerDeviceKind.touch
                    },
                  ),
                  theme: themeController.darkTheme ? dark() : light(),
                  locale: localizeController.locale,
                  translations: Messages(languages: widget.languages),
                  fallbackLocale: Locale(
                      AppConstants.languages[0].languageCode!,
                      AppConstants.languages[0].countryCode),
                  initialRoute: GetPlatform.isWeb
                      ? RouteHelper.getInitialRoute()
                      : RouteHelper.getSplashRoute(widget.body),
                  getPages: RouteHelper.routes,
                  defaultTransition: Transition.topLevel,
                  transitionDuration: const Duration(milliseconds: 500),
                  builder: (BuildContext context, widget) {
                    return MediaQuery(
                        data: MediaQuery.of(context)
                            .copyWith(textScaler: const TextScaler.linear(1)),
                        child: Material(
                          child: Stack(children: [
                            widget!,
                            GetBuilder<SplashController>(
                                builder: (splashController) {
                              if (!splashController.savedCookiesData &&
                                  !splashController.getAcceptCookiesStatus(
                                      splashController.configModel != null
                                          ? splashController
                                              .configModel!.cookiesText!
                                          : '')) {
                                return ResponsiveHelper.isWeb()
                                    ? const Align(
                                        alignment: Alignment.bottomCenter,
                                        child: CookiesView())
                                    : const SizedBox();
                              } else {
                                return const SizedBox();
                              }
                            })
                          ]),
                        ));
                  },
                );
        });
      });
    });
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
