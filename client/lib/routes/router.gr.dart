// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i6;
import 'package:client/pages/authentication/sign_in/sign_in_screen.dart' as _i2;
import 'package:client/pages/authentication/sign_up/sign_up_screen.dart' as _i3;
import 'package:client/pages/chat/chat_view.dart' as _i5;
import 'package:client/pages/home/home_view.dart' as _i4;
import 'package:client/pages/splash/splash_page.dart' as _i1;
import 'package:flutter/material.dart' as _i7;

class AppRouter extends _i6.RootStackRouter {
  AppRouter([_i7.GlobalKey<_i7.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i6.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.SignInPage(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.SignUpPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomePage(),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i6.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i5.ChatPage(
          key: args.key,
          myid: args.myid,
          recieverid: args.recieverid,
        ),
      );
    },
  };

  @override
  List<_i6.RouteConfig> get routes => [
        _i6.RouteConfig(
          SplashRoute.name,
          path: '/',
        ),
        _i6.RouteConfig(
          SignInRoute.name,
          path: '/sign-in-page',
        ),
        _i6.RouteConfig(
          SignUpRoute.name,
          path: '/sign-up-page',
        ),
        _i6.RouteConfig(
          HomeRoute.name,
          path: '/home-page',
        ),
        _i6.RouteConfig(
          ChatRoute.name,
          path: '/chat-page',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i6.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.SignInPage]
class SignInRoute extends _i6.PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: '/sign-in-page',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i3.SignUpPage]
class SignUpRoute extends _i6.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: '/sign-up-page',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i6.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home-page',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i5.ChatPage]
class ChatRoute extends _i6.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i7.Key? key,
    required String myid,
    required String recieverid,
  }) : super(
          ChatRoute.name,
          path: '/chat-page',
          args: ChatRouteArgs(
            key: key,
            myid: myid,
            recieverid: recieverid,
          ),
        );

  static const String name = 'ChatRoute';
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.myid,
    required this.recieverid,
  });

  final _i7.Key? key;

  final String myid;

  final String recieverid;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, myid: $myid, recieverid: $recieverid}';
  }
}
