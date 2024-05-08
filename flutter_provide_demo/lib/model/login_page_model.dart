import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/log/r_logs.dart';
import 'jr_change_notifier.dart';
import 'user_constants.dart';
// import 'package:gallery_saver/gallery_saver.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:intl/intl.dart';
// import 'package:lib_basemodel/server_client/base.pb.dart';
// import 'package:lib_basemodel/server_client/cold.pbserver.dart';
// import 'package:lib_basemodel/server_client/invite_code.pb.dart';
// import 'package:lib_basemodel/server_client/leader.pb.dart';
// import 'package:lib_basemodel/server_client/login.pb.dart';
// import 'package:lib_basemodel/server_client/user.pb.dart';
// import 'package:lib_baseview/lib_baseview.dart';
// import 'package:lib_network/lib_network.dart';
// import 'package:lib_network/src/api/leader_api.dart';
// import 'package:lib_runtime/lib_runtime.dart';
// import 'package:lib_user/lib_user.dart';
// import 'package:m_login/m_login.dart';
// import 'package:m_login/src/util/login_manager.dart';
// import 'package:m_login/src/util/login_regex_util.dart';
// import 'package:m_login/src/util/login_storage.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
// import 'package:third_login_platform/third_login_platform.dart';
// import 'login_args.dart';
// import 'package:lib_basemodel/lib_basemodel.dart';

// 冷启动的角色
enum RegisterRole { carOwner, gs, singer }

class LoginPageModel extends JRChangeNotifier {
  static const tag = "Login-LoginPageModel";

  VoidCallback? bindingPhoneCallBack;
  // void Function(AuthRsp? resultData)? appleIdLoginCallBack;

  TextEditingController textEditingController = TextEditingController();
  var phoneText = "";
  var privacyProtocolSelected = false;
  var isSelectPhoto = false;

  Timer? _timer;
  var sendSmsWaitTime = 0;

  String authTag = "";

  // User currUser = User();
  String localAvatar = "";
  String? _errorUserName;

  String? invitationCode;

  //角色选择
  RegisterRole? currRole;

  Timer? _gsProtocolTimer;
  var _readGsProtocolWaitTime = 0;

  int get readGsProtocolWaitTime => _readGsProtocolWaitTime;

  //经历展示
  StreamController streamController = StreamController();
  List<String> images = [];
  String? gsProtocolUrl;

  ///嘉宾个人主页
  String? homePageUrl;

  bool? coldStart;

  // //注册流程的步骤
  // RegisterStep? serverStep;
  ///车辆行驶证
  String drivingLicenseUrl = '';

  // // 查询审核记录数据
  // UserApprovalRecordResp? userApprovalRecordResp;

  // 查询审核状态
  // UserApprovalRecordStatus? get userApprovalRecordStatus => userApprovalRecordResp?.status;
  // ColdRoleSelectConfig? coldRoleSelectConfig;

  LoginPageModel() {
    initData();
  }

  initData() async {
    RLog.i('LoginPageModel:initData');
    images.clear();
    updateGender(UserConstants.genderMan);
  }

  writeNewUserInfo() async {
    try {
      // await CacheUtil.saveObject("newUserInfoKey", "false");
    } catch (e, _) {
      RLog.e("$tag, writeUserInfoKey error: $e");
    }
  }

  // void setColdRoleSelectData(ColdRoleSelectConfig? coldRoleSelectConfig) {
  //   coldRoleSelectConfig = coldRoleSelectConfig;
  // }

  updatePrivacyProtocolSelected() {
    privacyProtocolSelected = !privacyProtocolSelected;
    notifyListeners();
  }

