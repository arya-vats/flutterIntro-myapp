import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/views/login_view.dart';
import 'package:myapp/views/register_view.dart';
import 'package:myapp/views/verify_email_view.dart';
import 'dart:developer' as devtools show log;

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  devtools.log('There is a messgae for you inside the mail');
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      useMaterial3: true,
    ),
    home: const HomePage(),
    routes: {
      '/login/': (context) => const LoginView(),
      '/register/': (context) => const RegisterView()
    },
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                final user = FirebaseAuth.instance.currentUser;
                if (user == null) {
                  return const LoginView();
                } else {
                  if (user.emailVerified == true) {
                    return const NotesView();
                  } else {
                    return const VerifyEmailView();
                  }
                }
              // if (user?.emailVerified == true) {
              //   print('You are a verified user');
              // } else {
              //   return const VerifyEmailView();
              // }
              // return Text('done');
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}

enum MenuAction { logout }

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Main Page'), actions: [
        PopupMenuButton<MenuAction>(
          onSelected: (value) async {
            switch (value) {
              case MenuAction.logout:
                final showLogout = await showLogoutDialog(context);
                devtools.log(showLogout.toString());
                if (showLogout) {
                  await FirebaseAuth.instance.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    '/login/',
                    (_) => false,
                  );
                }
                break;
            }
          },
          itemBuilder: (context) {
            return [
              const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout, child: Text('logout'))
            ];
          },
        )
      ]),
      body: Column(children: [
        TextButton(onPressed: () {}, child: const Text('Do something'))
      ]),
    );
  }
}

Future<bool> showLogoutDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel')),
          TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Logout'))
        ],
      );
    },
  ).then((value) => value ?? false);
}
