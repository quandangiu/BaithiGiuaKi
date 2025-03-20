import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:project_2/view/LoginScreen.dart';
import 'package:project_2/view/ProductsListScreen.dart';
import 'package:project_2/view/users_list_screen.dart';
// Import the new login screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? FirebaseOptions(
            apiKey: "AIzaSyCp_idAXhu6TkxLCIz76DFXqwUfeQOK_pw",
            authDomain: "test-108f4.firebaseapp.com",
            databaseURL: "https://test-108f4-default-rtdb.firebaseio.com",
            projectId: "test-108f4",
            storageBucket: "test-108f4.firebasestorage.app",
            messagingSenderId: "236749297531",
            appId: "1:236749297531:web:8e1e18bec8f89ba6518fde",
            measurementId: "G-E6GZPGKJ02")
        : null, // On Android/iOS, Firebase will automatically load config from `google-services.json` or `GoogleService-Info.plist`
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Firebase Product',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LoginScreen(), // Start with LoginScreen
    );
  }
}
