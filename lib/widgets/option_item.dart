

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:skan/states/file_item_state.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../octicons_icons.dart';
import '../skan_colors.dart';

class OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(widget.option_name),
          ToggleSwitch(
            totalSwitches: 2,
            customIcons: [
              Icon(Octicons.sun_16, color: Colors.orange,),
              Icon(Octicons.moon_16, color: first_font_color)
            ],
            activeBgColors: [
              [first_font_color],
              [background]

            ],
          )
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