import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:trash/pages/camera/camera.dart';
import 'package:trash/pages/category.dart';
import 'package:trash/widgets/alive_keeper.dart';

class HomePage extends HookWidget {
  final pages = [
    CameraPage(),
    CategoryPage(),
  ].map<Widget>((e) => AliveKeeper(child: e)).toList();
  @override
  Widget build(BuildContext context) {
    final currentPage = useState(0);
    final controller = useTabController(
      initialLength: pages.length,
      initialIndex: currentPage.value,
    );

    onPageChanged(int idx) {
      if (idx != currentPage.value) {
        currentPage.value = idx;
        controller.animateTo(idx);
      }
    }

    useEffect(() {
      controller.addListener((() {
        if (!controller.indexIsChanging) {
          onPageChanged(controller.index);
        }
      }));
    });

    return Scaffold(
      body: TabBarView(
        controller: controller,
        children: pages,
        physics: BouncingScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPage.value,
        onTap: onPageChanged,
        items: [
          BottomNavigationBarItem(
            label: '识别',
            icon: Icon(Icons.trip_origin),
          ),
          BottomNavigationBarItem(
            label: '分类',
            icon: Icon(Icons.star),
          ),
        ],
      ),
    );
  }
}
