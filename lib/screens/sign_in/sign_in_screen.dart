import 'package:authentication_bloc/repositories/repositories.dart';
import 'package:authentication_bloc/screens/sign_in/cubit/sign_in_cubit.dart';
import 'package:authentication_bloc/screens/sign_in/widgets/button_sign_in_with_email.dart';
import 'package:authentication_bloc/screens/sign_in/widgets/button_sign_in_with_google.dart';
import 'package:authentication_bloc/screens/sign_in/widgets/email_form.dart';
import 'package:flutter/material.dart';
import 'package:authentication_bloc/utilities/utilities.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({Key? key}) : super(key: key);

  static const String routeName = '/sign-in';

  static Route route() {
    return PageRouteBuilder(
      settings: const RouteSettings(name: routeName),
      transitionDuration: const Duration(seconds: 0),
      pageBuilder: (context, _, __) => BlocProvider<SignInCubit>(
        create: (_) => SignInCubit(authRepository: context.read<AuthRepository>()),
        child: SignInScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: BlocBuilder<SignInCubit, SignInState>(
        builder: (context, state) {
          if (state.signInStatus == SignInStatus.loading)
            return const Scaffold(
                body: Center(
              child: CircularProgressIndicator(),
            ));

          return Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: (state.signInFormType != SignInFormType.initial)
                ? AppBar(
                    title: Text(context.watch<SignInCubit>().titleName()),
                    leading: IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () => context.read<SignInCubit>().changeForm(SignInFormType.initial),
                    ))
                : null,
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: Text(
                    Constants.app_name(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 56,
                    ),
                  ),
                ),
                if (state.signInFormType == SignInFormType.initial) ButtonSignInWithGoogle(),
                if (state.signInFormType == SignInFormType.initial) ButtonSignInWithEmail(),
                if (state.signInFormType != SignInFormType.initial) EmailForm(),
              ],
            ),
          );
        },
      ),
    );
  }
}