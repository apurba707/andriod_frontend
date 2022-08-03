import 'package:flutter/material.dart';
import 'package:khalti_flutter/khalti_flutter.dart';
import 'package:provider/provider.dart';
import 'package:rhino_sport_kalij/extra/search.dart';
import 'package:rhino_sport_kalij/views/khalti.dart';
import '../../provider/API-provider.dart';
import 'views/Admin_view.dart';
import 'views/client_view.dart';
import 'views/Auth.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return KhaltiScope(
        publicKey: "test_public_key_eca417780b9247d5ac4e791af7947fe0",
        builder: (context, navigatorKey) {
    return MultiProvider(
        child: MaterialApp(
          navigatorKey: navigatorKey,
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('ne', 'NP'),
            ],
            localizationsDelegates: const [
              KhaltiLocalizations.delegate,
            ],
          debugShowCheckedModeBanner: false,
          initialRoute: '/',
          routes: {
            '/': (context) => Demo(),
            '/client': (context) => Client(),
            '/admin': (context) => HomeView(),
            '/khalti':(context) => KhaltiPaymentPage(),
            '/search':(context) => Search(),
          },
        ),
        providers: [ChangeNotifierProvider(create: (_) => TodoProvider())]);
  });
  }
}
// end