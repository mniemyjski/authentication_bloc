import 'package:authentication_bloc/screens/screens.dart';
import 'package:authentication_bloc/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';

class CustomRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('Route: ${settings.name}');

    // final args = settings.arguments as HomeScreenArguments;

    switch (settings.name) {
      case SplashScreen.routeName:
        return SplashScreen.route();
      case SignInScreen.routeName:
        return SignInScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Something went wrong!'),
        ),
      ),
    );
  }
}
