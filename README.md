# LearnFlutter

ceshi wenben
LearnFlutter



| 项目名称 | 版本 | 项目说明 |
| -------- | ---- | -------- |
|          |      |          |
|          |      |          |
|          |      |          |





if(userEntity.imToken != null){
  *///* *登录* *im
\*  FHNimHelper()
    ..setAuthStatusListener((status) {
      FHNimHelper().isLogin = status == NIMAuthStatus.loggedIn;
    })
    ..login1(userEntity.uid!, userEntity.imToken!, (success) {
      *///* *登录成功
\*      FHNimHelper().isLogin = true;

​      *///* *更新**im**用户
\*      _updataImUser(userEntity.uid.toString());
​    });

  _logger.v("$*_tag*  更新后imtoken:${UserCenter.*user*.imToken}");
}



UserCenter().review