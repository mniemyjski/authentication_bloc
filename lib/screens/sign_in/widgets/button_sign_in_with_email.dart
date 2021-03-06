import 'package:authentication_bloc/screens/sign_in/cubit/sign_in_cubit.dart';
import 'package:authentication_bloc/utilities/utilities.dart';
import 'package:authentication_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ButtonSignInWithEmail extends StatelessWidget {
  const ButtonSignInWithEmail({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomButton(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FaIcon(
              Icons.mail,
              size: 40,
              color: Colors.white,
            ),
            Text(Languages.sign_in_with_email()),
            Container(),
          ],
        ),
        onPressed: () {
          context.read<SignInCubit>().changeForm(SignInFormType.signIn);
        });
  }
}
