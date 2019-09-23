import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_extensions/flutter_bloc_extensions.dart';
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';

class SchemaFormParser extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "SchemaForm" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    final JsonSchemaBloc jsonSchemaBloc =
        BlocProvider.of<JsonSchemaBloc>(buildContext);

//      print('jsonSchemaBloc: $jsonSchemaBloc');

    BlocProjectionBuilder blocProjectionBuilder =
        BlocProjectionBuilder<JsonSchemaEvent, JsonSchemaState, JsonSchema>(
      bloc: jsonSchemaBloc,
      converter: (state) {
//          print("state.dataSchema: ${state.dataSchema}");

        return state.dataSchema;
      },
      builder: (context, dataSchema) {
//          print("dataSchema: $dataSchema");

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
                ? DynamicWidgetBuilder.buildFromMap(
                    map['child'],
                    buildContext,
                    listener,
                  )
                : Container(),
//            Container(
//              padding: EdgeInsets.all(10.0),
//              child: Column(
//                mainAxisAlignment: MainAxisAlignment.start,
//                crossAxisAlignment: CrossAxisAlignment.start,
//                children: jsonSchema.properties.entries.map<Widget>((item) {
//                  return getWidget(context, item);
//                }).toList(),
//              ),
//            ),
          );
        }
      },
    );

    return blocProjectionBuilder;
  }
}
