import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skan/octicons_icons.dart';
import 'package:skan/provider/google_sign_in.dart';
import 'package:skan/widgets/login_widget.dart';
import 'package:skan/widgets/option_item.dart';
import 'package:skan/widgets/options_widget.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../skan_colors.dart';
import '../widgets/profile_widget.dart';

class ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(color: background),
        padding: EdgeInsets.only(top: MediaQuery.of(context).viewPadding.top),
        child: ListView(
          padding: const EdgeInsets.all(15),
          children: [
            StreamBuilder(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ProfileWidget();
                } else {
                  return LoginWidget();
                }
              }
            ),
            OptionItem(option_name: "Motyw jasnsy czy ciemny?")
          ]
        )
    );
  }
}

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ProfileViewState();

}