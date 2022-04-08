
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skan/main_widget.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:skan/provider/google_sign_in.dart';
import 'package:skan/themes.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  runApp(ScanApp());
}

class ScanApp extends StatelessWidget {

  const ScanApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return AdaptiveTheme(
      light: CustomThemes().light,
      dark: CustomThemes().dark,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: MaterialApp(
            home: MainWidget(),
            debugShowCheckedModeBanner: false,
            theme: theme,
            darkTheme: darkTheme,
          )
      ),
    );

  }

}
