import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/navbar_provider.dart';

class NavbarState extends State<Navbar> {
  @override
  Widget build(BuildContext context) {
    double size = ((MediaQuery.of(context).size.width - 96) / 3);
    return Container(
      constraints: const BoxConstraints(maxHeight: 46),
      margin: const EdgeInsets.only(bottom: 14, left: 48, right: 48),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(8)),
        color: AdaptiveTheme.of(context).theme.bottomAppBarColor,
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            margin: EdgeInsets.only(
                left: size * Provider.of<NavbarProvider>(context).currentIndex),
            width: size,
            height: double.infinity,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(8)),
              color: AdaptiveTheme.of(context).theme.highlightColor,
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (int i = 0; i < widget.items.length; i++)
                  GestureDetector(
                    onTap: () => widget.onTap(i),
                    child: widget.items[i],
                  )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class Navbar extends StatefulWidget {
  final List<Widget> items;
  final Function onTap;

  const Navbar({Key? key, required this.items, required this.onTap})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => NavbarState();
}
