
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:skan/octicons_icons.dart';

import '../provider/google_sign_in.dart';
import '../skan_colors.dart';

class LoginWidgetState extends State<LoginWidget> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
        provider.googleLogin();
      },
      child: Container(
      padding: const EdgeInsets.all(14),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        color: file_item_background,
      ),
      child: Row(
        children: [

          Expanded(child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 15,
            children: [
              Icon(FontAwesomeIcons.google, size: 24, color: first_font_color),
              Text("Zaloguj się przez Google", style: TextStyle(fontSize: 18, color: first_font_color), textAlign: TextAlign.center,)
            ],
          ))

        ],
      ),
    ));
  }

}

class LoginWidget extends StatefulWidget {

  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => LoginWidgetState();
}