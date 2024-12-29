import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:group_chat_app/features/app/home/home_page.dart';
import 'package:group_chat_app/features/global/themes/style.dart';
import 'package:group_chat_app/features/group/presentation/cubit/chat/chat_cubit.dart';
import 'package:group_chat_app/features/group/presentation/cubit/group/group_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:group_chat_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/single_user/single_user_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/user/user_cubit.dart';
import 'package:group_chat_app/features/user/presentation/pages/credentials/login_page.dart';
import 'package:group_chat_app/firebase_options.dart';
import 'package:group_chat_app/on_generate_route.dart';
import 'features/injection_container.dart' as di;
import 'package:flutter_bloc/flutter_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await di.init();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(
            create: (_) => di.sl<AuthCubit>()..appStarted()),
        BlocProvider<CredentialCubit>(create: (_) => di.sl<CredentialCubit>()),
        BlocProvider<SingleUserCubit>(create: (_) => di.sl<SingleUserCubit>()),
        BlocProvider<UserCubit>(create: (_) => di.sl<UserCubit>()),
        BlocProvider<GroupCubit>(create: (_) => di.sl<GroupCubit>()),
        BlocProvider<ChatCubit>(create: (_) => di.sl<ChatCubit>()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: greenColor,
        ),
        title: "Group Chat App",
        initialRoute: "/",
        onGenerateRoute: OnGenerateRoute.route,
        routes: {
          "/": (context) => BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  if (state is Authenticated) {
                    return HomePage(
                      uid: state.uid,
                    );
                  } else {
                    return const LoginPage();
                  }
                },
              ),
        },
      ),
    );
  }
}
