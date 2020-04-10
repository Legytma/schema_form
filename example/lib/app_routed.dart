// Copyright (c) 2020 Legytma Soluções Inteligentes (https://legytma.com.br).
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'dynamic_schema_form_widget.dart';
import 'home_main_scaffold_params.dart';
import 'static_schema_form_widget.dart';

/// Static main [StatelessWidget]
class AppRouted extends StatelessWidget {
  static final Logger _log = Logger('AppRouted');

  static const locale = Locale("pt", "BR");

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: locale,
//      localizationsDelegates: [
//        // ... app-specific localization delegate[s] here
//        GlobalMaterialLocalizations.delegate,
//        GlobalWidgetsLocalizations.delegate,
//        GlobalCupertinoLocalizations.delegate,
//      ],
//      supportedLocales: [locale],

      navigatorKey: _navigatorKey,
      initialRoute: "home",
      onGenerateRoute: _onGenerateRoute,
      onGenerateTitle: _onGenerateTitle,
      onUnknownRoute: _onUnknownRoute,
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case "home":
        return _homeMaterialPageRoute(settings);

      case "static":
        return MaterialPageRoute(
          builder: (buildContext) => StaticSchemaFormWidget(),
          settings: settings,
        );

      case "dynamic":
        return MaterialPageRoute(
          builder: (buildContext) => DynamicSchemaFormWidget(),
          settings: settings,
        );
    }
  }

  String _onGenerateTitle(BuildContext context) {
    return "Schema Form Widget Examples";
  }

  Route _onUnknownRoute(RouteSettings settings) {
    return _homeMaterialPageRoute(settings);
  }

  _homeMaterialPageRoute(RouteSettings settings) => MaterialPageRoute(
        builder: (buildContext) => HomeWidget(),
        settings: settings.copyWith(arguments: {"title": HomeWidget.title}),
      );
}
