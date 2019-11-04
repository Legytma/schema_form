import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';
import 'package:schema_form/common/control/SwitchFormField.dart';

class SchemaSwitchFormFieldParser extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "SchemaSwitchFormField" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    final JsonSchemaBloc jsonSchemaBloc =
        BlocProvider.of<JsonSchemaBloc>(buildContext);

//      print('jsonSchemaBloc: $jsonSchemaBloc');

    final JsonSchema fieldSchema = jsonSchemaBloc.getPropertySchema(map['key']);

    StreamBuilder streamBuilder = StreamBuilder(
      stream: jsonSchemaBloc.getFieldStream(map['key']),
      builder: (context, snapshot) {
        return SwitchFormField(
          autoValidate:
              map.containsKey('autovalidate') ? map['autovalidate'] : false,
          initialValue: snapshot?.data ?? fieldSchema.defaultValue ?? false,
          title: fieldSchema.requiredOnParent
              ? fieldSchema.title + ' *'
              : fieldSchema.title,
          validator: (bool value) {
            Validator validator = new Validator(fieldSchema);

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
