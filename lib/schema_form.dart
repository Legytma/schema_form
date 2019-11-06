import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';
import 'package:schema_form/common/parser/divider_parser.dart';
import 'package:schema_form/common/parser/schema_checkbox_form_field_parser.dart';
import 'package:schema_form/common/parser/schema_column_radio_list_tile_form_field_parser.dart';
import 'package:schema_form/common/parser/schema_dropdown_button_form_field_parser.dart';
import 'package:schema_form/common/parser/schema_form_parser.dart';
import 'package:schema_form/common/parser/schema_row_radio_list_tile_form_field_parser.dart';
import 'package:schema_form/common/parser/schema_switch_form_field_parser.dart';
import 'package:schema_form/common/parser/schema_text_form_field_parser.dart';
import 'package:schema_form/common/parser/schema_text_parser.dart';

export 'package:schema_form/bloc/json_schema_bl.dart';

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
    return BlocProvider<JsonSchemaBloc>(
      builder: (BuildContext buildContext) => jsonSchemaBloc,
      child: BlocBuilder<JsonSchemaBloc, JsonSchemaState>(
        bloc: jsonSchemaBloc,
        condition: (previousState, state) {
//              print("state.layout: ${state.layout}");

          return previousState.layout != state.layout;
        },
        builder: (context, state) {
//              print("layout: $layout");

          if (state.layout == null) {
            return Container(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else {
            return SingleChildScrollView(
              child: DynamicWidgetBuilder.buildFromMap(
                state.layout,
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
