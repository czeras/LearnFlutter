import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../utils/screen/screen_utils.dart';
import 'logic.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:lib_basemodel/lib_basemodel.dart';
// import 'package:lib_baseview/lib_baseview.dart';
// import 'package:lib_network/lib_network.dart';
// import 'package:lib_runtime/lib_runtime.dart';
// import 'package:m_main/m_main.dart';
// import 'package:third_login_platform_interface/third_login_platform_interface.dart';
// import 'area_code_page.dart';
// import 'os_login_controller.dart';

class OSLoginPage extends StatefulWidget {
  const OSLoginPage({Key? key}) : super(key: key);

  @override
  State<OSLoginPage> createState() => _OSLoginPageState();
}

class _OSLoginPageState extends State<OSLoginPage> {
  final OSLoginController _ctrl = Get.put(OSLoginController());

  @override
  void dispose() {
    Get.delete<OSLoginController>(force: true);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OSLoginController>(builder: (controller) {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            // JR.img('login_bg_img.webp',
            //     width: ScreenUtils.ins.screenWidth, height: 340.w),
            Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadiusDirectional.only(
                    topStart: Radius.circular(24), topEnd: Radius.circular(24)),
                // color: JR.color.mainBackground,
              ),
              padding: EdgeInsetsDirectional.only(
                  start: 30,
                  end: 30,
                  top: 48,
                  bottom: ScreenUtils.ins.iphoneXBottom + 52),
              margin: EdgeInsetsDirectional.only(top: 340.w - 24),
              child: Builder(builder: (context) {
                if (controller.loadingPlatforms) {
                  return const Center(child: CupertinoActivityIndicator());
                }
                return Column(
                  children: [
                    // ...mainLoginPlatforms(controller),
                    // if (GlobalConfig.isDebug)
                    //   Padding(
                    //     padding: const EdgeInsets.all(8.0),
                    //     child: InkWell(
                    //       child: Text("debug_page"),
                    //       onTap: () {
                    //         // DebugPage.show(context);
                    //       },
                    //     ),
                    //   ),
                    const Spacer(),
                    // if (controller.subLoginPlatforms.isNotEmpty)
                    Row(children: [
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            const Color(0xFFD5D5D5).withOpacity(0),
                            const Color(0xFFD5D5D5)
                          ])),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Text(
                        'or',
                        // style: JRTextStyles.styleFont14W400.copyWith(
                        //   color: const Color(0xFFD5D5D5),
                        // ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: Container(
                          height: 1,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                            const Color(0xFFD5D5D5),
                            const Color(0xFFD5D5D5).withOpacity(0)
                          ])),
                        ),
                      )
                    ]),
                    // if (controller.subLoginPlatforms.isNotEmpty)
                    //   const SizedBox(height: 18),
                    // if (controller.subLoginPlatforms.isNotEmpty)
                    Container(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        // children: subLoginPlatforms(controller),
                      ),
                    ),
                    const SizedBox(height: 48),
                    GetBuilder<OSLoginController>(
                        id: 'protocolSelect',
                        builder: (context) {
                          return _protocolWidget();
                        }),
                  ],
                );
              }),
            ),
          ],
        ),
      );
    });
  }

  Widget _protocolWidget() {
    TextStyle defaultStyle =
        const TextStyle(color: Color(0xFF999999), fontSize: 12.0);
    TextStyle linkStyle = const TextStyle(
        color: Color(0xFF4944FF),
        fontSize: 12,
        decoration: TextDecoration.underline);
    var icon = "ic_check_n.png";
    if (_ctrl.protocolSelect) {
      icon = "icon_check_select.webp";
    }
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: defaultStyle,
        children: [
          WidgetSpan(child: InkWell(
            onTap: () {
              _ctrl.changeProtocolSelect();
            },
            // child: Container(
            //   padding: const EdgeInsets.only(left: 10, right: 10),
            //   child: JR.img(icon, width: 12, height: 12),
            // ),
          )),
          TextSpan(
            text: "i_have_read_agree",
          ),
          TextSpan(
            text: "user_agreement_format",
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   // return PrivacyWebView(
                //   //   title: T.current.user_agreement,
                //   //   url: "${UrlConfig.protocolDomain}/yonghufuwu.html",
                //   // );
                // }));
              },
          ),
          TextSpan(
            text: 'with_str ',
          ),
          TextSpan(
            text: "privacy_agreement_format",
            style: linkStyle,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                // Navigator.of(context)
                //     .push(MaterialPageRoute(builder: (context) {
                //   // return PrivacyWebView(
                //   //   title: T.current.privacy_agreement,
                //   //   url: "${UrlConfig.protocolDomain}/yinsi.html",
                //   // );
                // }));
              },
          ),
        ],
      ),
    );
  }

  // List<Widget> mainLoginPlatforms(OSLoginController controller) {
  //   List<Widget> children = [];
  //   for (IThirdLoginPlatform platform in controller.mainLoginPlatforms) {
  //     children.add(FutureBuilder<bool>(
  //         future: platform.supportLogin(),
  //         builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
  //           if (snapshot.connectionState == ConnectionState.done &&
  //               snapshot.data == true) {
  //             return Padding(
  //               padding: const EdgeInsets.only(bottom: 12.0),
  //               child: platform.getLoginButton(context, onTap: () {
  //                 controller.thirdLoginAction(platform);
  //               }),
  //             );
  //           }
  //           return const SizedBox.shrink();
  //         }));
  //   }
  //   return children;
  // }

  // List<Widget> subLoginPlatforms(OSLoginController controller) {
  //   List<Widget> children = [];
  //   for (IThirdLoginPlatform platform in controller.subLoginPlatforms) {
  //     children.add(FutureBuilder<bool>(
  //         future: platform.supportLogin(),
  //         builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
  //           if (snapshot.connectionState == ConnectionState.done &&
  //               snapshot.data == true) {
  //             return GestureDetector(
  //               onTap: () => controller.thirdLoginAction(platform),
  //               child: platform.getIcon(),
  //             );
  //           }
  //           return const SizedBox.shrink();
  //         }));
  //   }
  //   return children;
  // }
}
