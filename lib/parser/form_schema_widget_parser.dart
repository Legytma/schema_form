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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_schema/src/json_schema/json_schema.dart';
import 'package:logging/logging.dart';
import 'package:schema_widget/schema_widget.dart';

import '../bloc/json_schema_bl.dart';

/// [SchemaWidgetParser] to parse [Form]
class FormSchemaWidgetParser extends SchemaWidgetParser {
  static final Logger _log = Logger("FormParser");

  @override
  String get parserName => "Form";

  @override
  JsonSchema get jsonSchema => JsonSchema.createSchema({
        "\$schema": "http://json-schema.org/draft-06/schema#",
//        "\$id": "#widget-schema",
        "title": "Container Parser Schema",
        "description": "Schema to validation of JSON used to parse Container"
            " Widget.",
        "type": "object",
        "\$comment": "You can add all valid properties to complete validation.",
        "properties": {
          "type": {
            "\$comment": "Used to identify parser. Every parser can permit only"
                " one type",
            "title": "Type",
            "description": "Identify the widget type",
            "type": "string",
            "default": parserName,
            "examples": [parserName],
            "enum": [parserName],
            "const": parserName,
          },
        },
        "required": ["type"],
      });

  @override
  Widget builder(BuildContext buildContext, Map<String, dynamic> map) {
    _log.finer('map: $map');

    var jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(buildContext);

    _log.finer('jsonSchemaBloc: $jsonSchemaBloc');

    BlocBuilder blocBuilder = BlocBuilder<JsonSchemaBloc, JsonSchemaState>(
      bloc: jsonSchemaBloc,
      condition: (previousState, state) {
        _log.finer("state.dataSchema: ${state.dataSchema}");

        return previousState.dataSchema != state.dataSchema;
      },
      builder: (context, dataSchema) {
        _log.finer("dataSchema: $dataSchema");

        if (dataSchema == null) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Form(
            key: jsonSchemaBloc.formKey,
            autovalidate:
                map.containsKey('autovalidate') ? map['autovalidate'] : false,
            onChanged: jsonSchemaBloc.onFormChanged,
            onWillPop: jsonSchemaBloc.onFormWillPop,
            child: map.containsKey('child')
                ? SchemaWidget.build(buildContext, map['child'])
                : Container(),
          );
        }
      },
    );

    return blocBuilder;
  }
}
