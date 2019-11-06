import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';
import 'package:schema_form/common/parser/abstract_schema_radio_list_tile_form_field_parser.dart';

class SchemaRowRadioListTileFormFieldParser
    extends SchemaRadioListTileFormFieldParser {
  @override
  bool forWidget(String widgetName) {
    return "SchemaRowRadioListTileFormField" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    final jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(buildContext);

//      print('jsonSchemaBloc: $jsonSchemaBloc');
    var fieldSchema = jsonSchemaBloc.getPropertySchema(map['key']);

    var listItems = <Widget>[];

    if (fieldSchema.title != null) {
      if (map.containsKey('title')) {
        var titleMap = Map<String, dynamic>.from(map['title']);

        titleMap['data'] = fieldSchema.title;

        listItems.add(
          DynamicWidgetBuilder.buildFromMap(
            titleMap,
            buildContext,
            listener,
          ),
        );
      } else {
        listItems.add(Text(fieldSchema.title));
      }
    }

    if (fieldSchema.description != null) {
      if (map.containsKey('description')) {
        var descriptionMap = Map<String, dynamic>.from(map['description']);

        descriptionMap['data'] = fieldSchema.description;

        listItems.add(
          DynamicWidgetBuilder.buildFromMap(
            descriptionMap,
            buildContext,
            listener,
          ),
        );
      } else {
        listItems.add(Text(fieldSchema.description));
      }
    }

    listItems.add(Row(
      crossAxisAlignment: map.containsKey('crossAxisAlignment')
          ? parseCrossAxisAlignment(map['crossAxisAlignment'])
          : CrossAxisAlignment.center,
      mainAxisAlignment: map.containsKey('mainAxisAlignment')
          ? parseMainAxisAlignment(map['mainAxisAlignment'])
          : MainAxisAlignment.start,
      mainAxisSize: map.containsKey('mainAxisSize')
          ? parseMainAxisSize(map['mainAxisSize'])
          : MainAxisSize.max,
      textBaseline: map.containsKey('textBaseline')
          ? parseTextBaseline(map['textBaseline'])
          : null,
      textDirection: map.containsKey('textDirection')
          ? parseTextDirection(map['textDirection'])
          : null,
      verticalDirection: map.containsKey('verticalDirection')
          ? parseVerticalDirection(map['verticalDirection'])
          : VerticalDirection.down,
      children: parseItems(map, buildContext, listener),
    ));

    return Column(children: listItems);
  }
}
