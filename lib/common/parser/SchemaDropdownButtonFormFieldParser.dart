import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';

class SchemaDropdownButtonFormFieldParser extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "SchemaDropdownButtonFormField" == widgetName;
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
        switch (fieldSchema.type) {
          case SchemaType.number:
            return _makeDropdownButtonFormField<num>(
              map,
              buildContext,
              listener,
              snapshot,
              jsonSchemaBloc,
              fieldSchema,
              fieldSchema.defaultValue,
            );
            break;
          case SchemaType.boolean:
            return _makeDropdownButtonFormField<bool>(
              map,
              buildContext,
              listener,
              snapshot,
              jsonSchemaBloc,
              fieldSchema,
              fieldSchema.defaultValue,
            );
            break;
          case SchemaType.integer:
            return _makeDropdownButtonFormField<int>(
              map,
              buildContext,
              listener,
              snapshot,
              jsonSchemaBloc,
              fieldSchema,
              fieldSchema.defaultValue,
            );
            break;
          case SchemaType.string:
            return _makeDropdownButtonFormField<String>(
              map,
              buildContext,
              listener,
              snapshot,
              jsonSchemaBloc,
              fieldSchema,
              fieldSchema.defaultValue,
            );
            break;
          case SchemaType.object:
            return _makeDropdownButtonFormField<Object>(
              map,
              buildContext,
              listener,
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
      Map<String, dynamic> map,
      BuildContext buildContext,
      ClickListener listener,
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
        labelText: fieldSchema.requiredOnParent
            ? fieldSchema.title + ' *'
            : fieldSchema.title,
      ),
      items: _makeDropdownMenuItems<T>(
          map, buildContext, listener, snapshot, jsonSchemaBloc, fieldSchema),
      validator: (T value) {
        Validator validator = new Validator(fieldSchema);

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
      Map<String, dynamic> map,
      BuildContext buildContext,
      ClickListener listener,
      AsyncSnapshot snapshot,
      JsonSchemaBloc jsonSchemaBloc,
      JsonSchema fieldSchema) {
    List<DropdownMenuItem<T>> dropdownMenuItems = List<DropdownMenuItem<T>>();

    fieldSchema?.schemaMap['list']?.forEach((dynamic value) {
      Widget title;

      if (map.containsKey('titleItem')) {
        Map<String, dynamic> currentItem =
            Map<String, dynamic>.from(map['titleItem']);

        currentItem['data'] = value['title'];

        title = DynamicWidgetBuilder.buildFromMap(
          currentItem,
          buildContext,
          listener,
        );
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
