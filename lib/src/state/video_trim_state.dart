import 'package:flutter/foundation.dart';
import 'package:flutter/painting.dart';
import '../models/export/video_trim_config.dart';

class VideoTrimState extends ChangeNotifier {
  VideoTrimConfig _config;

  VideoTrimState({required VideoTrimConfig config}) : _config = config;

  VideoTrimConfig get config => _config;

  void setStart(Duration start) {
    _config = _config.copyWith(startTrim: start);
    notifyListeners();
  }

  void setEnd(Duration end) {
    _config = _config.copyWith(endTrim: end);
    notifyListeners();
  }

  void setCrop(Offset minCrop, Offset maxCrop) {
    _config = _config.copyWith(minCrop: minCrop, maxCrop: maxCrop);
    notifyListeners();
  }

  void rotate90() {
    _config = _config.copyWith(rotation: (_config.rotation + 90) % 360);
    notifyListeners();
  }

  Duration get trimmedDuration => _config.trimmedDuration;
}
