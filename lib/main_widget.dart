import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:skan/pages/camera_view.dart';
import 'package:skan/pages/file_view.dart';
import 'package:skan/pages/profile_view.dart';
import 'package:skan/widgets/navbar_widget.dart';

import 'octicons_icons.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainWidgetState();

}

class MainWidgetState extends State<MainWidget> {

  final PageController _controller = PageController();
  int selectedIndex = 0;

  void changeIndexState(int index) {
    setState(() {
      selectedIndex = index;
    });
    _controller.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
          child: Scaffold(
            body: PageView(
              controller: _controller,
              children: [
                FileView(),
                CameraView(),
                ProfileView(),
              ],
                onPageChanged: changeIndexState,

            ),
            bottomNavigationBar: Navbar(
                controller: _controller,
                currentIndex: selectedIndex,
                items: [
                  Icon(Octicons.home_16, color: AdaptiveTheme.of(context).theme.iconTheme.color,),
                  Icon(Octicons.video_16, color: AdaptiveTheme.of(context).theme.iconTheme.color,),
                  Icon(Octicons.person_16, color: AdaptiveTheme.of(context).theme.iconTheme.color,),],
                onTap: changeIndexState,

            ),
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            extendBody: true,

          ),
        );
  }
}