import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:trash/utils/tflite.dart';

class _CameraState {
  Function rebuild;

  _CameraState(this.rebuild);

  setRebuildFun(Function fun) => rebuild = fun;

  List<CameraDescription> _cameras = [];

  CameraController? _controller;

  CameraDescription? _currentCamera;

  ///拍摄照片路径
  String? _photo;

  double minAvailableZoom = 1.0;
  double maxAvailableZoom = 1.0;

  CameraDescription? get _backCamera {
    T? find<T>(List<T> src, bool Function(T) check) {
      final finds = src.where(check).toList();
      return finds.isEmpty ? null : finds.first;
    }

    return find(_cameras, (e) => e.lensDirection == CameraLensDirection.back);
  }

  ///初始化指定相机
  void _initNewCamera(CameraDescription? cameraDescription) async {
    if (cameraDescription == null) return;
    _photo = null;
    try {
      await _controller?.dispose();
    } catch (_) {}
    _controller = null;

    rebuild();

    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.medium,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    try {
      await _controller!.initialize();
    } on CameraException catch (_) {
      return;
    }

    try {
      await _controller!
          .setFlashMode(FlashMode.off)
          .onError((error, stackTrace) => null);
      await _controller!
          .setFocusMode(FocusMode.auto)
          .onError((error, stackTrace) => null);
      await _controller!
          .lockCaptureOrientation(DeviceOrientation.portraitUp)
          .onError((error, stackTrace) => null);

      await Future.wait([
        _controller!
            .getMaxZoomLevel()
            .then((value) => maxAvailableZoom = value),
        _controller!
            .getMinZoomLevel()
            .then((value) => minAvailableZoom = value),
      ]);
      _currentCamera = cameraDescription;
      rebuild();
    } on CameraException catch (_) {
      _controller = null;
    }
  }
}

class CameraState extends _CameraState {
  CameraState(Function rebuild) : super(rebuild);

  ///拍摄照片路径
  String? get photo => _photo;

  CameraController? get controller => _controller;

  ///相机是否准备完毕
  bool get isCameraPrepared => _controller != null;

  ///初始化相机
  Future<void> initCamera() async {
    if (_cameras.isEmpty) {
      try {
        _cameras = await availableCameras();
      } catch (_) {
        //暂无可用相机
        return;
      }
    }
    if (_backCamera == null) {
      // 找不到后置摄像头
      return;
    }
    _initNewCamera(_currentCamera ?? _backCamera!);
  }

  Future<Predication?> predicate() async {
    try {
      Predication? predication;
      final file = await _controller?.takePicture();
      _photo = file?.path;
      rebuild();
      if (_photo != null) {
        predication = await TFLite.predicte(_photo!);
      }
      //关闭相机
      disposeController();
      return predication;
    } catch (_) {
      return null;
    }
  }

  void reset() async {
    initCamera();
  }

  void disposeController() {
    try {
      _controller?.dispose();
    } catch (_) {}
    _controller = null;
  }

  void onAppPaused() async {
    try {
      await _controller?.dispose();
    } catch (_) {}
    _controller = null;
    rebuild();
  }

  void onAppResumed() {
    if (_controller == null || _photo == null) {
      //初始化相机
      initCamera();
    }
  }
}
