import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:connectivity_plus/connectivity_plus.dart';

enum ConnectivityStatus {
  Connected,
  Disconnected,
  SocketException,
  Unknown,
}

/// Return a steam value of [ConnectivityStatus]
final connectionStream = StreamProvider<ConnectivityStatus>((ref) {
  return ref.watch(connectionProvider).streamController.stream;
});

/// To access [NetworkService]
final connectionProvider = ChangeNotifierProvider<NetworkService>((ref) {
  return NetworkService();
});

final connectionResultProvider = StateProvider<bool>((ref) {
  return false;
});

class NetworkService extends ChangeNotifier {
  ConnectivityResult? previous;

  StreamController<ConnectivityStatus> streamController =
      StreamController<ConnectivityStatus>();

  // URL
  final uri = Uri.parse('https://google.com');

  NetworkService() {
    connectivityCall();
  }

  /** 
   * This method will check if the wifi or data phone is turned on or off, once is
    switched to on, it will then check if google.com can be reach or not by calling
    httpCall method
   * 
  */
  void connectivityCall() {
    Connectivity().onConnectivityChanged.listen(
      (ConnectivityResult result) {
        if (result == ConnectivityResult.none) {
          // No connection
          streamController.add(ConnectivityStatus.Disconnected);
          previous = result;
        } else if (previous == ConnectivityResult.none) {
          // There is a connection
          previous = result;
          httpCall();
        } else {
          previous = result;
          httpCall();
        }
      },
    );
  }

  /**
   * For making network calls, if there is connection, the widget will be shown, otherwise 
   it will show either ConnectionFailedWidget or showDialog method
   */
  Future<void> httpCall() async {
    try {
      await http.get(uri).then((res) {
        if (res.statusCode == 200) {
          // there is a connection
          streamController.add(ConnectivityStatus.Connected);
        } else {
          // no connection
          streamController.add(ConnectivityStatus.Disconnected);
        }
      }).catchError(
        (_) {
          // no connection
          streamController.add(ConnectivityStatus.Disconnected);
        },
      );
    } on SocketException catch (_) {
      streamController.add(ConnectivityStatus.SocketException);
    }
  }
}
