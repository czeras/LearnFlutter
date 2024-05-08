import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

import '../controller/initial_binding.dart';
import '../login/login/view.dart';
import '../model/login_page_model.dart';
import '../model/unread__message_count_model.dart';
import '../utils/global_notice/widgets/loading.dart';
import '../utils/log/r_logs.dart';
import '../utils/route/app_navigator_observer.dart';
import '../utils/screen/screen_utils.dart';
import 'main_init.dart';

/// 全局监听
final appNavigatorObserver = AppNavigatorObserver();
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class RootPage extends StatefulWidget {
  const RootPage({Key? key}) : super(key: key);

  @override
  State<RootPage> createState() => _RootPageState();
}

GlobalKey<NavigatorState> rootNavigatorState = GlobalKey<NavigatorState>();

class _RootPageState extends State<RootPage>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<OverlayState> overlayKey = GlobalKey<OverlayState>();
  double weworkTextScaleFactor = 1.0;
  bool useSystemTextScaleFactor = true;
  StreamSubscription? _linkStream;
  bool loading = true;

  late FirebaseAnalyticsObserver _firebaseAnalyticsObserver;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp, //只能纵向
      DeviceOrientation.portraitDown, //只能纵向
    ]);

    WidgetsBinding.instance.addObserver(this);

    _firebaseAnalyticsObserver =
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance);

    // Future.delayed(const Duration(milliseconds: 1000)).then((dynamic val) {
    //   if (Platform.isAndroid) FlutterCommon().createNotificationChannel();
    //   initUniLinks();
    //   initRoomPlugins();
    // });
    _launchLoading();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    ScreenUtils.ins.updateScreenWidth(
        MediaQueryData.fromWindow(WidgetsBinding.instance.window));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    RLog.i("RootPage:didChangeAppLifecycleState");
    if (state == AppLifecycleState.resumed) {
      // GlobalConfig.appLifecycleActive = true;
      RLog.i("RootPage:切换到了前台");
    } else if (state == AppLifecycleState.paused) {
      // GlobalConfig.appLifecycleActive = false;
      RLog.i("RootPage:切换到了后台");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UnreadMessageCountModel()),
        // ChangeNotifierProvider(create: (_) {
        //   var mainModel = MainPageModel();
        //   mainModel.initGlobalAnimationController(this, context);
        //   return mainModel;
        // }),
        ChangeNotifierProvider(create: (_) => LoginPageModel()),
      ],
      child: ScreenUtilInit(
          designSize: const Size(375, 812),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {
            return GetMaterialApp(
              builder: (BuildContext context, Widget? child) {
                return DefaultTextStyle(
                  style: const TextStyle(
                      fontFamily: fontFamily,
                      fontFamilyFallback: [fontFamilyFallback]),
                  child: MediaQuery(
                    //设置文字大小不随系统设置改变
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
                    child: FlutterGlobalNotice(
                      child: FlutterEasyLoading(
                        child: child!,
                        // child: StreamBuilder<ThemeStyle>(
                        //     stream: JR.subscribeThemeStyle,
                        //     builder: (context, snapshot) {
                        //       return child!;
                        //     }),
                      ),
                    ),
                  ),
                );
              },
              // ignore: prefer_const_literals_to_create_immutables
              // theme: defaultThemeData,
              title: "YayChat",
              locale: const Locale.fromSubtags(languageCode: 'en'),
              navigatorKey: rootNavigatorState,
              initialBinding: InitialBinding(),
              navigatorObservers: [
                appNavigatorObserver,
                _firebaseAnalyticsObserver,
                routeObserver
              ],
              localeResolutionCallback: onLocaleResolutionCallback,
              localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
                // T.delegate,
                // GlobalMaterialLocalizations.delegate,
                // GlobalWidgetsLocalizations.delegate,
                // GlobalCupertinoLocalizations.delegate,
              ],
              routes: {
                // JrNavigator.NAVIGATOR_URL_WORKBENCH: (BuildContext context) =>
                //     const WorkBenchMainPage(), //注册嘉宾工作台路由
              },
              // supportedLocales: T.delegate.supportedLocales,
              home: _renderHome(),
            );
          }),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _linkStream?.cancel();
    super.dispose();
  }

  // initUniLinks() async {
  //   _linkStream = getLinksStream().listen((String? link) {
  //     RLog.d('getLinksStreamlink: $link $mounted');
  //     if (!mounted) return;
  //     if (link != null) {
  //       SchemeHelper.checkAndGo(context, link);
  //       resetLink();
  //     }
  //   }, onError: (err) {
  //     if (!mounted) return;
  //   });
  //
  //   String? initialLink;
  //   try {
  //     if (Platform.isAndroid) {
  //       initialLink = await getLatestLink();
  //     } else {
  //       initialLink = await getInitialLink();
  //     }
  //     RLog.d('initial link: $initialLink $mounted');
  //   } on PlatformException {
  //     RLog.d('Failed to get initial link.');
  //   } on FormatException {
  //     RLog.d('Failed to parse the initial link as Uri.');
  //   }
  //
  //   if (!mounted) return;
  //   if (initialLink != null) {
  //     // SchemeHelper.checkAndGo(context, initialLink);
  //     // resetLink();
  //   }
  // }

  initRoomPlugins() {
    // RoomManager.instance.addPlugin(SudRoomPlugin());
    // RoomManager.instance.addPlugin(CPRoomPlugin());
  }

  Locale? onLocaleResolutionCallback(
      Locale? locale, Iterable<Locale> supportedLocales) {
    // GlobalConfig.updateLanguage(locale?.languageCode);
    if (locale?.languageCode == 'zh') {
      return const Locale.fromSubtags(languageCode: 'zh');
    }
    return const Locale.fromSubtags(languageCode: 'en');
  }

  Widget _renderHome() {
    if (loading) {
      return Container(
        alignment: AlignmentDirectional.center,
        child: const CupertinoActivityIndicator(),
      );
    }
    // if (UserManager.instance.hasLogin()) {
    //   User user = UserManager.instance.currentUser!;
    //   if (user.birthday.isNotEmpty) {
    //     return const MainPage();
    //   } else {
    //     return const AddUserProfilePage();
    //   }
    // }
    return const OSLoginPage();
  }

  _launchLoading() async {
    await MainInit.launchInit();
    loading = false;
    setState(() {});
  }
}

const String fontFamilyFallback = 'PingFang SC';
const String fontFamily = 'Poppins';
