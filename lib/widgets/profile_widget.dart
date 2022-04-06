
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skan/octicons_icons.dart';
import 'package:skan/widgets/options_widget.dart';

import '../provider/google_sign_in.dart';
import '../skan_colors.dart';

class ProfileWidgetState extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {

    final user = FirebaseAuth.instance.currentUser!;

    return Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 14),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          color: file_item_background,
        ),
        child: Row(
          children: [
            Wrap(
              alignment: WrapAlignment.start,
              spacing: 15,
              children: [
                Icon(Octicons.person_16, size: 38, color: first_font_color),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName!,
                      style: const TextStyle(fontSize: 18, color: first_font_color),
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                              user.email!,
                              style: const TextStyle(fontSize: 14, color: second_font_color, height: 1.2)
                          ),
                        ]),
                  ],
                )
              ],
            ),
            Expanded(child:
              Wrap(
                alignment: WrapAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
                        provider.logout();
                      },
                      icon: Icon(Octicons.sign_out_16, size: 34, color: error_color)),
                ],
              )
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