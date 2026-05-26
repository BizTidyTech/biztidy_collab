// ignore_for_file: depend_on_referenced_packages

import 'package:biztidy_mobile_app/app/resources/app.router.dart';
import 'package:biztidy_mobile_app/app/services/navigation_service.dart';
import 'package:biztidy_mobile_app/ui/features_user/nav_bar/data/page_index_class.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_strings.dart';
import 'package:biztidy_mobile_app/utils/app_constants/app_theme_data.dart';
import 'package:biztidy_mobile_app/utils/app_constants/theme_notifier.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';

var logger = Logger(printer: PrettyPrinter());

class TidyTechApp extends StatelessWidget {
  const TidyTechApp({super.key});

  static final _router = AppRouter.router;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentPage()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp.router(
            title: AppStrings.tidyTechTitle,
            scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            theme: appThemeData,
            darkTheme: appDarkThemeData,
            themeMode: themeNotifier.mode,
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
          );
        },
      ),
    );
  }
}

class AdminTidyTechApp extends StatelessWidget {
  const AdminTidyTechApp({super.key});

  static final _router = AdminAppRouter.router;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentPage()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp.router(
            title: AppStrings.tidyTechTitle,
            scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            theme: appThemeData,
            darkTheme: appDarkThemeData,
            themeMode: themeNotifier.mode,
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
          );
        },
      ),
    );
  }
}

class AgentTidyTechApp extends StatelessWidget {
  const AgentTidyTechApp({super.key});

  static final _router = AgentAppRouter.router;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CurrentPage()),
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
      ],
      child: Consumer<ThemeNotifier>(
        builder: (context, themeNotifier, _) {
          return MaterialApp.router(
            title: 'BizTidy Agent',
            scaffoldMessengerKey: NavigationService.scaffoldMessengerKey,
            debugShowCheckedModeBanner: false,
            theme: appThemeData,
            darkTheme: appDarkThemeData,
            themeMode: themeNotifier.mode,
            routeInformationProvider: _router.routeInformationProvider,
            routeInformationParser: _router.routeInformationParser,
            routerDelegate: _router.routerDelegate,
          );
        },
      ),
    );
  }
}
