import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:khobar_shopper/exports/components.dart' show FirestoreBuilder;
import 'package:khobar_shopper/exports/providers.dart'
    show
        ConnectivityStatus,
        authProvider,
        authStateChangeProvider,
        connectionResultProvider,
        connectionStream;
import 'package:khobar_shopper/exports/screens.dart' show LoginScreen;
import 'package:khobar_shopper/firebase_options.dart';
import 'package:khobar_shopper/routes/routes_generator.dart';
import 'package:khobar_shopper/exports/components.dart' show SplashScreen;
import 'package:khobar_shopper/exports/utils.dart' show AppColor;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark),
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Consumer(
        builder: (context, ref, _) {
          final auth = ref.read(authProvider);
          final authChanges = ref.watch(authStateChangeProvider);
          final newtworkStream = ref.watch(connectionStream);

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: RouteGenerator.generateRoute,
            theme: ThemeData(
              scaffoldBackgroundColor: AppColor.background,
              colorScheme: ColorScheme.light(
                primary: AppColor.darkBlue,
              ),
              appBarTheme: AppBarTheme(
                color: AppColor.background,
              ),
            ),
            home: newtworkStream.when(
              data: (result) {
                Future(() {
                  ref.read(connectionResultProvider.notifier).state =
                      result == ConnectivityStatus.Connected ? true : false;
                });
                return authChanges.when(
                  data: (user) {
                    debugPrint('${user?.emailVerified}');
                    if (user != null && user.emailVerified) {
                      auth.setUID(user.uid);
                      debugPrint(auth.uid);
                      return FirestoreBuilder();
                    }
                    return LoginScreen();
                  },
                  error: (_, __) {
                    return SplashScreen(
                      content: 'Something went wrong. Please try again',
                      loadingIndicator: false,
                    );
                  },
                  loading: () {
                    return SplashScreen();
                  },
                );
              },
              error: (_, __) {
                return SplashScreen(
                  content: 'Something went wrong. Please try again',
                  loadingIndicator: false,
                );
              },
              loading: () {
                return SplashScreen();
              },
            ),
          );
        },
      ),
    );
  }
}
