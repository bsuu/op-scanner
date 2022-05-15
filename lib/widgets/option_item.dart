import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';

class OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        color: AdaptiveTheme.of(context).theme.primaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(8))
      ),
      child: Row(
        children: [
          Text(widget.optionName, style: AdaptiveTheme.of(context).theme.textTheme.bodyText1),
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
                    } else {
                      AdaptiveTheme.of(context).setDark();
                    }
                  },
                  customIcons: [
                    const Icon(FontAwesomeIcons.sun, color: Colors.orange, size: 16,),
                    Icon(FontAwesomeIcons.moon, color: AdaptiveTheme.of(context).theme.primaryColor, size: 16,)
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

  final String optionName;

  const OptionItem({
    Key? key,
    required this.optionName,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => OptionItemState();
}