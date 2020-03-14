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
import 'package:schema_form/schema_form.dart';
import 'package:schema_widget/schema_widget.dart';

import 'json_utils.dart';
import 'parser/schema_form_schema_widget_parser.dart';

/// [StatelessWidget] main with dynamic creation from the interpretation of a
/// JSON.
class MyDynamicApp extends StatelessWidget {
//  static final Logger _log = Logger("MyDynamicApp");

  static bool _initialized = false;

  final String _asset;

  /// Create [MyDynamicApp]
  MyDynamicApp(this._asset, {Key key}) : super(key: key) {
    initialize();
  }

  /// Initialize [DynamicWidgetBuilder] adding new parsers
  static void initialize() {
    if (!_initialized) {
      SchemaWidget.registerParser(SchemaFormSchemaWidgetParser());

      SchemaForm.initialize();

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loadJsonFrom(context, FileLocate.asset, _asset),
      builder: (futureContext, asyncSnapshot) {
        if (asyncSnapshot.hasData) {
          return SchemaWidget.build(context, asyncSnapshot.data);
        }

        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
