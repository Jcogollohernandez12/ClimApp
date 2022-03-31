import 'package:weather/src/services/weatherService.dart';
import 'package:weather/src/view/pages/homePage.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => WeatherService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Material App',
        home: EasySplashScreen(
          logo: const Image(image: AssetImage("images/fond.png")),
          logoSize: 300,
          navigator: const HomePage(),
          loadingText: const Text("Cargando..."),
        ),
      ),
    );
  }
}
