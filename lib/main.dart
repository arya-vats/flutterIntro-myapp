import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myapp/views/login_view.dart';
import 'package:myapp/views/register_view.dart';
import 'package:myapp/views/verify_email_view.dart';

import 'firebase_options.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
          onSelected: (value) {
            if (value == MenuAction.logout) {
              print('logged out');
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
