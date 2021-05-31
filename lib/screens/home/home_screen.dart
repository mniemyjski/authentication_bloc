import 'package:authentication_bloc/repositories/repositories.dart';
import 'package:authentication_bloc/screens/home/cubit/home_cubit.dart';
import 'package:authentication_bloc/utilities/languages.dart';
import 'package:authentication_bloc/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  static const String routeName = '/home';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<HomeCubit>(
        create: (_) => HomeCubit(authRepository: context.read<AuthRepository>()),
        child: HomeScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                  onPressed: () {
                    context.read<HomeCubit>().signOut();
                  },
                  child: Text(Languages.sign_out())),
            ],
          ),
        ),
      ),
    );
  }
}
