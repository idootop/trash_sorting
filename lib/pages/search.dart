import 'dart:ui';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:trash/pages/detail.dart';
import 'package:trash/utils/screen/screen_tool.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trash/utils/labels.dart';
import 'package:trash/widgets/base.dart';

class SearchBottomSheet extends StatelessWidget {
  String keyword;
  SearchBottomSheet(this.keyword, {Key? key}) : super(key: key);

  List<Trash> get trashs => Labels.instance!.findTrashes(keyword);

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          color: Colors.white,
          child: Column(
            children: [
              appBar(context),
              Divider(height: 1),
              Expanded(
                child: trashs.isEmpty
                    ? Center(
                        child: lText('什么都没有找到 :(', size: 20.px, bold: true),
                      )
                    : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: trashs.length,
                        itemBuilder: (_, idx) => trash(context, trashs[idx]),
                      ),
              ),
            ],
          ),
        ));
  }

  Widget trash(context, Trash trash) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => DetailBottomSheet(
            trash: trash,
          ),
        );
      },
      child: lContainer(
        margin: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
        padding: EdgeInsets.all(16.px),
        borderRadius: BorderRadius.circular(12.px),
        color: Color(0xffe5e5e5),
        child: Row(
          children: [
            Image.asset(
              'assets/images/${trash.category}.png',
              width: 24.px,
              height: 24.px,
              color: Labels.cateColors[trash.category],
              fit: BoxFit.cover,
            ),
            lWidth(12.px),
            lText(
              '${trash.name} (${trash.category})',
              size: 14.px,
              bold: true,
              // color: Labels.cateColors[trash.category],
            ),
          ],
        ),
      ),
    );
  }

  Widget appBar(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(width: 18),
        Text(
          keyword,
          style: CupertinoTheme.of(context)
              .textTheme
              .textStyle
              .copyWith(fontWeight: FontWeight.w600),
        ),
        lExpanded(),
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 14),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.close,
              size: 24,
              color: Colors.black54,
            ),
          ),
        ),
        SizedBox(width: 14),
      ],
    );
  }
}
