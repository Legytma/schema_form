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
import 'package:schema_widget/schema_widget.dart';

import '../bloc/json_schema_bl.dart';
import 'abstract_schema_radio_list_tile_form_field_schema_widget_parser.dart';

/// [SchemaRadioListTileFormFieldSchemaWidgetParser] to parse [Column] of
/// [RadioListTile].
class SchemaColumnRadioListTileFormFieldSchemaWidgetParser
    extends SchemaRadioListTileFormFieldSchemaWidgetParser {
  @override
  String get parserName => "SchemaColumnRadioListTileFormField";

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
    // ignore: close_sinks
    final jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(buildContext);

//      print('jsonSchemaBloc: $jsonSchemaBloc');
    var fieldSchema = jsonSchemaBloc.getPropertySchema(map['key']);

    var listItems = <Widget>[];

    if (fieldSchema.title != null) {
      if (map.containsKey('title')) {
        var titleMap = Map<String, dynamic>.from(map['title']);

        titleMap['data'] = fieldSchema.title;

        listItems.add(SchemaWidget.build(buildContext, titleMap));
      } else {
        listItems.add(Text(fieldSchema.title));
      }
    }

    if (fieldSchema.description != null) {
      if (map.containsKey('description')) {
        var descriptionMap = Map<String, dynamic>.from(map['description']);

        descriptionMap['data'] = fieldSchema.description;

        listItems.add(SchemaWidget.build(buildContext, descriptionMap));
      } else {
        listItems.add(Text(fieldSchema.description));
      }
    }

    listItems.add(Column(
      crossAxisAlignment: map.containsKey('crossAxisAlignment')
          ? parseCrossAxisAlignment(map['crossAxisAlignment'])
          : CrossAxisAlignment.center,
      mainAxisAlignment: map.containsKey('mainAxisAlignment')
          ? parseMainAxisAlignment(map['mainAxisAlignment'])
          : MainAxisAlignment.start,
      mainAxisSize: map.containsKey('mainAxisSize')
          ? parseMainAxisSize(map['mainAxisSize'])
          : MainAxisSize.max,
      textBaseline: map.containsKey('textBaseline')
          ? parseTextBaseline(map['textBaseline'])
          : null,
      textDirection: map.containsKey('textDirection')
          ? parseTextDirection(map['textDirection'])
          : null,
      verticalDirection: map.containsKey('verticalDirection')
          ? parseVerticalDirection(map['verticalDirection'])
          : VerticalDirection.down,
      children: parseItems(buildContext, map),
    ));

    return Column(children: listItems);
  }
}
