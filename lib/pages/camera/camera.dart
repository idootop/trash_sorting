import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:trash/pages/camera/camera_stack.dart';
import 'package:trash/pages/camera/camera_state.dart';
import 'package:trash/pages/search.dart';
import 'package:trash/utils/screen/screen_tool.dart';
import 'package:trash/utils/tflite.dart';
import 'package:trash/widgets/base.dart';

class CameraPage extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final rebuildFlag = useState(false);
    final loading = useState(false);
    rebuild() => rebuildFlag.value = !rebuildFlag.value;
    final cameraState = useRef(CameraState(rebuild)).value;

    final prediction = useState<Predication?>(null);

    final probability = (prediction.value?.probability ?? 0);
    final probabilityStr =
        double.parse(probability.toStringAsFixed(2)).toString();

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          lHeight(20.vw),
          lText('🚮 这是什么垃圾？', size: 36, bold: true),
          lExpanded(),
          ClipRRect(
            borderRadius: BorderRadius.circular(5.vw),
            child: SizedBox(
              width: 80.vw,
              height: 80.vw,
              child: FittedBox(
                fit: BoxFit.cover,
                child: CameraStack(cameraState),
              ),
            ),
          ),
          lExpanded(),
          if (prediction.value != null)
            lText(
              '${prediction.value!.trash}($probabilityStr%)',
              size: 16,
            ),
          lExpanded(),
          takePhoto(loading.value, prediction.value != null, () async {
            if (loading.value) return;
            if (cameraState.photo == null) {
              loading.value = true;
              prediction.value = await cameraState.predicate();
              loading.value = false;
              await showCupertinoModalBottomSheet(
                context: context,
                backgroundColor: Colors.transparent,
                builder: (context) =>
                    SearchBottomSheet(prediction.value!.trash),
              );
              cameraState.reset();
              prediction.value = null;
            } else {
              cameraState.reset();
              prediction.value = null;
            }
          }),
          lHeight(20.vw),
        ],
      ),
    );
  }

  Widget takePhoto(loading, predicted, predict) => GestureDetector(
        onTap: predict,
        child: Container(
          width: 276.px,
          height: 48.px,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(
              Radius.circular(100.vw),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                predicted ? Icons.refresh : Icons.photo_camera_outlined,
                size: 24.px,
                color: Colors.white,
              ),
              lWidth(2.vw),
              Text(
                loading
                    ? '识别中...'
                    : predicted
                        ? '重新识别'
                        : '拍照识别',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.px,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
}
