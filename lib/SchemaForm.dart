import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc_extensions/flutter_bloc_extensions.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';
import 'package:schema_form/common/parser/DividerParser.dart';
import 'package:schema_form/common/parser/SchemaCheckboxFormFieldParser.dart';
import 'package:schema_form/common/parser/SchemaColumnRadioListTileFormFieldParser.dart';
import 'package:schema_form/common/parser/SchemaDropdownButtonFormFieldParser.dart';
import 'package:schema_form/common/parser/SchemaFormParser.dart';
import 'package:schema_form/common/parser/SchemaRowRadioListTileFormFieldParser.dart';
import 'package:schema_form/common/parser/SchemaSwitchFormFieldParser.dart';
import 'package:schema_form/common/parser/SchemaTextFormFieldParser.dart';
import 'package:schema_form/common/parser/SchemaTextParser.dart';

class SchemaForm extends StatelessWidget {
  static bool _initialized = false;

  final JsonSchemaBloc jsonSchemaBloc;

  SchemaForm({Key key, this.jsonSchemaBloc}) : super(key: key) {
    if (!_initialized) {
      DynamicWidgetBuilder.addParser(DividerParser());
      DynamicWidgetBuilder.addParser(SchemaFormParser());
      DynamicWidgetBuilder.addParser(SchemaTextFormFieldParser());
      DynamicWidgetBuilder.addParser(SchemaTextParser());
      DynamicWidgetBuilder.addParser(SchemaCheckboxFormFieldParser());
      DynamicWidgetBuilder.addParser(
          SchemaColumnRadioListTileFormFieldParser());
      DynamicWidgetBuilder.addParser(SchemaRowRadioListTileFormFieldParser());
      DynamicWidgetBuilder.addParser(SchemaSwitchFormFieldParser());
      DynamicWidgetBuilder.addParser(SchemaDropdownButtonFormFieldParser());

      _initialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DisposableBlocProvider<JsonSchemaBloc>(
      blocFactory: () => jsonSchemaBloc,
      child: BlocProjectionBuilder<JsonSchemaEvent, JsonSchemaState,
          Map<String, dynamic>>(
        bloc: jsonSchemaBloc,
        converter: (state) {
//              print("state.layout: ${state.layout}");

          return state.layout;
        },
        builder: (context, layout) {
//              print("layout: $layout");

          if (layout == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: DynamicWidgetBuilder.buildFromMap(
                layout,
                context,
                jsonSchemaBloc,
              ),
            );
          }
        },
      ),
    );
  }
}
