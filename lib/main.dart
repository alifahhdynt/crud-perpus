import 'package:crud_perpustakaan/home_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //Kalimat mudahnya: "Ini seperti memastikan mesin mobil sudah menyala sebelum kita mulai mengemudi."
  await Supabase.initialize(
    url: 'https://qowxormlawuovwiihgnq.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFvd3hvcm1sYXd1b3Z3aWloZ25xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzE3MjY1OTAsImV4cCI6MjA0NzMwMjU5MH0.7h1eh8eDfDGNo22qcZcSKtLIWCFbMIJC7o5Lrt35Mxo',
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Digital Library',
      home: BookListPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
