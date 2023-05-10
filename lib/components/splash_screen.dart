import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class SplashScreen extends StatelessWidget {
  final String content;
  final bool loadingIndicator;

  SplashScreen({
    this.content = 'Loading...',
    this.loadingIndicator = true,
  });

  @override
  Widget build(BuildContext context) {
    FlutterNativeSplash.remove();
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(18.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                children: [
                  loadingIndicator ? CircularProgressIndicator() : Container(),
                  SizedBox(height: 10),
                  Text(
                    content,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
