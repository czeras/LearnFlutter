import 'package:get/get.dart';
import 'audio_controller.dart';

/// 全局的controller
class InitialBinding extends Bindings {
  @override
  void dependencies() {
    GetInstance().lazyPut(() => AudioController(), permanent: true);
  }
}
