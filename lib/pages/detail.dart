import 'dart:io';
import 'dart:ui';
import 'package:trash/utils/screen/screen_tool.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trash/utils/labels.dart';
import 'package:trash/utils/tflite.dart';
import 'package:trash/widgets/base.dart';

class DetailBottomSheet extends StatelessWidget {
  final Trash? trash;
  final Predication? predication;
  const DetailBottomSheet({this.trash, this.predication, Key? key})
      : super(key: key);

  get trashName => trash?.name ?? predication?.trash;
  get cate => Labels.labelCates[predication?.trash] ?? trash!.category;
  get probability => (predication?.probability ?? 0);
  get probabilityStr => predication?.probability == null
      ? ''
      : '(${double.parse(probability.toStringAsFixed(2))}%)';
  get tips =>
      Labels.instance!.categories.where((e) => e.name == cate).toList()[0].tips;
  get color => Labels.cateColors[cate]!.withOpacity(0.6);

  Widget cateLogo() {
    final size = 30.vw;
    return Container(
      padding: EdgeInsets.all(12.px),
      child: Image.asset(
        'assets/images/$cate.png',
        width: size,
        height: size,
        color: Colors.white,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: color,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              appBar(context),
              Divider(height: 1),
              lHeight(16.px),
              cateLogo(),
              Padding(
                padding: EdgeInsets.all(12.px),
                child:
                    lText(cate, size: 36.px, bold: true, color: Colors.white),
              ),
              lContainer(
                margin: EdgeInsets.all(16.px),
                padding: EdgeInsets.all(16.px),
                borderRadius: BorderRadius.circular(12.px),
                color: color,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    lText('投放建议：',
                        size: 16.px, bold: true, color: Colors.white),
                    lHeight(12.px),
                    ...tips
                        .map<Widget>(
                          (e) => Row(
                            children: [
                              lContainer(
                                width: 8.px,
                                height: 8.px,
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8.px),
                              ),
                              lWidth(8.px),
                              lText(e, color: Colors.white, size: 12.px),
                            ],
                          ),
                        )
                        .toList()
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget appBar(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 18),
        if (predication != null)
          Container(
            padding: EdgeInsets.all(12.px),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.px),
              child: Image.file(
                File(predication!.imgPath),
                width: 36.px,
                height: 36.px,
                fit: BoxFit.cover,
              ),
            ),
          ),
        Text(
          '$trashName $probabilityStr',
          style: CupertinoTheme.of(context)
              .textTheme
              .textStyle
              .copyWith(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        lExpanded(),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 14),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close,
              size: 24,
              color: Colors.white,
            ),
          ),
        ),
        SizedBox(width: 14),
      ],
    );
  }
}
