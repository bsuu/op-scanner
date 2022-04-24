import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../provider/google_sign_in.dart';

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
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        color: AdaptiveTheme.of(context).theme.primaryColor,
      ),
      child: Row(
        children: [

          Expanded(child: Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 15,
            children: [
              Icon(FontAwesomeIcons.google, size: 24, color: AdaptiveTheme.of(context).theme.iconTheme.color),
              Text("Zaloguj się przez Google", style: AdaptiveTheme.of(context).theme.textTheme.headline1, textAlign: TextAlign.center,)
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