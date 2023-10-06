import 'package:auth_repo/auth_repo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:my_expense_tracker/auth/bloc/auth_bloc.dart';
import 'package:my_expense_tracker/l10n/l10n.dart';
import 'package:my_expense_tracker/login/view/login_page.dart';
import 'package:my_expense_tracker/main/main.dart';
import 'package:my_expense_tracker/utils/cubit/firebase_cubit.dart';
import 'package:my_expense_tracker/utils/utils.dart';
import 'package:services_repo/services_repo.dart';

class App extends StatelessWidget {
  const App({
    required this.authRepo,
    required this.servicesRepo,
    super.key,
  });
  final AuthRepo authRepo;
  final ServicesRepo servicesRepo;
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepo),
        RepositoryProvider.value(value: servicesRepo),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => FirebaseCubit(
              authRepo: authRepo,
              servicesRepo: servicesRepo,
            ),
          ),
          BlocProvider(
            create: (context) => MainCubit(
              authRepo,
              servicesRepo,
            ),
          ),
          BlocProvider(
            create: (context) => AuthBloc(
              authenticationRepository: authRepo,
              firebaseCubit: context.read(),
              servicesRepository: servicesRepo,
            ),
          ),
        ],
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state.status == AuthStatus.unauthenticated) {
              navKey.currentState
                  ?.pushAndRemoveUntil(LoginPage.route(), (route) => false);
            }
            if (state.status == AuthStatus.authenticated) {
              navKey.currentState
                  ?.pushAndRemoveUntil(MainPage.route(), (route) => false);
            }
          },
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: AppBarTheme(
                backgroundColor: Theme.of(context).colorScheme.inversePrimary,
              ),
              useMaterial3: true,
            ),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            builder: EasyLoading.init(),
            navigatorKey: navKey,
            home: StreamBuilder(
              stream: authInstance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return const MainPage();
                }
                return const LoginPage();
              },
            ),
          ),
        ),
      ),
    );
  }
}
