// This screen is for the profile of the user
// It will show the user's data and the user can edit it
// It will also allow the user to sign out or change the password

import 'package:flutter/material.dart';
import 'package:khobar_shopper/exports/providers.dart'
    show
        ConnectivityStatus,
        authProvider,
        authStateChangeProvider,
        connectionResultProvider,
        connectionStream;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:khobar_shopper/exports/utils.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Consumer(
        builder: (context, ref, _) {
          final auth = ref.read(authProvider);
          final authChanges = ref.watch(authStateChangeProvider);
          final newtworkStream = ref.watch(connectionStream);

          return newtworkStream.when(
            data: (result) {
              Future(() {
                ref.read(connectionResultProvider.notifier).state =
                    result == ConnectivityStatus.Connected ? true : false;
              });
              return authChanges.when(
                data: (user) {
                  if (user != null) {
                    return Column(
                      children: [
                        SizedBox(height: 100),
                        Text(
                          user.email!,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            auth.signOut();
                          },
                          child: Text('Sign Out'),
                        ),
                      ],
                    );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
                loading: () => Center(
                  child: CircularProgressIndicator(),
                ),
                error: (error, stackTrace) => Center(
                  child: Text(error.toString()),
                ),
              );
            },
            loading: () => Center(
              child: CircularProgressIndicator(),
            ),
            error: (error, stackTrace) => Center(
              child: Text(error.toString()),
            ),
          );
        },
      ),
    );
  }
}
