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

import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';
import 'package:schema_form/common/control/radio_list_form_field.dart';

/// Abstract class that extends [WidgetParser] to parse from a list of
/// [RadioListFormField].
abstract class SchemaRadioListTileFormFieldParser extends WidgetParser {
  /// Parse a list of [RadioListFormField] using [map], [buildContext] and
  /// [listener].
  List<Widget> parseItems(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    final jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(buildContext);

//      print('jsonSchemaBloc: $jsonSchemaBloc');

    final fieldSchema = jsonSchemaBloc.getPropertySchema(map['key']);
    var itemsList = <Widget>[];

    for (var i = 0; i < fieldSchema.enumValues.length; i++) {
//    fieldSchema.schemaMap['list'].forEach((dynamic value) {
      Widget item;

      var value = fieldSchema.enumValues[i];
      String titleEnum = fieldSchema != null &&
              fieldSchema.schemaMap.containsKey('titleEnum') &&
              fieldSchema.schemaMap['titleEnum'].length > i
          ? fieldSchema.schemaMap['titleEnum'][i]
          : "$value";

      switch (fieldSchema.type) {
        case SchemaType.number:
          item = _makeRadioListTile<num>(
            map,
            buildContext,
            listener,
            jsonSchemaBloc,
            fieldSchema,
            titleEnum,
            value,
            0,
          );
          break;
        case SchemaType.boolean:
          item = _makeRadioListTile<bool>(
            map,
            buildContext,
            listener,
            jsonSchemaBloc,
            fieldSchema,
            titleEnum,
            value,
            false,
          );
          break;
        case SchemaType.integer:
          item = _makeRadioListTile<int>(
            map,
            buildContext,
            listener,
            jsonSchemaBloc,
            fieldSchema,
            titleEnum,
            value,
            0,
          );
          break;
        case SchemaType.string:
          item = _makeRadioListTile<String>(
            map,
            buildContext,
            listener,
            jsonSchemaBloc,
            fieldSchema,
            titleEnum,
            value,
            '',
          );
          break;
        case SchemaType.object:
          item = _makeRadioListTile<Object>(
            map,
            buildContext,
            listener,
            jsonSchemaBloc,
            fieldSchema,
            titleEnum,
            value,
            null,
          );
          break;
        default:
          throw Exception("Type ${fieldSchema.type} not implemented");
      }

      itemsList.add(item);
//    });
    }

    return itemsList;
  }

  Widget _makeRadioListTile<T>(
      Map<String, dynamic> map,
      BuildContext buildContext,
      ClickListener listener,
      JsonSchemaBloc jsonSchemaBloc,
      JsonSchema fieldSchema,
      String title,
      T value,
      T defaultValue) {
    var streamBuilder = StreamBuilder(
      stream: jsonSchemaBloc.getFieldStream(map['key']),
      builder: (context, snapshot) {
        return RadioListFormField<T>(
          autoValidate:
              map.containsKey('autovalidate') ? map['autovalidate'] : false,
          radioValue: value,
          initialValue:
              snapshot?.data ?? fieldSchema.defaultValue ?? defaultValue,
          title: title,
          validator: (T value) {
            var validator = Validator(fieldSchema);

            if (!validator.validate(snapshot?.data ?? value)) {
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
          onChange: (value) {
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
