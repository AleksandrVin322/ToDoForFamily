import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_for_family/my_app.dart';

import 'domain/service/auth_service.dart';
import 'domain/service/firestore_service.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(
          create: (context) => AuthService(),
        ),
        RepositoryProvider(
          create: (context) => FirestoreService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
