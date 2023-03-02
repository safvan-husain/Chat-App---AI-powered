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
import 'package:auto_route/auto_route.dart' as _i11;
import 'package:client/local_database/message_schema.dart' as _i14;
import 'package:client/models/user_model.dart' as _i13;
import 'package:client/pages/authentication/google/google_sign_in.dart' as _i10;
import 'package:client/pages/authentication/google/google_sign_up.dart' as _i9;
import 'package:client/pages/authentication/sign_in/sign_in_screen.dart' as _i2;
import 'package:client/pages/authentication/sign_up/sign_up_screen.dart' as _i3;
import 'package:client/pages/chat/chat_view.dart' as _i6;
import 'package:client/pages/home/home_view.dart' as _i4;
import 'package:client/pages/profile/avatar/avatar.dart' as _i5;
import 'package:client/pages/profile/profile_view.dart' as _i8;
import 'package:client/pages/settings/settings_view.dart' as _i7;
import 'package:client/pages/splash/splash_page.dart' as _i1;
import 'package:flutter/material.dart' as _i12;

class AppRouter extends _i11.RootStackRouter {
  AppRouter([_i12.GlobalKey<_i12.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i11.PageFactory> pagesMap = {
    SplashRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.SplashPage(),
      );
    },
    SignInRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i2.SignInPage(),
      );
    },
    SignUpRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i3.SignUpPage(),
      );
    },
    HomeRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i4.HomePage(),
      );
    },
    HoemRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i5.HoemPage(),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.ChatPage(
          key: args.key,
          user: args.user,
          allmessages: args.allmessages,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      final args = routeData.argsAs<SettingsRouteArgs>(
          orElse: () => const SettingsRouteArgs());
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i7.SettingsPage(key: args.key),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i8.ProfilePage(),
      );
    },
    GoogleSignUpRoute.name: (routeData) {
      final args = routeData.argsAs<GoogleSignUpRouteArgs>(
          orElse: () => const GoogleSignUpRouteArgs());
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i9.GoogleSignUpPage(key: args.key),
      );
    },
    GoogleSignInRoute.name: (routeData) {
      return _i11.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i10.GoogleSignInPage(),
      );
    },
  };

  @override
  List<_i11.RouteConfig> get routes => [
        _i11.RouteConfig(
          SplashRoute.name,
          path: '/splash-page',
        ),
        _i11.RouteConfig(
          SignInRoute.name,
          path: '/sign-in-page',
        ),
        _i11.RouteConfig(
          SignUpRoute.name,
          path: '/sign-up-page',
        ),
        _i11.RouteConfig(
          HomeRoute.name,
          path: '/home-page',
        ),
        _i11.RouteConfig(
          HoemRoute.name,
          path: '/hoem-page',
        ),
        _i11.RouteConfig(
          ChatRoute.name,
          path: '/chat-page',
        ),
        _i11.RouteConfig(
          SettingsRoute.name,
          path: '/settings-page',
        ),
        _i11.RouteConfig(
          ProfileRoute.name,
          path: '/profile-page',
        ),
        _i11.RouteConfig(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
        ),
        _i11.RouteConfig(
          GoogleSignInRoute.name,
          path: '/',
        ),
      ];
}

/// generated route for
/// [_i1.SplashPage]
class SplashRoute extends _i11.PageRouteInfo<void> {
  const SplashRoute()
      : super(
          SplashRoute.name,
          path: '/splash-page',
        );

  static const String name = 'SplashRoute';
}

/// generated route for
/// [_i2.SignInPage]
class SignInRoute extends _i11.PageRouteInfo<void> {
  const SignInRoute()
      : super(
          SignInRoute.name,
          path: '/sign-in-page',
        );

  static const String name = 'SignInRoute';
}

/// generated route for
/// [_i3.SignUpPage]
class SignUpRoute extends _i11.PageRouteInfo<void> {
  const SignUpRoute()
      : super(
          SignUpRoute.name,
          path: '/sign-up-page',
        );

  static const String name = 'SignUpRoute';
}

/// generated route for
/// [_i4.HomePage]
class HomeRoute extends _i11.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home-page',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i5.HoemPage]
class HoemRoute extends _i11.PageRouteInfo<void> {
  const HoemRoute()
      : super(
          HoemRoute.name,
          path: '/hoem-page',
        );

  static const String name = 'HoemRoute';
}

/// generated route for
/// [_i6.ChatPage]
class ChatRoute extends _i11.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i12.Key? key,
    required _i13.User user,
    required List<_i14.Message> allmessages,
  }) : super(
          ChatRoute.name,
          path: '/chat-page',
          args: ChatRouteArgs(
            key: key,
            user: user,
            allmessages: allmessages,
          ),
        );

  static const String name = 'ChatRoute';
}

class ChatRouteArgs {
  const ChatRouteArgs({
    this.key,
    required this.user,
    required this.allmessages,
  });

  final _i12.Key? key;

  final _i13.User user;

  final List<_i14.Message> allmessages;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, user: $user, allmessages: $allmessages}';
  }
}

/// generated route for
/// [_i7.SettingsPage]
class SettingsRoute extends _i11.PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({_i12.Key? key})
      : super(
          SettingsRoute.name,
          path: '/settings-page',
          args: SettingsRouteArgs(key: key),
        );

  static const String name = 'SettingsRoute';
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key});

  final _i12.Key? key;

  @override
  String toString() {
    return 'SettingsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i8.ProfilePage]
class ProfileRoute extends _i11.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: '/profile-page',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i9.GoogleSignUpPage]
class GoogleSignUpRoute extends _i11.PageRouteInfo<GoogleSignUpRouteArgs> {
  GoogleSignUpRoute({_i12.Key? key})
      : super(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
          args: GoogleSignUpRouteArgs(key: key),
        );

  static const String name = 'GoogleSignUpRoute';
}

class GoogleSignUpRouteArgs {
  const GoogleSignUpRouteArgs({this.key});

  final _i12.Key? key;

  @override
  String toString() {
    return 'GoogleSignUpRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i10.GoogleSignInPage]
class GoogleSignInRoute extends _i11.PageRouteInfo<void> {
  const GoogleSignInRoute()
      : super(
          GoogleSignInRoute.name,
          path: '/',
        );

  static const String name = 'GoogleSignInRoute';
}
