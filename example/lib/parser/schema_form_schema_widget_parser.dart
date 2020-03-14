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
import 'package:flutter/src/widgets/framework.dart';
import 'package:json_schema/json_schema.dart';
import 'package:logging/logging.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';
import 'package:schema_form/schema_form.dart';
import 'package:schema_widget/schema_widget.dart';

/// [SchemaWidgetParser] to parse [SchemaForm].
class SchemaFormSchemaWidgetParser extends SchemaWidgetParser {
  static final Logger _log = Logger("SchemaFormParser");

  @override
  String get parserName => "SchemaForm";

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
    _log.finer(map);

    var jsonSchemaBloc = JsonSchemaBloc(formContext: buildContext);

    _log.finer('layout: ${map["layout"]}');
    _log.finer('schema: ${map["schema"]}');
    _log.finer('data: ${map["data"]}');

    jsonSchemaBloc.add(LoadLayoutSchemaEvent(layout: map["layout"]));
    jsonSchemaBloc.add(LoadDataSchemaEvent(
        dataSchema: JsonSchema.createSchema(map["schema"])));
    jsonSchemaBloc.add(LoadDataEvent(data: map["data"]));

    return SchemaForm(
      jsonSchemaBloc: jsonSchemaBloc,
    );
  }
}
