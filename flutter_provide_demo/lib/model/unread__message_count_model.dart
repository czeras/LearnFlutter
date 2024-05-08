import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter_common/flutter_common.dart';
// import 'package:lib_im/lib_im.dart';

//全局未读消息model  来消息也公用该model
class UnreadMessageCountModel extends ChangeNotifier {
  UnreadMessageCountModel() {
    initData();
  }

  int unreadMessageCount = 0;

  initData() async {}

  updateUnreadMessageCount(int count) {
    log('hlylog：拉取的消息总的未读数：${count}');
    unreadMessageCount = count;
    // FlutterCommon.ins.setBadgeNumber(count);
    notifyListeners();
  }

  // EMMessage? imMessage;
  // startShowIMAnimation(EMMessage message) {
  //   imMessage = message;
  //   // unreadMessageCount = count;
  //   notifyListeners();
  // }
}
