import 'package:authentication_bloc/bloc/auth/auth_bloc.dart';
import 'package:authentication_bloc/cubit/cubit.dart';
import 'package:authentication_bloc/screens/screens.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logger/logger.dart';

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
      body: MultiBlocListener(
        listeners: [
          BlocListener<AuthBloc, AuthState>(
            listenWhen: (prevState, state) => prevState != state,
            listener: (context, state) {
              if (state.status == EAuthStatus.unauthenticated) {
                Navigator.of(context).pushNamed(SignInScreen.routeName);
              }
            },
          ),
          BlocListener<AccountCubit, AccountState>(
              listenWhen: (prevState, state) => prevState.status != state.status,
              listener: (context, state) {
                Navigator.pushNamedAndRemoveUntil(context, SplashScreen.routeName, (_) => false);

                if (state.status == EAccountStatus.created) {
                  Navigator.of(context).pushNamed(HomeScreen.routeName, arguments: true);
                }
                if (state.status == EAccountStatus.uncreated) {
                  Navigator.of(context).pushNamed(AccountCreateScreen.routeName);
                }
              }),
        ],
        child: const Scaffold(
            body: Center(
          child: CircularProgressIndicator(),
        )),
      ),
    );
  }
}
