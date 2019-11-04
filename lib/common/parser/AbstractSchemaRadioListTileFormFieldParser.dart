import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';
import 'package:schema_form/common/control/RadioListFormField.dart';

abstract class SchemaRadioListTileFormFieldParser extends WidgetParser {
  List<Widget> parseItems(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    final JsonSchemaBloc jsonSchemaBloc =
        BlocProvider.of<JsonSchemaBloc>(buildContext);

//      print('jsonSchemaBloc: $jsonSchemaBloc');

    final JsonSchema fieldSchema = jsonSchemaBloc.getPropertySchema(map['key']);
    List<Widget> itemsList = List<Widget>();

    for (int i = 0; i < fieldSchema.enumValues.length; i++) {
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
    StreamBuilder streamBuilder = StreamBuilder(
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
            Validator validator = new Validator(fieldSchema);

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
