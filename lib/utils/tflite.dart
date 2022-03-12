import 'dart:io';
import 'dart:math';

import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:tflite_flutter_helper/tflite_flutter_helper.dart';

class Predication {
  String trash;
  double probability;
  String imgPath;
  Predication(this.trash, this.probability, this.imgPath);
}

class TFLite {
  static Interpreter? interpreter;

  static List<int>? inputShape;
  static TfLiteType? inputType;
  static List<int>? outputShape;
  static TfLiteType? outputType;

  static final labels = ['纸箱', '玻璃', '金属', '纸张', '塑料', '垃圾'];

  static init() async {
    try {
      interpreter ??= await Interpreter.fromAsset("garbagelite.tflite");
    } catch (_) {}
  }

  static Future<Predication?> predicte(String imgPath) async {
    await init();
    if (interpreter == null) {
      return null;
    }
    inputShape = interpreter!.getInputTensor(0).shape;
    inputType = interpreter!.getInputTensor(0).type;
    outputShape = interpreter!.getOutputTensor(0).shape;
    outputType = interpreter!.getOutputTensor(0).type;

    final image = img.decodeImage(File(imgPath).readAsBytesSync())!;
    var tensorImage = TensorImage(inputType!)..loadImage(image);

    int cropSize = min(tensorImage.height, tensorImage.width);
    ImageProcessor imageProcessor = ImageProcessorBuilder()
        .add(ResizeWithCropOrPadOp(cropSize, cropSize))
        .add(ResizeOp(
          inputShape![1],
          inputShape![2],
          ResizeMethod.NEAREST_NEIGHBOUR,
        ))
        .build();

    tensorImage = imageProcessor.process(tensorImage);

    TensorBuffer probabilityBuffer =
        TensorBuffer.createFixedSize(outputShape!, outputType!);

    try {
      interpreter!.run(tensorImage.buffer, probabilityBuffer.buffer);
    } catch (e) {}
    final result = probabilityBuffer.getDoubleList();
    var maxNumber = 0.0;
    for (final n in result) {
      if (n > maxNumber) {
        maxNumber = n;
      }
    }
    final prediction = result.indexOf(maxNumber).clamp(0, 6);
    return Predication(labels[prediction], maxNumber * 100, imgPath);
  }
}
