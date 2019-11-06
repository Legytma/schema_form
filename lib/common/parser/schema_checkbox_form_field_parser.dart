import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';
import 'package:schema_form/common/control/checkbox_form_field.dart';

class SchemaCheckboxFormFieldParser extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "SchemaCheckboxFormField" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    // ignore: close_sinks
    final jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(buildContext);

//      print('jsonSchemaBloc: $jsonSchemaBloc');

    final fieldSchema = jsonSchemaBloc.getPropertySchema(map['key']);

    var streamBuilder = StreamBuilder(
      stream: jsonSchemaBloc.getFieldStream(map['key']),
      builder: (context, snapshot) {
        return CheckboxFormField(
          autoValidate:
              map.containsKey('autovalidate') ? map['autovalidate'] : false,
          initialValue: snapshot?.data ?? fieldSchema.defaultValue ?? false,
          title: fieldSchema.title + (fieldSchema.requiredOnParent ? ' *' : ''),
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
