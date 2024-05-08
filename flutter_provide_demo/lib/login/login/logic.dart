import 'package:get/get.dart';

class OSLoginController extends GetxController {
  bool protocolSelect = false;
  // late String areaCode;
  // late TextEditingController textController;
  // late LoginPageModel _loginModel;

  // late List<IThirdLoginPlatform> mainLoginPlatforms;
  // late List<IThirdLoginPlatform> subLoginPlatforms;

  bool loadingPlatforms = true;

  @override
  void onInit() {
    super.onInit();
    // ThirdLoginPlatformFactory.ins.addLoginPlatform(PhoneLoginPlatform());
    // ThirdLoginPlatformFactory.ins.listenLoginEvent.listen((event) {
    //   if (event.suc) {
    //     authSuccessWithThirdPlatform(event.authRsp?.authed,
    //         loginPlatform: event.platform);
    //   } else {
    //     showToast(event.errorMsg ?? T.current.server_exception);
    //   }
    // });
  }

  @override
  void onReady() {
    super.onReady();
    _loadLoginPlatforms();
  }

  @override
  void onClose() {
    super.onClose();
  }

  changeProtocolSelect() {
    protocolSelect = !protocolSelect;
    update(['protocolSelect']);
  }

  changeAreaCode(String code) {
    // areaCode = code;
    // CacheUtil.set(CacheKeys.lastLoginAreaCode, areaCode);
    // update();
  }

  // bool get validMobile => StringUtil.isMobile(textController.text, areaCode: areaCode);

  loginAction() {
    // if (!validMobile) return;
    // if (!protocolSelect) {
    //   AlertShow.showPrivacyAgree(rootNavigatorState.currentContext!, T.current.agree_get_verifition_code, () {
    //     changeProtocolSelect();
    //     _pushVerifySmsPage();
    //   });
    //   return;
    // }
    // _pushVerifySmsPage();
  }

  // thirdLoginAction(IThirdLoginPlatform platform) async {
  //   if (!protocolSelect) {
  //     dynamic re = await AlertShow.showPrivacyAgree(
  //         rootNavigatorState.currentContext!, T.current.agree_login);
  //     if (re == true) {
  //       protocolSelect = true;
  //       update(['protocolSelect']);
  //       platform.login(rootNavigatorState.currentContext!);
  //     }
  //   } else {
  //     platform.login(rootNavigatorState.currentContext!);
  //   }
  // }
  //
  // authSuccessWithThirdPlatform(AuthRsp? resultData,
  //     {LoginPlatform? loginPlatform}) async {
  //   try {
  //     showLoadingDialog();
  //     var result = await LoginManager.instance.loginSuccessUpdateInfo(
  //         LoginType.autoLogin, resultData?.token ?? '',
  //         loginPlatform: loginPlatform);
  //     if (result) {
  //       LoginManager.instance.loginSuccessJump();
  //     } else {
  //       showToast(T.current.server_exception);
  //     }
  //   } catch (e) {
  //     showToast(e.toString());
  //   } finally {
  //     dismissLoadingDialog();
  //   }
  // }

  void _loadLoginPlatforms() async {
    // var rsp = await LoginApi.instance.getLoginPlatforms();
    // mainLoginPlatforms = [];
    // subLoginPlatforms = [];
    // if (rsp.isSuccess && rsp.data != null) {
    //   for (String platform in rsp.data!.mainPlatforms) {
    //     IThirdLoginPlatform? thirdLoginPlatform =
    //         ThirdLoginPlatformFactory.ins.getPlatform(platform);
    //     if (thirdLoginPlatform != null) {
    //       mainLoginPlatforms.add(thirdLoginPlatform);
    //     }
    //   }
    //   for (String platform in rsp.data!.subPlatforms) {
    //     IThirdLoginPlatform? thirdLoginPlatform =
    //         ThirdLoginPlatformFactory.ins.getPlatform(platform);
    //     if (thirdLoginPlatform != null) {
    //       subLoginPlatforms.add(thirdLoginPlatform);
    //     }
    //   }
    // }
    // if (mainLoginPlatforms.isEmpty) {
    //   _setupDef();
    // }

    loadingPlatforms = false;
    update();
  }

  void _setupDef() {
    // for (LoginPlatform platform in _defaultMainPlatforms) {
    //   IThirdLoginPlatform? thirdLoginPlatform =
    //       ThirdLoginPlatformFactory.ins.getPlatform(platform.name);
    //   if (thirdLoginPlatform != null) {
    //     mainLoginPlatforms.add(thirdLoginPlatform);
    //   }
    // }
    // for (LoginPlatform platform in _defaultSubPlatforms) {
    //   IThirdLoginPlatform? thirdLoginPlatform =
    //       ThirdLoginPlatformFactory.ins.getPlatform(platform.name);
    //   if (thirdLoginPlatform != null) {
    //     subLoginPlatforms.add(thirdLoginPlatform);
    //   }
    // }
  }
}

// var _defaultMainPlatforms = [
//   if (Platform.isIOS) LoginPlatform.apple,
//   LoginPlatform.google,
// ];
//
// var _defaultSubPlatforms = [
//   if (GlobalConfig.isDebug) LoginPlatform.phone,
// ];
