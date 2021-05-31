import 'package:authentication_bloc/bloc/auth/auth_bloc.dart';
import 'package:authentication_bloc/screens/screens.dart';
import 'package:authentication_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  static const String routeName = '/';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (_) => SplashScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listenWhen: (prevState, state) => prevState.status != state.status,
        listener: (context, state) {
          if (state.status == AuthStatus.unauthenticated) {
            Navigator.of(context).pushNamed(SignInScreen.routeName);
          } else if (state.status == AuthStatus.authenticated) {
            Navigator.of(context).pushNamed(HomeScreen.routeName);
          }
        },
        builder: (context, state) {
          return const Scaffold(
              body: Center(
            child: CircularProgressIndicator(),
          ));
        },
      ),
    );
  }
}
