import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:thefilms/screens/splash_screen.dart';
import 'package:thefilms/states/main_app_state.dart';
import 'utils/constants.dart';
import 'screens/home_screen.dart';


void main() {
  runApp(
    MaterialApp(
      home: SplashScreen(),
    ),
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<MainAppState>(
          create: (BuildContext context) {
            MainAppState appState = MainAppState();
            return appState;
          },
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'The Films',
          theme: ThemeData.dark().copyWith(
            platform: TargetPlatform.iOS,
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kPrimaryColor,
            textTheme:
                ThemeData.dark().textTheme.apply(fontFamily: kFontsFamily),
          ),
          home: HomeScreen(
            key: kHomeScreenKey,
          ),
        );
      },
    );
  }
}
