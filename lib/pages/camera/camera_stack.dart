import 'dart:async';
import 'dart:io';
import 'package:trash/pages/camera/camera_state.dart';
import 'package:trash/utils/screen/screen_tool.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CameraStack extends StatefulWidget {
  final CameraState cameraState;
  const CameraStack(this.cameraState);
  @override
  _CameraStackState createState() => _CameraStackState();
}

class _CameraStackState extends State<CameraStack> with WidgetsBindingObserver {
  double _currentScale = 1.0;
  double _baseScale = 1.0;

  //手势触点
  int _pointers = 0;

  CameraState get cameraState => widget.cameraState;

  @override
  void initState() {
    super.initState();
    setCallback();
    cameraState.initCamera();
  }

  setCallback() {
    cameraState.setRebuildFun(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    cameraState.disposeController();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      cameraState.onAppPaused();
    } else if (state == AppLifecycleState.resumed) {
      cameraState.onAppResumed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: _cameraPreviewWidget(),
    );
  }

  Widget _cameraPreviewWidget() {
    return cameraState.photo != null
        ? GestureDetector(
            onTap: () {
              if (cameraState.photo == null) {
                cameraState.predicate();
              } else {
                cameraState.reset();
              }
            },
            child: Image.file(
              File(cameraState.photo!),
              fit: BoxFit.cover,
            ),
          )
        : !cameraState.isCameraPrepared
            ? Container()
            : Listener(
                onPointerDown: (_) => _pointers++,
                onPointerUp: (_) => _pointers--,
                child: CustomCameraPreview(
                  cameraState.controller!,
                  child: LayoutBuilder(builder:
                      (BuildContext context, BoxConstraints constraints) {
                    return GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onScaleStart: _handleScaleStart,
                      onScaleUpdate: _handleScaleUpdate,
                      onTapDown: (details) =>
                          onViewFinderTap(details, constraints),
                    );
                  }),
                ),
              );
  }

  void _handleScaleStart(ScaleStartDetails details) {
    _baseScale = _currentScale;
  }

  Future<void> _handleScaleUpdate(ScaleUpdateDetails details) async {
    //只允许两指缩放
    if (_pointers != 2) {
      return;
    }

    _currentScale = (_baseScale * details.scale)
        .clamp(cameraState.minAvailableZoom, cameraState.maxAvailableZoom);

    try {
      await cameraState.controller?.setZoomLevel(_currentScale);
    } on CameraException catch (_) {}
  }

  void onViewFinderTap(
      TapDownDetails details, BoxConstraints constraints) async {
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    try {
      await cameraState.controller?.setFocusPoint(offset);
    } on CameraException catch (_) {}
  }
}

class CustomCameraPreview extends CameraPreview {
  const CustomCameraPreview(
    CameraController controller, {
    Widget? child,
  }) : super(controller, child: child);
  @override
  Widget build(BuildContext context) {
    Widget? cameraPreview;
    try {
      cameraPreview = controller.buildPreview();
    } catch (_) {}
    return cameraPreview != null
        ? SizedBox.expand(
            child: FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: (_isLandscape()
                        ? controller.value.aspectRatio
                        : (1 / controller.value.aspectRatio)) *
                    100.vh,
                height: 1 * 100.vh,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    cameraPreview,
                    child ?? Container(),
                  ],
                ),
              ),
            ),
          )
        : Container();
  }

  bool _isLandscape() {
    return [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]
        .contains(_getApplicableOrientation());
  }

  DeviceOrientation _getApplicableOrientation() {
    return controller.value.isRecordingVideo
        ? controller.value.recordingOrientation!
        : (controller.value.lockedCaptureOrientation ??
            controller.value.deviceOrientation);
  }
}
