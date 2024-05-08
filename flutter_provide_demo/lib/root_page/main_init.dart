import 'dart:io';

import '../utils/log/r_logs.dart';

// import 'package:lib_basechannels/pigeon_generate/common_api_impl.dart';
// import 'package:lib_basemodel/lib_basemodel.dart';
// import 'package:lib_basemodel/server_client/common/app.pbenum.dart';
// import 'package:lib_basemodel/we_dart/lib_basechannels/proto/common_api.pb.dart';
// import 'package:lib_baseview/lib_baseview.dart';
// import 'package:lib_im/lib_im.dart';
// import 'package:lib_network/lib_network.dart';
// import 'package:lib_pay/lib_pay.dart';
// import 'package:lib_runtime/lib_runtime.dart';
// import 'package:lib_user/lib_user.dart';
// import 'package:m_chatroom/m_chatroom.dart';
// import 'package:m_login/m_login.dart';
// import 'package:shanmeng/shanmeng.dart';
// import 'package:package_info_plus/package_info_plus.dart';

///点击隐私协议同意之后初始化的内容
class MainInit {
  // static initIM() async {
  //   //必现要等im初始化之后，才可以调用im相关api
  //   await IMManager.get().init();
  //   var loginListener = LoginManager.instance.loginListener;
  //   loginListener
  //     ..onLogin = (user) async {
  //       //用户登录
  //       RLog.d("loginListener.onLogin() called");
  //       await IMManager.get().autoLogin(user!.emUsername, user.emPwd);
  //     }
  //     ..onLogout = (user) async {
  //       // 用户退出
  //       RLog.d("loginListener.onLogout() called");
  //       await IMManager.get().logout();
  //
  //       // 用户退出登录后，关闭房间
  //       await RootProxyModel.instance?.release();
  //     }
  //     ..onUpdateUserInfo = (user) async {
  //       if (user == null) {
  //         return;
  //       }
  //       //更新用户信息
  //       RLog.d(
  //           "loginListener.onUpdateUserInfo() called user:${user?.toProto3Json()}");
  //       await IMManager.get().loginUser.updateIMUserInfo(
  //         userId: user.id.toString(),
  //         nickname: user.nickname,
  //         avatarUrl: user.avatar,
  //         isMale: user.gender == UserConstants.genderMan,
  //         birth: user.birthday,
  //         signature: user.personalSignature,
  //       );
  //     };
  // }

  static registerEvent() {
    // eventCenter.subscribes([EventConstant.refreshConfInfo]).listen(_eventCallback);
  }

  static Future<bool> appInit() async {
    RLog.d("appInit");
    registerEvent();
    // Shanmeng.ins.init(1687776105,'f92274299d570735036e8d29588eb283');
    // Shanmeng.ins.enable = false;
    /// 数数埋点初始化
    // await Reporter.init();
    // const alog = VeAlogImpl.instance;
    // alog.enable();
    // alog.enableConsoleLog();
    // await initIM();
    // await CommonApi().initSdk(InitSdkReq());
    if (Platform.isIOS) {
      // JRIap.instance;
    }
    // RLog.d("begin auto login...", "main()");
    // var result = await LoginManager.instance
    //     .authLogin("onApplicationCreate");
    // RLog.d("after auto login result = $result", "main()");
    // return result.data ?? false;

    await Future.delayed(Duration(seconds: 3)).then((_) {
      // 这里是延时后需要执行的代码
      print('Action after delay');
    });
    print("xxxxxxxxx");
    return true;
  }

  // static void _eventCallback(Event event) {
  //   switch (event.name) {
  //     case EventConstant.refreshConfInfo:
  //       ConfResp? confResp = event.data;
  //       if (confResp?.hasDisableShanmeng() ?? false) {
  //         Shanmeng.ins.enable = !confResp!.disableShanmeng;
  //       }
  //       break;
  //   }
  // }

  ///启动初始化
  static launchInit() async {
    try {
      // GlobalConfig.logLastTimeDiff('launchInit');
      // JRNetwork.instance.useHttp2 = true;
      // await GlobalConfig.initCommonParam();
      // await GlobalConfig.refreshConfInfo();
      bool hasLogin = await MainInit.appInit();
      RLog.i('checkVersionUpdate$hasLogin');
      await checkVersionUpdate();
      // GlobalConfig.logLastTimeDiff('launchInitEnd');
    } catch (e) {
      RLog.i('launchInitCatch:$e');
    }
  }

  static checkVersionUpdate() async {
    // var result = await AppApi.instance.getVersionUpdateInfo();
    // if (result.isSuccess &&
    //     result.data != null &&
    //     result.data!.updateMod != UpdateMode.NOT_REMIND &&
    //     result.data!.updateLink.isNotEmpty) {
    //   var platform = await PackageInfo.fromPlatform();
    //   if (result.data!.latestVersion == platform.version) {
    //     showToast(T.current.already_latest_version);
    //   } else {
    //     await VersionUpdateWidget.show(
    //         rootNavigatorState.currentContext!, result.data!);
    //   }
    return true;
    // } else {
    //   return true;
    // }
  }
}
