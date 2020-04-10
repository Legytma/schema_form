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
import 'package:schema_form/schema_form.dart';
import 'package:schema_widget/schema_widget.dart';

import 'json_utils.dart';

/// [StatelessWidget] main with dynamic creation from the interpretation of a
/// JSON.
class DynamicSchemaFormWidget extends StatelessWidget {
  static final Logger _log = Logger("DynamicSchemaFormWidget");
  static final String title = "Dynamic Layout";

  static bool _initialized = false;

  final GlobalKey<SchemaFormWidgetState> _schemaFormKey =
      GlobalKey<SchemaFormWidgetState>();

  /// Create [DynamicSchemaFormWidget]
  DynamicSchemaFormWidget({Key key}) : super(key: key) {
    initialize();

    SchemaWidget.registerLogic("schemaFromKey", _schemaFormKey);
    SchemaWidget.registerLogic("savePressed", _savePressed);
    SchemaWidget.registerLogic("onSave", _onSave);
  }

  /// Initialize [DynamicWidgetBuilder] adding new parsers
  static void initialize() {
    if (!_initialized) {
      SchemaWidget.registerParsers();
//      SchemaWidget.registerParser(SchemaFormWidgetSchemaWidgetParser());
//      SchemaWidget.registerParser(IconButtonSchemaWidgetParser());

//      SchemaForm.initialize();

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> params =
        ModalRoute.of(context).settings.arguments;

    return FutureBuilder(
      future: loadJsonFrom(context, params['fileLocate'], params['filePath']),
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

  void _onSave(value) => _log.info("Saved: $value");

  void _savePressed() {
    var schemaFormState = _schemaFormKey.currentState;

    //                  _log.finest("schemaFormState: $schemaFormState");

    var schemaFormSaved = schemaFormState.save();

    _log.info("schemaFormSaved: $schemaFormSaved");
  }
}
