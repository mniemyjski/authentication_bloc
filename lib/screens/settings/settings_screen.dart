import 'package:authentication_bloc/cubit/cubit.dart';
import 'package:authentication_bloc/repositories/repositories.dart';
import 'package:authentication_bloc/screens/home/cubit/home_cubit.dart';
import 'package:authentication_bloc/utilities/languages.dart';
import 'package:authentication_bloc/widgets/custom_button.dart';
import 'package:authentication_bloc/widgets/custom_drawer/custom_drawer.dart';
import 'package:authentication_bloc/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);
  static const String routeName = '/settings';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => SettingsScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(Languages.settings()),
        ),
        drawer: CustomDrawer(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomDropDownButton(
                name: Languages.locale_app(),
                value: context.locale.toString(),
                list: <String>['pl', 'en'],
                onChanged: (String? state) {
                  context.setLocale(Locale(state!));
                },
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    BlocBuilder<DarkModeCubit, bool>(
                      builder: (context, state) {
                        return Switch(
                          value: state,
                          onChanged: (state) {
                            context.read<DarkModeCubit>().change();
                          },
                        );
                      },
                    ),
                    Text(Languages.dark_mode()),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
