import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:trash/pages/detail.dart';
import 'package:trash/pages/search.dart';
import 'package:trash/utils/labels.dart';
import 'package:trash/utils/screen/screen_tool.dart';
import 'package:trash/widgets/auto_hide_keyboard.dart';
import 'package:trash/widgets/base.dart';
import 'package:trash/widgets/l_text_field.dart';

class CategoryPage extends HookWidget {
  get topCardWidth => 100.vw;
  get topCardHeight => 180.px;
  get trashes => Labels.instance!.trashes;
  List<TrashCategory> get categories => Labels.instance!.categories;

  get cateColors => Labels.cateColors;

  get cateBgs => {
        '干垃圾': '黑色',
        '湿垃圾': '棕色',
        '有害垃圾': '红色',
        '可回收物': '紫色',
      };

  get itemHeight => 48.px;
  var jumping = false;

  @override
  Widget build(BuildContext context) {
    var initPage = useState(1);

    page2listHeight() {
      final _trashx = trashes
          .firstWhere((e) => e.category == categories[initPage.value].name);
      return trashes.indexOf(_trashx) * itemHeight;
    }

    var initialScrollOffset = page2listHeight();
    final currentCateory = categories[initPage.value];
    final pageViewController =
        usePageController(initialPage: initPage.value, viewportFraction: 0.9);
    final listController =
        useScrollController(initialScrollOffset: initialScrollOffset);

    listHeight2page() {
      final n =
          (listController.offset ~/ itemHeight).clamp(0, trashes.length - 1);
      return categories
          .map((e) => e.name)
          .toList()
          .indexOf(trashes[n].category);
    }

    useEffect(() {
      pageViewController.addListener(() {
        final currentPage = (pageViewController.page ?? initPage.value).toInt();
        if (initPage.value != currentPage) {
          if (jumping) return;
          initPage.value = currentPage;
          final listPage = listHeight2page();
          if (listPage != currentPage) {
            // jumping = true;
            listController.jumpTo(page2listHeight()
                // duration: Duration(milliseconds: 0),
                // curve: Curves.ease,
                );
            //.then((_) => jumping = false);
          }
        }
      });
      listController.addListener(() {
        final idx = listHeight2page();
        if (idx != initPage.value) {
          if (jumping) return;
          initPage.value = idx;
          jumping = true;
          pageViewController
              .animateToPage(
                idx,
                duration: Duration(milliseconds: 200),
                curve: Curves.ease,
              )
              .then((_) => jumping = false);
        }
      });
    });

    return SafeArea(
      top: true,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            search(context),
            SizedBox(
              width: topCardWidth,
              height: topCardHeight,
              child: PageView.builder(
                controller: pageViewController,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (_, idx) => category(categories[idx]),
              ),
            ),
            Row(
              children: [
                lWidth(16.px),
                dot(currentCateory),
              ],
            ),
            Expanded(
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                itemCount: trashes.length,
                controller: listController,
                itemBuilder: (_, idx) => _trash(context, trashes[idx]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget dot(TrashCategory category) {
    return lContainer(
      width: 12.px,
      height: 12.px,
      color: cateColors[category.name],
      margin: EdgeInsets.only(bottom: 16.px, top: 12.px),
      borderRadius: BorderRadius.circular(18.px),
    );
  }

  Widget _trash(context, Trash trash) {
    return GestureDetector(
      onTap: () {
        showCupertinoModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (context) => DetailBottomSheet(trash: trash),
        );
      },
      child: Container(
        height: itemHeight,
        padding: EdgeInsets.symmetric(horizontal: 16.px),
        child: lText(trash.name),
      ),
    );
  }

  Widget search(context) {
    return lContainer(
      width: 100.vw,
      height: 48.px,
      color: Color(0xffe5e5e5),
      borderRadius: BorderRadius.circular(48.px),
      margin: EdgeInsets.all(16.px),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_outlined),
          AutoHideKeyBoard.single(
            child: SizedBox(
              width: 72.vw,
              height: 48.px,
              child: lTextField('搜索...',
                  textInputAction: TextInputAction.search, onSubmitted: (s) {
                showCupertinoModalBottomSheet(
                  context: context,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SearchBottomSheet(s),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget category(TrashCategory category) {
    return Container(
      padding: EdgeInsets.all(8.px),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.px),
        child: Stack(
          children: [
            Transform.scale(
              scale: 1.2,
              child: Image.asset(
                'assets/images/${cateBgs[category.name]}.png',
                width: topCardWidth,
                height: topCardHeight,
                fit: BoxFit.cover,
              ),
            ),
            lContainer(
              width: topCardWidth,
              height: topCardHeight,
              padding: EdgeInsets.symmetric(horizontal: 16.px, vertical: 8.px),
              borderRadius: BorderRadius.circular(12.px),
              // color: cateColors[category.name],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            lText(
                              category.name,
                              size: 24.px,
                              bold: true,
                              color: Colors.white,
                            ),
                            lText(category.description,
                                color: Colors.white, size: 12.px),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12.px),
                        child: Image.asset(
                          'assets/images/${category.name}.png',
                          width: 36.px,
                          height: 36.px,
                          color: Colors.white,
                          fit: BoxFit.cover,
                        ),
                      )
                    ],
                  ),
                  lHeight(10.px),
                  Column(
                    children: category.tips
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
                        .toList(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
