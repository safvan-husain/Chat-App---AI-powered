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
import 'package:auto_route/auto_route.dart' as _i8;
import 'package:client/local_database/message_schema.dart' as _i11;
import 'package:client/models/user_model.dart' as _i10;
import 'package:client/pages/authentication/google/google_sign_in.dart' as _i7;
import 'package:client/pages/authentication/google/google_sign_up.dart' as _i6;
import 'package:client/pages/chat/chat_view.dart' as _i3;
import 'package:client/pages/home/home_view.dart' as _i1;
import 'package:client/pages/profile/avatar/avatar.dart' as _i2;
import 'package:client/pages/profile/profile_view.dart' as _i5;
import 'package:client/pages/settings/settings_view.dart' as _i4;
import 'package:flutter/material.dart' as _i9;

class AppRouter extends _i8.RootStackRouter {
  AppRouter([_i9.GlobalKey<_i9.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i8.PageFactory> pagesMap = {
    HomeRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i1.HomePage(),
      );
    },
    HoemRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i2.HoemPage(),
      );
    },
    ChatRoute.name: (routeData) {
      final args = routeData.argsAs<ChatRouteArgs>();
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i3.ChatPage(
          key: args.key,
          user: args.user,
          allmessages: args.allmessages,
        ),
      );
    },
    SettingsRoute.name: (routeData) {
      final args = routeData.argsAs<SettingsRouteArgs>(
          orElse: () => const SettingsRouteArgs());
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i4.SettingsPage(key: args.key),
      );
    },
    ProfileRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i5.ProfilePage(),
      );
    },
    GoogleSignUpRoute.name: (routeData) {
      final args = routeData.argsAs<GoogleSignUpRouteArgs>(
          orElse: () => const GoogleSignUpRouteArgs());
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: _i6.GoogleSignUpPage(key: args.key),
      );
    },
    GoogleSignInRoute.name: (routeData) {
      return _i8.AdaptivePage<dynamic>(
        routeData: routeData,
        child: const _i7.GoogleSignInPage(),
      );
    },
  };

  @override
  List<_i8.RouteConfig> get routes => [
        _i8.RouteConfig(
          HomeRoute.name,
          path: '/home-page',
        ),
        _i8.RouteConfig(
          HoemRoute.name,
          path: '/hoem-page',
        ),
        _i8.RouteConfig(
          ChatRoute.name,
          path: '/chat-page',
        ),
        _i8.RouteConfig(
          SettingsRoute.name,
          path: '/settings-page',
        ),
        _i8.RouteConfig(
          ProfileRoute.name,
          path: '/profile-page',
        ),
        _i8.RouteConfig(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
        ),
        _i8.RouteConfig(
          GoogleSignInRoute.name,
          path: '/',
        ),
      ];
}

/// generated route for
/// [_i1.HomePage]
class HomeRoute extends _i8.PageRouteInfo<void> {
  const HomeRoute()
      : super(
          HomeRoute.name,
          path: '/home-page',
        );

  static const String name = 'HomeRoute';
}

/// generated route for
/// [_i2.HoemPage]
class HoemRoute extends _i8.PageRouteInfo<void> {
  const HoemRoute()
      : super(
          HoemRoute.name,
          path: '/hoem-page',
        );

  static const String name = 'HoemRoute';
}

/// generated route for
/// [_i3.ChatPage]
class ChatRoute extends _i8.PageRouteInfo<ChatRouteArgs> {
  ChatRoute({
    _i9.Key? key,
    required _i10.User user,
    required List<_i11.Message> allmessages,
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

  final _i9.Key? key;

  final _i10.User user;

  final List<_i11.Message> allmessages;

  @override
  String toString() {
    return 'ChatRouteArgs{key: $key, user: $user, allmessages: $allmessages}';
  }
}

/// generated route for
/// [_i4.SettingsPage]
class SettingsRoute extends _i8.PageRouteInfo<SettingsRouteArgs> {
  SettingsRoute({_i9.Key? key})
      : super(
          SettingsRoute.name,
          path: '/settings-page',
          args: SettingsRouteArgs(key: key),
        );

  static const String name = 'SettingsRoute';
}

class SettingsRouteArgs {
  const SettingsRouteArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'SettingsRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i5.ProfilePage]
class ProfileRoute extends _i8.PageRouteInfo<void> {
  const ProfileRoute()
      : super(
          ProfileRoute.name,
          path: '/profile-page',
        );

  static const String name = 'ProfileRoute';
}

/// generated route for
/// [_i6.GoogleSignUpPage]
class GoogleSignUpRoute extends _i8.PageRouteInfo<GoogleSignUpRouteArgs> {
  GoogleSignUpRoute({_i9.Key? key})
      : super(
          GoogleSignUpRoute.name,
          path: '/google-sign-up-page',
          args: GoogleSignUpRouteArgs(key: key),
        );

  static const String name = 'GoogleSignUpRoute';
}

class GoogleSignUpRouteArgs {
  const GoogleSignUpRouteArgs({this.key});

  final _i9.Key? key;

  @override
  String toString() {
    return 'GoogleSignUpRouteArgs{key: $key}';
  }
}

/// generated route for
/// [_i7.GoogleSignInPage]
class GoogleSignInRoute extends _i8.PageRouteInfo<void> {
  const GoogleSignInRoute()
      : super(
          GoogleSignInRoute.name,
          path: '/',
        );

  static const String name = 'GoogleSignInRoute';
}
