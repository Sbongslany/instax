import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:instax/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:user_repository/user_repository.dart';
import 'app_view.dart';

class MianApp extends StatelessWidget {
  final UserRepository userRepository;
  const MianApp(this.userRepository, {super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
        providers: [
          RepositoryProvider<AuthenticationBloc>(
              create: (_) => AuthenticationBloc(
              myUserRepository: userRepository))
        ],
        child: const MyAppView()
    );
  }
}
