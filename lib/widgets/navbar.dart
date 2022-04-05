

import 'package:flutter/cupertino.dart';
import 'package:skan/states/navbar_state.dart';

class Navbar extends StatefulWidget {

  final PageController controller;
  final List<Widget> items;
  final int currentIndex;
  var onTap;

  Navbar({Key? key,
    required this.controller,
    required this.items,
    required this.currentIndex,
    this.onTap
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => NavbarState();
}