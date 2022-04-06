

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../octicons_icons.dart';
import '../skan_colors.dart';


class OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: file_item_background,
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Row(
        children: [
          Text(widget.option_name, style: TextStyle(color: first_font_color)),
          Expanded(child: Wrap(
            alignment: WrapAlignment.end,
            children: [
                ToggleSwitch(
                  totalSwitches: 2,
                  minWidth: 55,
                  minHeight: 30,
                  customIcons: [
                    Icon(Octicons.sun_16, color: Colors.orange, size: 16),
                    Icon(Octicons.moon_16, color: first_font_color, size: 16,)
                  ],
                  activeBgColors: [
                    [first_font_color],
                    [background]
                  ],
                )
            ],
          )),
        ],
      ),
    );
  }

}

class OptionItem extends StatefulWidget {

  final String option_name;

  const OptionItem({
    Key? key,
    required this.option_name,


  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => OptionItemState();
}