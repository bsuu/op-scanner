import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/widgets/navbar.dart';

import '../skan_colors.dart';

class NavbarState extends State<Navbar> {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: EdgeInsets.only(bottom: 14, left: 48, right: 48),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        color: Colors.yellow,
      ),
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
    );
  }

}