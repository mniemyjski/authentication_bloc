import 'package:authentication_bloc/bloc/auth/auth_bloc.dart';
import 'package:authentication_bloc/cubit/cubit.dart';
import 'package:authentication_bloc/models/account.dart';
import 'package:authentication_bloc/repositories/repositories.dart';
import 'package:authentication_bloc/utilities/languages.dart';
import 'package:authentication_bloc/utilities/validators.dart';
import 'package:authentication_bloc/widgets/custom_drawer/custom_drawer.dart';
import 'package:authentication_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccountCreateScreen extends StatefulWidget {
  const AccountCreateScreen({Key? key}) : super(key: key);
  static const String routeName = '/create-account';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => AccountCreateScreen(),
    );
  }

  @override
  _AccountCreateScreenState createState() => _AccountCreateScreenState();
}

class _AccountCreateScreenState extends State<AccountCreateScreen> {
  final TextEditingController _controllerName = TextEditingController();
  final GlobalKey<FormState> _formKeyName = GlobalKey();

  @override
  void dispose() {
    _controllerName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        context.read<AuthBloc>().add(AuthDeleteRequested());
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(Languages.create_account()),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: _formKeyName,
                  child: TextFormField(
                    decoration: InputDecoration(labelText: Languages.name()),
                    textInputAction: TextInputAction.done,
                    controller: _controllerName,
                    validator: (v) => Validators.name(v),
                  ),
                ),
              ),
              CustomButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(Languages.create_account()),
                    ],
                  ),
                  onPressed: () async {
                    FocusScope.of(context).unfocus();
                    if (_formKeyName.currentState!.validate()) {
                      bool done = await context.read<AccountCubit>().createAccount(_controllerName.text);
                      await context.read<PreferenceCubit>().createPreference();

                      if (!done) customFlashBar(context, Languages.name_not_available());
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
