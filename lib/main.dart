import 'package:authentication_bloc/cubit/upload_to_storage/update_avatar_cubit.dart';
import 'package:authentication_bloc/repositories/preference_repository.dart';
import 'package:authentication_bloc/screens/screens.dart';
import 'package:authentication_bloc/utilities/utilities.dart';
import 'package:bot_toast/bot_toast.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:easy_localization_loader/easy_localization_loader.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:url_strategy/url_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import 'bloc/bloc.dart';
import 'cubit/cubit.dart';
import 'repositories/repositories.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  EquatableConfig.stringify = false;
  setPathUrlStrategy();
  Bloc.observer = SimpleBlocObserver();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb ? HydratedStorage.webStorageDirectory : await getTemporaryDirectory(),
  );
  runApp(EasyLocalization(
      supportedLocales: [
        Locale('pl'),
        Locale('en'),
      ],
      path: 'resources/languages.csv',
      saveLocale: true,
      useOnlyLangCode: true,
      assetLoader: CsvAssetLoader(),
      fallbackLocale: Locale('pl'),
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthRepository>(
          create: (_) => AuthRepository(),
        ),
        RepositoryProvider<AccountRepository>(
          create: (_) => AccountRepository(),
        ),
        RepositoryProvider<StorageRepository>(
          create: (_) => StorageRepository(),
        ),
        RepositoryProvider<PreferenceRepository>(
          create: (_) => PreferenceRepository(),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<DarkModeCubit>(
            create: (context) => DarkModeCubit(),
          ),
          BlocProvider<AuthBloc>(
            create: (context) => AuthBloc(
              authRepository: context.read<AuthRepository>(),
            ),
          ),
          BlocProvider<AccountCubit>(
            create: (context) => AccountCubit(
              authBloc: context.read<AuthBloc>(),
              accountRepository: context.read<AccountRepository>(),
            ),
          ),
          BlocProvider<PreferenceCubit>(
            create: (context) => PreferenceCubit(
              accountCubit: context.read<AccountCubit>(),
              preferenceRepository: context.read<PreferenceRepository>(),
            ),
          ),
          BlocProvider<UpdateAvatarCubit>(
            create: (context) => UpdateAvatarCubit(
              accountCubit: context.read<AccountCubit>(),
              accountRepository: context.read<AccountRepository>(),
              storageRepository: context.read<StorageRepository>(),
            ),
          ),
        ],
        child: BlocBuilder<DarkModeCubit, bool>(
          builder: (context, state) {
            return MaterialApp(
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              title: 'Authentication',
              builder: BotToastInit(),
              navigatorObservers: [BotToastNavigatorObserver()],
              theme: ThemeData(
                fontFamily: 'Georgia',
                primarySwatch: Colors.indigo,
              ),
              darkTheme: ThemeData(
                fontFamily: 'Georgia',
                brightness: Brightness.dark,
              ),
              themeMode: state ? ThemeMode.dark : ThemeMode.light,
              onGenerateRoute: CustomRouter.onGenerateRoute,
              initialRoute: SplashScreen.routeName,
            );
          },
        ),
      ),
    );
  }
}
