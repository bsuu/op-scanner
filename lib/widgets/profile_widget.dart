import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skan/octicons_icons.dart';
import 'package:skan/widgets/options_widget.dart';

import '../provider/google_sign_in.dart';

class ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;

    return Container(
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: AdaptiveTheme.of(context).theme.backgroundColor,
        ),
        child: Column(
          children: [
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      IconButton(
                          onPressed: () {
                            final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                            provider.logout();
                          },
                          icon: Icon(Octicons.sign_out_16, size: 30, color: AdaptiveTheme.of(context).theme.errorColor)),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.only(bottom: 14),
              child: Wrap(
                children: [
                  CircleAvatar(
                    radius: 56,
                    backgroundColor: AdaptiveTheme.of(context).theme.highlightColor,
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(user.photoURL!),
                      radius: 52,
                    ),
                  ),
                ],
              ),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 15,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: AdaptiveTheme.of(context).theme.primaryColor,
                  ),
                  child: Row(
                    children: [
                      Text(
                        user.displayName!,
                        style: AdaptiveTheme.of(context).theme.textTheme.headline1,
                      )
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                    color: AdaptiveTheme.of(context).theme.primaryColor,
                  ),
                  child: Row(
                    children: [
                      Text(
                        user.email!,
                        style: AdaptiveTheme.of(context).theme.textTheme.headline1,
                      )
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      );
  }

}

class ProfileWidget extends StatefulWidget {


  const ProfileWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileWidgetState();
}