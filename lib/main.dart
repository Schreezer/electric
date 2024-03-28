import 'package:electric/providers/userProvider.dart';
import 'package:electric/screens/adminScreen.dart';
import 'package:electric/screens/choice.dart';
import 'package:electric/screens/entryPoint.dart';
import 'package:electric/screens/homeScreen.dart';
import 'package:electric/screens/loginScreen.dart';
import 'package:electric/screens/newUser.dart';
import 'package:electric/screens/testScree.dart';
import 'package:electric/screens/usersData.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token =  prefs.getString('jwt');
  String? userType = prefs.getString('userType');
  String initialRoute =
      token != null && !JwtDecoder.isExpired(token) ? '/home' : '/';
  initialRoute = userType == 'admin' ? '/choice' : initialRoute;
  print("the initial route is : ");
  print(initialRoute);
  print(token);
  runApp(
      MyApp(token: prefs.getString('token') ?? '', initialRoute: initialRoute));
}

class MyApp extends StatefulWidget {
  final token;
  final initialRoute;
  MyApp({
    required this.token,
    required this.initialRoute,
    Key? key,
  }) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    @override
    void initState() {
      // Check if the user is already logged in
      UserProvider userProvider =
          Provider.of<UserProvider>(context, listen: false);
      userProvider.refreshUser(false);
    }

    return MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (context) => UserProvider()),
        ],
        child: MaterialApp(
          title: 'Flutter Demo',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          initialRoute: widget.initialRoute,
          routes: {
            '/': (context) => const EntryPoint(),
            '/login': (context) => const LoginScreen(),
            '/choice': (context) => const ChoiceScreen(),
            '/home': (context) => const HomeScreen(),
            '/admin': (context) =>  AdminScreen(),
            '/admin/new': (context) => const AddUserScreen(), 
            '/admin/bill/:id': (context) => DataScreen(),
            // '/profile': (context) => const ProfileScreen(),
          },
          // home: const LoginScreen(),
        ));
  }
}