  // Future<bool> saveAvatar(XFile file) async {
  //   showLoadingDialog(status: T.current.saving);
  //   var uploadRsp = await UserInfoEditApi.instance.savePicture(File(file.path));
  //   dismissLoadingDialog();
  //   if (uploadRsp == null) {
  //     showToast(T.current.retry_save_fail);
  //     return false;
  //   }
  //   UserInfoUpdateReq userInfoUpdateReq = UserInfoUpdateReq.create();
  //   userInfoUpdateReq.avatarUrl = uploadRsp;
  //   userInfoUpdateReq.register = true;
  //   var userResponse = await UserInfoEditApi.instance.modifyData(userInfoUpdateReq);
  //   if (!userResponse.isSuccess) {
  //     dismissLoadingDialog();
  //     showToast(userResponse.errorMsg!);
  //     return false;
  //   } else {
  //     currUser.avatar = uploadRsp;
  //     localAvatar = currUser.avatar;
  //
  //     dismissLoadingDialog();
  //     notifyListeners();
  //     return true;
  //   }
  // }

  static String sha256ByString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  //ios AppleID登陆
  // Future<AuthorizationCredentialAppleID> appleIDLogin() async {
  //   final rawNonce = generateNonce();
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.fullName,
  //       AppleIDAuthorizationScopes.email,
  //     ],
  //     nonce: sha256ByString(rawNonce),
  //   );
  //   RLog.i("identityToken: ${credential.identityToken} email:${credential.email}");
  //   return credential;
  // }

  //苹果授权成功处理
  handleAppleIDLoginResult(String? token, String? name) {
    // if (token != null) {
    //   AppleAuthReq req = AppleAuthReq();
    //   req.idToken = token;
    //   if (name != null && name.isNotEmpty) {
    //     req.nickname = name;
    //   }
    //
    //   LoginApi.instance.appleIDAuth(req).then((value) async {
    //     ExternalAuthRsp? externalAuthRsp = value.data;
    //     if (value.isSuccess) {
    //       if (externalAuthRsp?.newUserInfoKey != "" && externalAuthRsp?.newUserInfoKey != null) {
    //         await LoginStorage.instance.saveNewUserInfoKey(externalAuthRsp?.newUserInfoKey ?? "");
    //         //去绑定手机号
    //         bindingPhoneCallBack?.call();
    //       } else {
    //         //已经绑定过手机号
    //         await LoginStorage.instance.saveNewUserInfoKey("");
    //         var resultData = externalAuthRsp?.authed;
    //         if (appleIdLoginCallBack != null) {
    //           appleIdLoginCallBack!(resultData);
    //         }
    //       }
    //     }
    //   });
    // }
  }

  bool isShowErrorUserTip() {
    return _errorUserName != null && _errorUserName == "nickname";
  }

  Future<bool> login(String code) async {
    return true;
    // var userInfoKey = await LoginStorage.instance.readUserInfoKey();
    // var loginInfo = LoginArgs(type: LoginType.sms, phone: "+86$phoneText", authCode: code,loginPlatform: LoginPlatform.phone);
    // if (userInfoKey != null && userInfoKey.isNotEmpty) {
    //   loginInfo.userInfoKey = userInfoKey;
    // }
    // try {
    //   var result = await LoginManager.instance.login(loginInfo);
    //   cancelSmsTimer();
    //   sendSmsWaitTime = 0;
    //   if (!result.isSuccess) {
    //     dismissLoadingDialog();
    //     RLog.i("$tag Login error: $e");
    //     notifyListeners();
    //     return false;
    //   } else {
    //     var cachedUser = UserManager.instance.currentUser;
    //     if (cachedUser != null) {
    //       currUser = cachedUser;
    //     }
    //     return true;
    //   }
    // } catch (e) {
    //   showToast(T.current.retry_system_error);
    //   sendSmsWaitTime = 0;
    //   cancelSmsTimer();
    //   notifyListeners();
    //   return false;
    // }
  }

