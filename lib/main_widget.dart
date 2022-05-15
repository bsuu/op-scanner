
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skan/pages/file_view.dart';
import 'package:skan/pages/profile_view.dart';
import 'package:skan/pages/scan_view.dart';
import 'package:skan/provider/navbar_provider.dart';
import 'package:skan/widgets/navbar_widget.dart';

class MainWidget extends StatefulWidget {


  const MainWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => MainWidgetState();

}

class MainWidgetState extends State<MainWidget> {

  static final PageController _controller = PageController();
  int selectedIndex = 0;

  void changeIndexState(int index) {
    Provider.of<NavbarProvider>(context, listen: false).currentIndex = index;
    _controller.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
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
                ScanView(
                  moveBack: changeIndexState,
                ),
                ProfileView(),
              ],
                onPageChanged: (page) {
                  Provider.of<NavbarProvider>(context, listen: false).currentIndex = page;
                },

            ),
            bottomNavigationBar: Navbar(
                items: [
                  Icon(FontAwesomeIcons.list, color: AdaptiveTheme.of(context).theme.iconTheme.color,),
                  Icon(FontAwesomeIcons.cameraRetro, color: AdaptiveTheme.of(context).theme.iconTheme.color,),
                  Icon(FontAwesomeIcons.userNinja, color: AdaptiveTheme.of(context).theme.iconTheme.color,),],
                onTap: changeIndexState,

            ),
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            extendBody: true,

          ),
        );
  }
}