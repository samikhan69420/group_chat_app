import 'package:flutter/material.dart';
import 'package:group_chat_app/features/global/const/page_const.dart';
import 'package:group_chat_app/features/group/domain/entities/single_message_entity.dart';
import 'package:group_chat_app/features/group/presentation/pages/chat/single_chat_page.dart';
import 'package:group_chat_app/features/group/presentation/pages/create_group_page.dart';
import 'package:group_chat_app/features/user/presentation/pages/credentials/forgot_password_page.dart';
import 'package:group_chat_app/features/user/presentation/pages/credentials/login_page.dart';
import 'package:group_chat_app/features/user/presentation/pages/credentials/sign_up_page.dart';

class OnGenerateRoute {
  static Route<dynamic> route(RouteSettings routeSettings) {
    final args = routeSettings.arguments;

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
          return pageRoute(child: const ForgotPasswordPage());
        }
      case PageConst.singleChatPage:
        {
          if (args is SingleMessageEntity) {
            return pageRoute(child: SingleChatPage(singleMessageEntity: args));
          } else {
            return pageRoute(child: const ErrorPage());
          }
        }
      case PageConst.createGroupPage:
        {
          if (args is String) {
            return pageRoute(child: CreateGroupPage(uid: args));
          } else {
            return pageRoute(child: const ErrorPage());
          }
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
  const ErrorPage({
    super.key,
    this.text = "If you're on this page, then it means there was an error.",
  });

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
