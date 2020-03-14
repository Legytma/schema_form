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
import 'package:json_schema/json_schema.dart';
import 'package:schema_widget/schema_widget.dart';

import '../bloc/json_schema_bl.dart';

/// [SchemaWidgetParser] to parse [DropdownButtonFormField].
class SchemaDropdownButtonFormFieldSchemaWidgetParser
    extends SchemaWidgetParser {
  @override
  String get parserName => "SchemaDropdownButtonFormField";

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
    final jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(buildContext);

//      print('jsonSchemaBloc: $jsonSchemaBloc');

    final fieldSchema = jsonSchemaBloc.getPropertySchema(map['key']);

    var streamBuilder = StreamBuilder(
      stream: jsonSchemaBloc.getFieldStream(map['key']),
      builder: (context, snapshot) {
        switch (fieldSchema.type) {
          case SchemaType.number:
            return _makeDropdownButtonFormField<num>(
              buildContext,
              map,
              snapshot,
              jsonSchemaBloc,
              fieldSchema,
              fieldSchema.defaultValue,
            );
            break;
          case SchemaType.boolean:
            return _makeDropdownButtonFormField<bool>(
              buildContext,
              map,
              snapshot,
              jsonSchemaBloc,
              fieldSchema,
              fieldSchema.defaultValue,
            );
            break;
          case SchemaType.integer:
            return _makeDropdownButtonFormField<int>(
              buildContext,
              map,
              snapshot,
              jsonSchemaBloc,
              fieldSchema,
              fieldSchema.defaultValue,
            );
            break;
          case SchemaType.string:
            return _makeDropdownButtonFormField<String>(
              buildContext,
              map,
              snapshot,
              jsonSchemaBloc,
              fieldSchema,
              fieldSchema.defaultValue,
            );
            break;
          case SchemaType.object:
            return _makeDropdownButtonFormField<Object>(
              buildContext,
              map,
              snapshot,
              jsonSchemaBloc,
              fieldSchema,
              fieldSchema.defaultValue,
            );
            break;
          default:
            throw Exception("Type ${fieldSchema.type} not implemented");
        }
      },
    );

    return streamBuilder;
  }

  DropdownButtonFormField _makeDropdownButtonFormField<T>(
      BuildContext buildContext,
      Map<String, dynamic> map,
      AsyncSnapshot snapshot,
      JsonSchemaBloc jsonSchemaBloc,
      JsonSchema fieldSchema,
      T defaultValue) {
    return DropdownButtonFormField<T>(
//          autoValidate:
//              map.containsKey('autovalidate') ? map['autovalidate'] : false,
      value: snapshot?.data ?? fieldSchema.defaultValue ?? defaultValue,
//          title: fieldSchema.requiredOnParent
//              ? fieldSchema.title + ' *'
//              : fieldSchema.title,
      decoration: InputDecoration(
        hintText:
            fieldSchema.defaultValue != null ? fieldSchema.defaultValue : '',
        labelText:
            fieldSchema.title + (fieldSchema.requiredOnParent ? ' *' : ''),
      ),
      items: _makeDropdownMenuItems<T>(
        buildContext,
        map,
        snapshot,
        jsonSchemaBloc,
        fieldSchema,
      ),
      validator: (T value) {
        var validator = Validator(fieldSchema);

        if (!validator.validate(value)) {
          return validator.errors.first;
        }

        return null;
      },
      onSaved: (T value) {
        jsonSchemaBloc.add(
          ChangeValueJsonSchemaEvent(
            key: map['key'],
            value: value,
          ),
        );

        return;
      },
      onChanged: (T value) {
        jsonSchemaBloc.add(
          ChangeValueJsonSchemaEvent(
            key: map['key'],
            value: value,
          ),
        );

        return;
      },
    );
  }

  List<DropdownMenuItem<T>> _makeDropdownMenuItems<T>(
      BuildContext buildContext,
      Map<String, dynamic> map,
      AsyncSnapshot snapshot,
      JsonSchemaBloc jsonSchemaBloc,
      JsonSchema fieldSchema) {
    var dropdownMenuItems = <DropdownMenuItem<T>>[];

    fieldSchema?.schemaMap['list']?.forEach((dynamic value) {
      Widget title;

      if (map.containsKey('titleItem')) {
        var currentItem = Map<String, dynamic>.from(map['titleItem']);

        currentItem['data'] = value['title'];

        title = SchemaWidget.build(buildContext, currentItem);
      } else {
        title = Text(value['title']);
      }

      dropdownMenuItems.add(
        DropdownMenuItem<T>(child: title, value: value['value']),
      );
    });

    return dropdownMenuItems;
  }
}
