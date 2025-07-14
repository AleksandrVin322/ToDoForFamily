import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_body.dart';
import 'models/model_task.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ChangeNotifierProvider<ModelTask>(
        create: (BuildContext context) => ModelTask(),
        child: const AppBody(),
      ),
    );
  }
}
