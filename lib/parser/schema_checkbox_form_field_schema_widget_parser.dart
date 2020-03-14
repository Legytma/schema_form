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
import '../widget/control/check_box_form_field_widget.dart';

/// [SchemaWidgetParser] to parse [CheckboxFormField].
class SchemaCheckboxFormFieldSchemaWidgetParser extends SchemaWidgetParser {
  @override
  String get parserName => "SchemaCheckboxFormField";

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

    final fieldSchema = jsonSchemaBloc.getPropertySchema(map['key']);

    var streamBuilder = StreamBuilder(
      stream: jsonSchemaBloc.getFieldStream(map['key']),
      builder: (context, snapshot) {
        return CheckBoxFormFieldWidget.createScope(
          autoValidate:
              map.containsKey('autovalidate') ? map['autovalidate'] : false,
          initialValue: snapshot?.data ?? fieldSchema.defaultValue ?? false,
          decoration: InputDecoration(
            labelText:
                fieldSchema.title + (fieldSchema.requiredOnParent ? ' *' : ''),
            helperText: fieldSchema.description,
            hintText:
                "${fieldSchema.examples.isEmpty ? "" : fieldSchema.examples?.first}",
          ),
          validator: (bool value) {
            var validator = Validator(fieldSchema);

            if (!validator.validate(value)) {
              return validator.errors.first;
            }

            return null;
          },
          onSaved: (bool value) {
            jsonSchemaBloc.add(
              ChangeValueJsonSchemaEvent(
                key: map['key'],
                value: value,
              ),
            );

            return;
          },
          onChanged: (value) {
            jsonSchemaBloc.add(
              ChangeValueJsonSchemaEvent(
                key: map['key'],
                value: value,
              ),
            );

            return;
          },
        );
      },
    );

    return streamBuilder;
  }
}
