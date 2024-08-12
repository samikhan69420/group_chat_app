import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:group_chat_app/features/app/home/home_page.dart';
import 'package:group_chat_app/features/global/const/page_const.dart';
import 'package:group_chat_app/features/global/themes/style.dart';
import 'package:group_chat_app/features/global/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:group_chat_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/credential/credential_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FocusNode? emailFocusNode = FocusNode();
  final FocusNode? passwordFocusNode = FocusNode();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    emailFocusNode!.dispose();
    passwordFocusNode!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        emailFocusNode!.unfocus();
        passwordFocusNode!.unfocus();
      },
      child: BlocConsumer<CredentialCubit, CredentialState>(
        listener: (context, credentialState) {
          if (credentialState is CredentialSuccess) {
            BlocProvider.of<AuthCubit>(context).loggedIn();
          } else if (credentialState is CredentialFailure) {
            Fluttertoast.showToast(msg: "Error.");
          }
        },
        builder: (context, state) {
          if (state is CredentialLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            );
          } else if (state is CredentialSuccess) {
            return BlocBuilder<AuthCubit, AuthState>(
              builder: (context, state) {
                if (state is Authenticated) {
                  return HomePage(uid: state.uid);
                } else {
                  return bodyWidget();
                }
              },
            );
          }
          return bodyWidget();
        },
      ),
    );
  }

  Widget bodyWidget() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Login",
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w900,
                  color: greenColor,
                ),
              ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 20),
              CustomTextField(
                controller: emailController,
                hint: "Email",
                focusNode: emailFocusNode,
                iconData: Icons.email,
                obscureText: false,
              ),
              const SizedBox(height: 10),
              CustomTextField(
                controller: passwordController,
                hint: "Password",
                focusNode: passwordFocusNode,
                iconData: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Spacer(),
                  InkWell(
                    onTap: () {},
                    child: const Text(
                      "Forgot Password",
                      style: TextStyle(
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  style: ButtonStyle(
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10))),
                    backgroundColor: const WidgetStatePropertyAll(greenColor),
                    enableFeedback: true,
                  ),
                  onPressed: () {
                    _subitLogin();
                  },
                  child: const Text("Login"),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: <Widget>[
                  const Text("Don't have an account? "),
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        PageConst.signUpPage,
                      );
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                        color: greenColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Center(
                child: InkWell(
                  onTap: () {
                    BlocProvider.of<CredentialCubit>(context)
                        .submitGoogleAuth();
                  },
                  child: const CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.red,
                    child: FaIcon(
                      FontAwesomeIcons.google,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _subitLogin() {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Neither Fields can be empty");
    } else {
      BlocProvider.of<CredentialCubit>(context).submitSignIn(
          email: emailController.text, password: passwordController.text);
    }
  }
}
