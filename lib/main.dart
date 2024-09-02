import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:locale_connectt/Auth/cartprovider.dart';
import 'package:locale_connectt/Auth/map_provider.dart';
import 'package:locale_connectt/firebase_options.dart';
import 'package:locale_connectt/utils/circular_loader.dart';
import 'package:provider/provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  //   await Firebase.initializeApp(
  //   name: 'new-conect-ca7f0',
  //   options: FirebaseOptions(
  //   apiKey: 'AIzaSyCp8eniS4INnGbGgdFg7Bl7jp7NHuL897g',
  //   appId: '1:776268132845:web:56d2fb53ec9a18abe8b7e4',
  // messagingSenderId: '776268132845',
  //   projectId: 'new-conect-ca7f0',
  //   ));
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => Cartprovider(),),
        ChangeNotifierProvider(create: (context)=> MapProvider())
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          home: FABcircularAnimation(),
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue)
          ),
        ),
    );
  }
}

