import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_x/pages/comment_page.dart';
import 'package:flutter_x/pages/edit_profile.dart';
import 'package:flutter_x/pages/home_page.dart';
import 'package:flutter_x/pages/landing_page.dart';
import 'package:flutter_x/pages/language_page.dart';
import 'package:flutter_x/pages/notification.dart';
import 'package:flutter_x/pages/post.dart';
import 'package:flutter_x/pages/profile.dart';
import 'package:flutter_x/pages/search_page.dart';
import 'package:flutter_x/pages/setting_page.dart';
import 'package:flutter_x/pages/sign_in_page.dart';
import 'package:flutter_x/pages/sign_up_page.dart';
import 'package:flutter_x/src/search/search_repository.dart';
import 'package:flutter_x/widgets/layout.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/home',
  routes: [
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/post',
      name: 'post',
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser == null) {
          return '/landing';
        }
        return null;
      },
      pageBuilder: (context, state) {
        return const NoTransitionPage<void>(
          child: PostPage(),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/language',
      name: 'language',
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser == null) {
          return '/landing';
        }
        return null;
      },
      pageBuilder: (context, state) {
        return const MaterialPage<void>(
          child: LanguagePage(),
        );
      },
    ),
    GoRoute(
      parentNavigatorKey: _rootNavigatorKey,
      path: '/otherprofile/:uid',
      name: 'otherprofile',
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser == null) {
          return '/landing';
        }
        return null;
      },
      pageBuilder: (context, state) {
        return MaterialPage<void>(
          child: ProfilePage(uid: state.pathParameters['uid']),
        );
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (BuildContext context, GoRouterState state, StatefulNavigationShell navigationShell) {
        return Dashboard(
          navigationShell: navigationShell,
        );
      },
      branches: <StatefulShellBranch>[
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/home',
              name: 'home',
              redirect: (context, state) {
                if (FirebaseAuth.instance.currentUser == null) {
                  return '/landing';
                }
                return null;
              },
              pageBuilder: (context, state) {
                return const NoTransitionPage<void>(
                  child: HomePage(),
                );
              },
              routes: <RouteBase>[
                GoRoute(
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'tweet/:id',
                  name: 'tweetpage',
                  pageBuilder: (context, state) {
                    TrackEvent.sendClickEvent(state.pathParameters['id'] as String, EventName.clickedTweet);
                    return MaterialPage<void>(
                      child: TweetPage(tweetId: state.pathParameters['id'] as String),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/search',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return const NoTransitionPage<void>(child: SearchPage());
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/notification',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return const NoTransitionPage<void>(child: NotificationPage());
              },
            ),
          ],
        ),
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/profile',
              pageBuilder: (BuildContext context, GoRouterState state) {
                return const NoTransitionPage<void>(child: ProfilePage());
              },
              routes: [
                GoRoute(
                  name: 'setting',
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'setting',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return const MaterialPage<void>(child: SettingPage());
                  },
                ),
                GoRoute(
                  name: 'editprofile',
                  parentNavigatorKey: _rootNavigatorKey,
                  path: 'editProfile',
                  pageBuilder: (BuildContext context, GoRouterState state) {
                    return const MaterialPage<void>(child: EditProfile());
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/landing',
      name: 'landing',
      redirect: (context, state) {
        if (FirebaseAuth.instance.currentUser != null) {
          return '/home';
        }
        return null;
      },
      pageBuilder: (context, state) {
        return const MaterialPage<void>(
          child: LandingPage(),
        );
      },
      routes: [
        GoRoute(
          name: 'signup',
          path: 'signUp',
          pageBuilder: (context, state) {
            return const MaterialPage<void>(
              child: SignUpPage(),
            );
          },
        ),
        GoRoute(
          name: 'signin',
          path: 'signIn',
          pageBuilder: (context, state) {
            return const MaterialPage<void>(
              child: SignInPage(),
            );
          },
        ),
      ],
    ),
  ],
);
