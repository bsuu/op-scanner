
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skan/main_widget.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:skan/provider/google_sign_in.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(const ScanApp());
}

class ScanApp extends StatelessWidget {
  const ScanApp({Key? key}) : super(key: key);

  // SystemChrome.setSystemUIOverlayStyle(
  //   SystemUiOverlayStyle(
  //   statusBarColor: Colors.transparent
  //   //color set to transperent or set your own color
  //   )
  // );

  @override
  Widget build(BuildContext context) {

    return  ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        home: MainWidget(),
        debugShowCheckedModeBanner: false,
      )
    );

  }

}