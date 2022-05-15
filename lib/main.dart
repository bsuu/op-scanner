
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:skan/main_widget.dart';
import 'package:skan/provider/google_sign_in.dart';
import 'package:skan/provider/navbar_provider.dart';
import 'package:skan/provider/scan_file_storage.dart';
import 'package:skan/themes.dart';

late final camera;

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final cameras = await availableCameras();
  camera = cameras.first;

  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  runApp(const ScanApp());
}

class ScanApp extends StatelessWidget {

  const ScanApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {

    return AdaptiveTheme(
      light: CustomThemes().light,
      dark: CustomThemes().dark,
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MultiProvider(
          providers: [
            ChangeNotifierProvider<GoogleSignInProvider>(create: (_) => GoogleSignInProvider()),
            ChangeNotifierProvider<NavbarProvider>(create: (_) => NavbarProvider()),
            ChangeNotifierProvider<ScanFileStorage>(create: (_) => ScanFileStorage())
          ],
        child: MaterialApp(
          home: MainWidget(),
          debugShowCheckedModeBanner: false,
          // showPerformanceOverlay: true,
          theme: theme,
          darkTheme: darkTheme,
        ),
      )
    );

  }

}
