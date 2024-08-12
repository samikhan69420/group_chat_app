import 'package:flutter/material.dart';
import 'package:group_chat_app/features/global/const/page_const.dart';
import 'package:group_chat_app/features/user/presentation/pages/credentials/login_page.dart';
import 'package:group_chat_app/features/user/presentation/pages/credentials/sign_up_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case PageConst.loginPage:
        {
          return pageRoute(child: const LoginPage());
        }
      case PageConst.signUpPage:
        {
          return pageRoute(child: const SignUpPage());
        }
      case PageConst.forgotPasswordPage:
        {
          return pageRoute(child: const LoginPage());
        }
      case PageConst.singleChatPage:
        {
          return pageRoute(child: const LoginPage());
        }
      case PageConst.createGroupPage:
        {
          return pageRoute(child: const LoginPage());
        }
      default:
        {
          return pageRoute(child: const ErrorPage());
        }
    }
  }
}

MaterialPageRoute pageRoute({required Widget child}) {
  return MaterialPageRoute(
    builder: (context) => child,
  );
}

class ErrorPage extends StatelessWidget {
  final String? text;
  const ErrorPage(
      {super.key,
      this.text = "If you're on this page, then it means there was an error."});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          textAlign: TextAlign.center,
          "Error\n$text",
        ),
      ),
    );
  }
}
