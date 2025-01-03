import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/analysis_provider.dart';
import 'login_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AnalysisProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Endometriosis Assist',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginPage(), // Login Page
    );
  }
}
