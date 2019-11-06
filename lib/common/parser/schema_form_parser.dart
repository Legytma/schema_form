import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';

class SchemaFormParser extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "SchemaForm" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    final jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(buildContext);

//      print('jsonSchemaBloc: $jsonSchemaBloc');

    BlocBuilder blocBuilder = BlocBuilder<JsonSchemaBloc, JsonSchemaState>(
      bloc: jsonSchemaBloc,
      condition: (previousState, state) {
//          print("state.dataSchema: ${state.dataSchema}");

        return previousState.dataSchema != state.dataSchema;
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

    return blocBuilder;
  }
}