  void startSmsTimer(int totalTime) {
    sendSmsWaitTime = totalTime;
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (sendSmsWaitTime > 0) {
          sendSmsWaitTime--;
        } else {
          cancelSmsTimer();
        }
        notifyListeners();
      },
    );
  }

  //获取验证码
  checkSendSms() async {
    RLog.i("$tag checkSendSms sendSmsWaitTime:$sendSmsWaitTime");
    if (sendSmsWaitTime <= 0) {
      authTag = (Random().nextInt(999) + 1000).toString();
      // var result = await LoginApi.instance.sendSms(phoneText, authTag);
      // RLog.i("result: $result");
      // if (!result.isSuccess) {
      //   dismissLoadingDialog();
      //   showToast(result.errorMsg ?? T.current.send_fail);
      //   return false;
      // }
      startSmsTimer(60);
    }
  }

  void cancelSmsTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void setPhone(String text) {
    phoneText = text;
    notifyListeners();
  }

  void clearnPhone() {
    phoneText = "";
    textEditingController.clear();
    notifyListeners();
  }

  void setPrivacyProtocolSelected(bool selected) {
    privacyProtocolSelected = selected;
    notifyListeners();
  }

  bool checkInput() {
    // if (!LoginRegexUtil.isPhone(phoneText)) {
    //   showToast(T.current.please_input_right_phone);
    //   return false;
    // }
    return true;
  }

  void refreshPage() {
    notifyListeners();
  }

  updateGender(String gender) {
    // currUser.gender = gender;
    notifyListeners();
  }

  // Future<bool> updateUser(User user) async {
  //   UserInfoUpdateReq req = UserInfoUpdateReq.create()
  //     ..gender = user.gender
  //     ..nickname = user.nickname
  //     ..birthday = user.birthday
  //     ..register = true;
  //
  //   if (invitationCode != null && invitationCode!.isNotEmpty) {
  //     req.inviteCode = invitationCode!;
  //   }
  //   BaseRspResult<UserInfoRsp> result;
  //   try {
  //     result = await UserApi.instance.updateUserInfo(req);
  //     if (!result.isSuccess) {
  //       dismissLoadingDialog();
  //       showToast(result.errorMsg ?? T.current.update_info_fail);
  //       return false;
  //     }
  //     var response = await UserManager.instance.refreshUserInfo();
  //     if (response) {
  //       currUser = UserManager.instance.currentUser ?? User();
  //     }
  //     return true;
  //   } catch (e) {
  //     return false;
  //   }
  // }

  void readUserInfo() async {
    // currUser = UserManager.instance.currentUser ?? User.create();
    // localAvatar = currUser.avatarShow;
    notifyListeners();
  }

  void log(String? msg) {
    RLog.i("$runtimeType $msg");
  }

  void updateCurrRole(RegisterRole role) {
    currRole = role;
    notifyListeners();
  }

  void _startGsProtocolTimer(int totalTime) {
    _readGsProtocolWaitTime = totalTime;
    const oneSec = Duration(seconds: 1);
    _gsProtocolTimer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_readGsProtocolWaitTime > 0) {
          _readGsProtocolWaitTime--;
        } else {
          cancelGsProtocolTimer();
        }
        notifyListeners();
      },
    );
  }

  void cancelGsProtocolTimer() {
    _gsProtocolTimer?.cancel();
    _gsProtocolTimer = null;
  }

  Future<bool> requestProtocolUrl() async {
    if (_readGsProtocolWaitTime > 0) {
      _startGsProtocolTimer(_readGsProtocolWaitTime);
      return true;
    } else {
      notifyListeners();
      _startGsProtocolTimer(5);
    }
    return true;
  }

  // saveRegisterProgress(RegisterStep step) async {
  //   var result = await UserApi.instance.saveRegisterProgress(step);
  //   if (!result.isSuccess) {
  //     showToast(T.current.save_register_fail);
  //   }
  // }

  // restoreRegisterProgress(BuildContext context) async {
  //   var result = await UserApi.instance.getRegisterProgress();
  //   if (!result.isSuccess || result.data == null) {
  //     if (mounted) {
  //       await showRideCommonDialog(
  //           context: context,
  //           title: T.current.exit_app,
  //           content: Text(T.current.request_error_reopen_app),
  //           onConfirm: () {
  //             SystemNavigator.pop();
  //           });
  //     }
  //     return;
  //   }
  //   var data = result.data!;
  //   serverStep = data.step;
  //   currRole = data.job == Job.BOSS ? RegisterRole.carOwner : RegisterRole.gs;
  // }

  modifyBirthday(DateTime birthday) {
    // currUser.birthday = DateFormat("yyyy-MM-dd").format(birthday);
    // RLog.i("modifyBirthday ${currUser.birthday}");
    notifyListeners();
  }

  //嘉宾自我介绍音频保存
  Future<bool> saveIntroductionUrl(
      String vocWall, int voiceTotalDuration) async {
    // return (await _saveVoice(true, vocWall, voiceTotalDuration));
    return true;
  }

  //嘉宾才艺展示
  Future<bool> saveTalentShowUrl(String vocWall, int voiceTotalDuration) async {
    // return (await _saveVoice(false, vocWall, voiceTotalDuration));
    return true;
  }

  // Future<bool> _saveVoice(bool isIntroduction, String vocWall, int voiceTotalDuration) async {
  //   showLoadingDialog(status: T.current.saving);
  //   var uploadRsp = await UserInfoEditApi.instance.saveVoice(vocWall);
  //   if (uploadRsp == null) {
  //     dismissLoadingDialog();
  //     showToast(T.current.retry_save_fail);
  //     return false;
  //   } else {
  //     GsRegisterReq req = GsRegisterReq.create();
  //     if (isIntroduction) {
  //       req.introductionUrl = uploadRsp;
  //       req.introductionTime = voiceTotalDuration;
  //     } else {
  //       req.talentShowTime = voiceTotalDuration;
  //       req.talentShowUrl = uploadRsp;
  //     }
  //     var result = await UserApi.instance.saveRegisterUrl(req);
  //     if (!result.isSuccess) {
  //       dismissLoadingDialog();
  //       showToast(result.errorMsg!);
  //       return false;
  //     }
  //     // await getRegisterInfo();
  //     notifyListeners();
  //     dismissLoadingDialog();
  //     return true;
  //   }
  // }

  Future<bool> savePictureToGallery(String picPath) async {
    // showToast(T.current.saving);
    // var result = await GallerySaver.saveImage(picPath, albumName: 'Media');
    // if (result ?? false) {
    //   return true;
    // } else {
    //   showToast(T.current.save_fail);
    //   return false;
    // }
    return true;
  }

  // Future<bool> savePicture(XFile picWall) async {
  //   var uploadRsp = await UserInfoEditApi.instance.savePicture(File(picWall.path));
  //   if(uploadRsp != null){
  //     images.add(uploadRsp);
  //     notifyListeners();
  //   }else{
  //     showToast(T.current.retry_save_fail);
  //   }
  //   return true;
  // }

  Future<bool> uploadImagesToServer(List<String> images) async {
    // var req = GsRegisterReq.create();
    // if (images.isNotEmpty) {
    //   req.picList.addAll(images);
    // } else {
    //   req.clearPics = true;
    // }
    // var result = await UserApi.instance.saveRegisterUrl(req);
    // return result.isSuccess;

    return true;
  }

  Future<bool> delPicture(String pic) async {
    images.remove(pic);
    notifyListeners();
    return true;
  }

  Future<bool> saveRRole(RegisterRole role) async {
    // showLoadingDialog(status: T.current.saving);
    // var req = GsRegisterReq.create();
    // if (role == RegisterRole.carOwner) {
    //   req.job = Job.BOSS;
    // } else {
    //   req.job = Job.GS;
    // }
    //
    // var result = await UserApi.instance.saveRegisterUrl(req);
    // if (!result.isSuccess) {
    //   dismissLoadingDialog();
    //   showToast(result.errorMsg!);
    //   return false;
    // } else {
    //   notifyListeners();
    //   dismissLoadingDialog();
    return true;
    // }
  }

  // 冷启动选择角色
  // Future<bool> saveColdRoleChoose(GsRegisterReq req) async {
  //   showLoadingDialog();
  //   var result = await UserApi.instance.saveRegisterUrl(req);
  //   if (!result.isSuccess) {
  //     dismissLoadingDialog();
  //     showToast(result.errorMsg!);
  //     return false;
  //   } else {
  //     notifyListeners();
  //     dismissLoadingDialog();
  //     return true;
  //   }
  // }

  // 提交审核
  // Future<bool> submitApproval(SubmitApprovalReq req) async {
  //   var result = await UserApi.instance.submitApproval(req);
  //   if (!result.isSuccess) {
  //     dismissLoadingDialog();
  //     showToast(result.errorMsg!);
  //     return false;
  //   } else {
  //     notifyListeners();
  //     dismissLoadingDialog();
  //     return true;
  //   }
  // }

  //提交车手行驶证
  // Future<bool> submitBossCarCer() async {
  //   var result = await UserApi.instance.submitCarPicForOCR();
  //   if (!result.isSuccess) {
  //     showToast(result.errorMsg!);
  //     return false;
  //   } else {
  //     return result.data!.ok;
  //   }
  // }

  ///提交上传的行驶证到服务器
  Future<bool> saveDrivingLicenseToServer() async {
    // var req = GsRegisterReq.create();
    // req.drivingLicense.add(drivingLicenseUrl);
    // var result = await UserApi.instance.saveRegisterUrl(req);
    // return result.isSuccess;
    return true;
  }

  //车手驾驶证保存
  // Future<bool> saveDrivingLicenseUrl(XFile picWall, bool? isAuthCenter) async {
  //   showLoadingDialog(status: T.current.saving);
  //   try {
  //     ///上传文件到cdn
  //     var uploadRsp = await UserInfoEditApi.instance.savePicture(File(picWall.path));
  //     if (uploadRsp == null) {
  //       dismissLoadingDialog();
  //       showToast(T.current.retry_save_fail);
  //       return false;
  //     } else {
  //       Reporter.track(TrackEvent.vehicle_certification, {
  //         "step": "upload",
  //         "refer": isAuthCenter == true ? "personal" : "retister",
  //       });
  //       drivingLicenseUrl = uploadRsp ?? '';
  //       notifyListeners();
  //       dismissLoadingDialog();
  //       return true;
  //     }
  //   } catch (e) {
  //     dismissLoadingDialog();
  //     return false;
  //   }
  // }

  //行驶证图片删除
  Future<bool> delDrivingLicenseUrl(String pic,
      {bool showLoading = true}) async {
    drivingLicenseUrl = '';
    notifyListeners();
    return true;
  }

  getUserInfo() {
    // currUser = UserManager.instance.currentUser ?? User();
    notifyListeners();
  }

  updateHomePageUrl() async {
    log("updateHomePageUrl homePageUrl: $homePageUrl");
    if (homePageUrl == null || homePageUrl!.isEmpty) {
      //不设置url，可以进行跳转
      // Reporter.track(TrackEvent.GS_certification, {
      //   "step": "we_media",
      //   "is_wemedia": false,
      // });
      return true;
    }
    Uri? uri = Uri.tryParse(homePageUrl ?? "");
    if (uri == null) {
      // showToast(T.current.link_format_error);
      // Reporter.track(TrackEvent.GS_certification, {
      //   "step": "we_media",
      //   "is_wemedia": false,
      // });
      return;
    }
    // showLoadingDialog();
    // var req = GsRegisterReq.create();
    // req.homePageUrl = homePageUrl ?? "";
    // var result = await UserApi.instance.saveRegisterUrl(req);
    // if (!result.isSuccess) {
    //   dismissLoadingDialog();
    //   showToast(result.errorMsg!);
    //   Reporter.track(TrackEvent.GS_certification, {
    //     "step": "we_media",
    //     "is_wemedia": false,
    //   });
    //   return false;
    // }
    // Reporter.track(TrackEvent.GS_certification, {
    //   "step": "we_media",
    //   "is_wemedia": true,
    // });
    // dismissLoadingDialog();
    return mounted;
  }

  //视频录制保存视频
  Future<bool> saveVideo(String path, int videoDuration) async {
    // showLoadingDialog(status: T.current.saving);
    // var uploadRsp = await UserInfoEditApi.instance.saveVoice(path);
    // if (uploadRsp == null) {
    //   dismissLoadingDialog();
    //   showToast(T.current.retry_save_fail);
    //   return false;
    // } else {
    //   GsRegisterReq req = GsRegisterReq.create();
    //   req.videoAuthUrl = uploadRsp;
    //   req.videoAuthTime = videoDuration;
    //   var result = await UserApi.instance.saveRegisterUrl(req);
    //   if (!result.isSuccess) {
    //     dismissLoadingDialog();
    //     showToast(result.errorMsg!);
    //     return false;
    //   }

    // await getRegisterInfo();
    notifyListeners();
    // dismissLoadingDialog();
    // showToast(T.current.save_suc);
    return true;
  }

  Future<bool> loadColdRoleChooseData() async {
    // showLoadingDialog();
    // var result = await UserApi.instance.getRoleChooseData();
    // if (!result.isSuccess) {
    //   dismissLoadingDialog();
    //   showToast(T.current.data_load_some_error(result.errorMsg??''));
    //   return false;
    // } else {
    //   dismissLoadingDialog();
    //   setColdRoleSelectData(result.data);
    return true;
    // }
  }

  //查询审核状态
  // Future<UserApprovalRecordResp?> queryApprovalRecordData() async {
  //   var result = await UserApi.instance.queryApprovalRecord();
  //   if (!result.isSuccess) {
  //     dismissLoadingDialog();
  //     showToast(result.errorMsg ?? T.current.retry_system_error);
  //     return null;
  //   } else {
  //     userApprovalRecordResp = result.data;
  //     return userApprovalRecordResp;
  //   }
  // }

  //获取是否有会长
  // Future<GetLeaderResp?> queryHasLeader() async {
  //   var result = (await TeamLeaderApi.instance.getLeaderInfo()).data;
  //   if (result != null) {
  //     return result;
  //   }
  //   return null;
  // }

  // showPrivacyAgree(BuildContext context, String confirmText, VoidCallback onConfirmTap) async {
  //   FocusManager.instance.primaryFocus?.unfocus();
  //   Future.delayed(
  //     const Duration(milliseconds: 200),
  //         () =>
  //         JRDialog.showCommonDialog(
  //           context: context,
  //           data: PicTextWithVerticalBtnDialogData(
  //             title: T.current.kind_tips,
  //             desc: '',
  //             firstBtnText: confirmText,
  //             secondBtnText: T.current.not_agree,
  //             onFirstBtnPress: () {
  //               onConfirmTap();
  //               return Future.value(false);
  //             },
  //             descWidget: RichText(
  //               textAlign: TextAlign.center,
  //               text: TextSpan(
  //                 style: const TextStyle(color: Color(0xFFB5B5B5), fontSize: 14.0, height: 22 / 14),
  //                 children: [
  //                   TextSpan(
  //                     text: T.current.read_protocol_tips,
  //                   ),
  //                   TextSpan(
  //                     text: T.current.app_user_privacy_format,
  //                     style: const TextStyle(color: Color(0xFF333333), fontWeight: FontWeight.bold),
  //                     recognizer: TapGestureRecognizer()
  //                       ..onTap = () async {
  //                         Navigator.of(context).push(MaterialPageRoute(builder: (context) {
  //                           return PrivacyWebView(
  //                             title: T.current.app_manger_standard,
  //                             url: "${UrlConfig.protocolDomain}/guanliguifan.html",
  //                           );
  //                         }));
  //                       },
  //                   ),
  //                   TextSpan(
  //                     text: T.current.app_standard_promise,
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           ),
  //         ),
  //   );
  // }
  //
  // Future<BaseRspResult> useInviteCode(String code) async{
  //   UseInviteCodeReq req = UseInviteCodeReq.create()
  //     ..code = code.toLowerCase();
  //   return await UserApi.instance.useInviteCode(req);
  // }

  /// 重新填写需要清除部分数据
  clearHistoryInfo() async {
    // images.clear();
    // homePageUrl = '';
    // drivingLicenseUrl = '';
  }

  ///退出登录需要清除数据
  clearAllInfo() {
    // privacyProtocolSelected = false;
    // isSelectPhoto = false;
    // sendSmsWaitTime = 0;
    // authTag = "";
    // currUser = User();
    // localAvatar = "";
    // _errorUserName = "";
    // invitationCode = "";
    // currRole = null;
    // _readGsProtocolWaitTime = 0;
    // images.clear();
    // gsProtocolUrl = null;
    // homePageUrl = null;
    // coldStart = null;
    // serverStep = null;
    // userApprovalRecordResp = null;
    // coldRoleSelectConfig = null;
    // drivingLicenseUrl = '';
  }
}
