import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:group_chat_app/features/global/themes/style.dart';
import 'package:group_chat_app/features/global/widgets/custom_text_field.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_chat_app/features/user/presentation/cubit/credential/credential_cubit.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  TextEditingController emailController = TextEditingController();
  FocusNode emailFocusNode = FocusNode();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: () {
            emailFocusNode.unfocus();
          },
          child: Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(25.0),
              child: SafeArea(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Forgot\nPassword.",
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.w900,
                        color: greenColor,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Please enter the email which you forgot the password to, we will send you a link to reset your password",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey[700],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomTextField(
                      controller: emailController,
                      hint: "Email",
                      focusNode: emailFocusNode,
                      iconData: Icons.email,
                      obscureText: false,
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        style: ButtonStyle(
                          shape: WidgetStatePropertyAll(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          backgroundColor:
                              const WidgetStatePropertyAll(greenColor),
                          enableFeedback: true,
                        ),
                        onPressed: () {
                          if (emailController.text.isEmpty) {
                            Fluttertoast.showToast(
                                msg: "Please enter an email");
                          } else {
                            setState(
                              () {
                                isLoading = true;
                              },
                            );
                            try {
                              BlocProvider.of<CredentialCubit>(context)
                                  .forgotPassword(emailController.text)
                                  .then(
                                (value) {
                                  setState(
                                    () {
                                      isLoading = false;
                                    },
                                  );
                                  Fluttertoast.showToast(
                                      msg:
                                          "An email has been sent to your email, please check it out");
                                  emailController.clear();
                                },
                              );
                            } on SocketException catch (e) {
                              Fluttertoast.showToast(msg: e.message);
                            } on PlatformException catch (e) {
                              Fluttertoast.showToast(msg: e.message ?? "Error");
                            } catch (_) {
                              Fluttertoast.showToast(msg: "Error");
                            }
                          }
                        },
                        child: const Text("Send Password Reset Email"),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        isLoading
            ? Container(
                width: double.infinity,
                height: double.infinity,
                color: const Color.fromARGB(150, 0, 0, 0),
              )
            : Container(),
        isLoading
            ? Center(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.black,
                      ),
                      SizedBox(width: 20),
                      Material(
                        type: MaterialType.transparency,
                        child: Text(
                          "Sending Password Reset Link",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Container(),
      ],
    );
  }
}
