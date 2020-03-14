// Copyright (c) 2019 Legytma Soluções Inteligentes (https://legytma.com.br).
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

library schema_form;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schema_widget/schema_widget.dart';

import 'bloc/json_schema_bl.dart';
import 'parser/form_schema_widget_parser.dart';
import 'parser/schema_checkbox_form_field_schema_widget_parser.dart';
import 'parser/schema_column_radio_list_tile_form_field_schema_widget_parser.dart';
import 'parser/schema_dropdown_button_form_field_schema_widget_parser.dart';
import 'parser/schema_row_radio_list_tile_form_field_schema_widget_parser.dart';
import 'parser/schema_switch_form_field_schema_widget_parser.dart';
import 'parser/schema_text_form_field_schema_widget_parser.dart';
import 'parser/schema_text_schema_widget_parser.dart';

/// [StatelessWidget] for building forms dynamically from JSON schema interpretation.
/// It takes two JSONs to build the form. A third JSON can be used as a data
/// source, which in turn needs to be in accordance with the data schema.
///
/// ## Examples
/// ### Minimal
/// ```dart
///   JsonSchemaBloc jsonSchemaBloc = JsonSchemaBloc(formContext: context);
///   SchemaForm schemaForm = SchemaForm(jsonSchemaBloc: jsonSchemaBloc);
///
///   File layoutSchemaFile = new File("layoutSchema.json");
///   File dataSchemaFile = new File("dataSchema.json");
///   File dataValueFile = new File("dataValue.json");
///
///   String layoutSchemaContent = layoutSchemaFile.readAsStringSync();
///   String dataSchemaContent = dataSchemaFile.readAsStringSync();
///   String dataValueContent = dataValueFile.readAsStringSync();
///
///   Map<String, dynamic> layoutSchemaMap = json.decode(layoutSchemaContent);
///   Map<String, dynamic> dataSchemaMap = json.decode(dataSchemaContent);
///   Map<String, dynamic> dataValueMap = json.decode(dataValueContent);
///
///   JsonSchema dataJsonSchema = JsonSchema.createSchema(dataSchemaMap);
///
///   jsonSchemaBloc.add(LoadLayoutSchemaEvent(layout: layoutSchemaMap));
///   jsonSchemaBloc.add(LoadDataSchemaEvent(dataSchema: dataJsonSchema));
///   jsonSchemaBloc.add(LoadDataEvent(data: dataValueMap));
/// ```
///
/// ### Complete
/// {@example test.dart}
///
/// ### Expected Outcome
/// <p align="center">
///   <img width="300" src="https://raw.githubusercontent.com/Legytma/schema_form/master/image1.png"/>
///   <img width="300" src="https://raw.githubusercontent.com/Legytma/schema_form/master/image2.png"/>
/// </p>
class SchemaForm extends StatelessWidget {
  static bool _initialized = false;

  /// [SchemaForm] Business Logic Object.
  ///
  /// TODO Remove field [jsonSchemaBloc]
  final JsonSchemaBloc jsonSchemaBloc;

  /// Create a [SchemaForm] using [JsonSchemaBloc].
  ///
  /// TODO Remove param [jsonSchemaBloc]
  SchemaForm({Key key, this.jsonSchemaBloc}) : super(key: key) {
    initialize();
  }

  /// Initialize [DynamicWidgetBuilder] adding new parsers
  static void initialize() {
    if (!_initialized) {
      SchemaWidget.registerParser(FormSchemaWidgetParser());
      SchemaWidget.registerParser(SchemaTextFormFieldSchemaWidgetParser());
      SchemaWidget.registerParser(SchemaTextSchemaWidgetParser());
      SchemaWidget.registerParser(SchemaCheckboxFormFieldSchemaWidgetParser());
      SchemaWidget.registerParser(
          SchemaColumnRadioListTileFormFieldSchemaWidgetParser());
      SchemaWidget.registerParser(
          SchemaRowRadioListTileFormFieldSchemaWidgetParser());
      SchemaWidget.registerParser(SchemaSwitchFormFieldSchemaWidgetParser());
      SchemaWidget.registerParser(
          SchemaDropdownButtonFormFieldSchemaWidgetParser());

      SchemaWidget.registerParsers();

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    // TODO Internalize recovery through the context of [JsonSchemaBloc]
    return BlocProvider<JsonSchemaBloc>(
      create: (buildContext) => jsonSchemaBloc,
      child: BlocBuilder<JsonSchemaBloc, JsonSchemaState>(
        bloc: jsonSchemaBloc,
        condition: (previousState, state) {
//              print("state.layout: ${state.layout}");

          return previousState.layout != state.layout;
        },
        builder: (context, state) {
//              print("layout: $layout");

          if (state.layout == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: SchemaWidget.build(context, state.layout),
            );
          }
        },
      ),
    );
  }
}
