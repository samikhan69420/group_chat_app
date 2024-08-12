import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/features/app/home/home_page.dart';
import 'package:group_chat_app/features/global/const/page_const.dart';
import 'package:group_chat_app/features/global/themes/style.dart';
import 'package:group_chat_app/features/global/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_app/features/user/domain/entity/user_entity.dart';
import 'package:group_chat_app/features/user/presentation/cubit/auth/auth_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/auth/auth_state.dart';
import 'package:group_chat_app/features/user/presentation/cubit/credential/credential_cubit.dart';
import 'package:group_chat_app/features/user/presentation/cubit/credential/credential_state.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final FocusNode? usernameFocusNode = FocusNode();
  final FocusNode? emailFocusNode = FocusNode();
  final FocusNode? passwordFocusNode = FocusNode();
  final FocusNode? passwordAgainFocusNode = FocusNode();

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController passwordAgainController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CredentialCubit, CredentialState>(
      listener: (context, credentialState) {
        if (credentialState is CredentialSuccess) {
          BlocProvider.of<AuthCubit>(context).loggedIn();
        } else if (credentialState is CredentialFailure) {
          // Fluttertoast.showToast(msg: "Wrong Email and Password Combination.");
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
    );
  }

  Widget bodyWidget() {
    return GestureDetector(
      onTap: () {
        emailFocusNode!.unfocus();
        passwordFocusNode!.unfocus();
        usernameFocusNode!.unfocus();
        passwordAgainFocusNode!.unfocus();
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25.0),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Registration",
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
                  hint: "Username",
                  focusNode: usernameFocusNode,
                  iconData: Icons.person,
                  controller: usernameController,
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hint: "Email",
                  focusNode: emailFocusNode,
                  iconData: Icons.email,
                  controller: emailController,
                  obscureText: false,
                ),
                const SizedBox(height: 10),
                const Center(
                  child: SizedBox(
                    width: 200,
                    child: Divider(
                      thickness: 2,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hint: "Password",
                  focusNode: passwordFocusNode,
                  iconData: Icons.lock,
                  controller: passwordController,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hint: "Password Again",
                  focusNode: passwordAgainFocusNode,
                  iconData: Icons.lock,
                  controller: passwordAgainController,
                  obscureText: true,
                ),
                const SizedBox(height: 10),
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
                      submitSignUp();
                    },
                    child: const Text(
                      "Create your account",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    const Text("Already have an account? "),
                    InkWell(
                      onTap: () {
                        Navigator.pop(
                          context,
                          PageConst.loginPage,
                        );
                      },
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          color: greenColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void submitSignUp() {
    if (usernameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        passwordAgainController.text.isEmpty ||
        (passwordController.text != passwordAgainController.text)) {
      Fluttertoast.showToast(msg: "You didn't fill the fields correctly");
      return;
    } else {
      BlocProvider.of<CredentialCubit>(context).submitSignUp(
        UserEntity(
          email: emailController.text,
          password: passwordController.text,
          name: usernameController.text,
          profileUrl: "",
          status: "",
        ),
      );
    }
  }
}
