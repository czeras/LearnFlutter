import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:audioplayers/audioplayers.dart';

import '../utils/log/r_logs.dart';
import '../utils/string_utils.dart';

class AudioController extends GetxController with WidgetsBindingObserver {
  static const PLAY_STATE_ID = 'audio.play.state';
  static const DURATION_CHANGE_ID = 'audio.duration.change';

  late AudioPlayer _audioPlayer;

  String _audioSource = '';
  Duration _playingDuration = Duration.zero;
  Duration _audioDuration = Duration.zero;

  late StreamSubscription _subPlayingDuration;
  late StreamSubscription _subAudioDuration;

  @override
  void onInit() {
    super.onInit();
    _audioPlayer = AudioPlayer();
    _subPlayingDuration = _audioPlayer.onPositionChanged.listen((duration) {
      _playingDuration = duration;
      RLog.d('onPositionChanged == $duration');
      update([DURATION_CHANGE_ID]);
    });
    _subAudioDuration = _audioPlayer.onDurationChanged.listen((duration) {
      _audioDuration = duration;
    });
    _audioPlayer.onPlayerStateChanged.listen((event) {
      RLog.d('onPlayerStateChanged == $event');
      update([PLAY_STATE_ID]);
    });

    WidgetsBinding.instance.addObserver(this);
  }

  void playUrl(String urlOrPath) {
    if (StringUtil.equalIgnoreCase(urlOrPath, _audioSource)) {
      if (_audioPlayer.state == PlayerState.playing) {
        _audioPlayer.pause();
      } else {
        RLog.d('playUrl = $urlOrPath');
        _audioPlayer.play(getPlaySource(urlOrPath));
      }
    } else {
      if (_audioPlayer.state == PlayerState.playing) {
        _audioPlayer.stop();
      }
      RLog.d('playUrl = $urlOrPath');
      _audioPlayer.play(getPlaySource(urlOrPath));
    }
    _audioSource = urlOrPath;
    update([PLAY_STATE_ID]);
  }

  Source getPlaySource(String urlOrPath) {
    if (urlOrPath.startsWith('http')) {
      return UrlSource(urlOrPath);
    }
    if (urlOrPath.startsWith('assets') ||
        (urlOrPath.startsWith('packages') && urlOrPath.contains('assets'))) {
      return AssetSource(urlOrPath);
    }
    return DeviceFileSource(urlOrPath);
  }

  bool isPlaying(String url) {
    return StringUtil.equalIgnoreCase(url, _audioSource) &&
        _audioPlayer.state == PlayerState.playing;
  }

  Duration getCurrentDuration(String url) {
    if (StringUtil.equalIgnoreCase(url, _audioSource)) {
      return _playingDuration;
    } else {
      return Duration.zero;
    }
  }

  Duration get audioDuration => _audioDuration;

  void release() {
    _audioSource = '';
    _audioPlayer.stop();
    _audioPlayer.release();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      // playUrl(_audioSource);
    } else {
      _audioPlayer.pause();
    }
  }

  @override
  void onClose() {
    _subPlayingDuration.cancel();
    _subAudioDuration.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.onClose();
  }
}
