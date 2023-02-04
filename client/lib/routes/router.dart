import 'package:auto_route/auto_route.dart';
import 'package:client/pages/authentication/sign_in/sign_in_screen.dart';
import 'package:client/pages/chat/chat_view.dart';
import 'package:client/pages/home/home_view.dart';
import 'package:client/pages/splash/splash_page.dart';

import '../pages/authentication/sign_up/sign_up_screen.dart';

@AdaptiveAutoRouter(
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(page: SplashPage, initial: true),
    AutoRoute(page: SignInPage),
    AutoRoute(page: SignUpPage),
    AutoRoute(page: HomePage),
    AutoRoute(page: ChatPage),
  ],
)
class $AppRouter {}


// flutter packages pub run build_runner watch