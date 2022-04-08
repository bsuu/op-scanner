import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import '../octicons_icons.dart';


class OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: AdaptiveTheme.of(context).theme.primaryColor,
        borderRadius: BorderRadius.all(Radius.circular(8))
      ),
      child: Row(
        children: [
          Text(widget.option_name, style: AdaptiveTheme.of(context).theme.textTheme.bodyText1),
          Expanded(child: Wrap(
            alignment: WrapAlignment.end,
            children: [
                ToggleSwitch(
                  totalSwitches: 2,
                  minWidth: 55,
                  minHeight: 30,
                  onToggle: (index) {
                    if (index == 0) {
                      AdaptiveTheme.of(context).setLight();
                    } else
                      AdaptiveTheme.of(context).setDark();
                  },
                  customIcons: [
                    Icon(Octicons.sun_16, color: Colors.orange, size: 16,),
                    Icon(Octicons.moon_16, color: AdaptiveTheme.of(context).theme.primaryColor, size: 16,)
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