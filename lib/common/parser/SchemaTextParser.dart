import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';

class SchemaTextParser implements WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "SchemaText" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    // ignore: close_sinks
    final JsonSchemaBloc jsonSchemaBloc =
        BlocProvider.of<JsonSchemaBloc>(buildContext);

    List<String> addressList = map['propertyAddress'].toString().split(".");
    Map<String, dynamic> schemaMap = jsonSchemaBloc.state.dataSchema?.schemaMap;
    dynamic value =
        schemaMap == null ? '' : _getSchemaValue(schemaMap, addressList, 0);
    print("propertyAddress: ${map['propertyAddress']}");
    print("addressList: $addressList");
    print("schemaMap: $schemaMap");
    print("value: $value");

    String data = map.containsKey('propertyAddress') ? value : '';
    String textAlignString = map['textAlign'];
    String overflow = map['overflow'];
    int maxLines = map['maxLines'] == null ? 1 : map['maxLines'];
    String semanticsLabel = map['semanticsLabel'];
    bool softWrap = map['softWrap'];
    String textDirectionString = map['textDirection'];
    double textScaleFactor = map['textScaleFactor'];

    return Text(
      data,
      textAlign: parseTextAlign(textAlignString),
      overflow: parseTextOverflow(overflow),
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      softWrap: softWrap,
      textDirection: parseTextDirection(textDirectionString),
      style: map.containsKey('style') ? parseTextStyle(map['style']) : null,
      textScaleFactor: textScaleFactor,
    );
  }

  dynamic _getSchemaValue(
      Map<String, dynamic> schemaMap, List<String> addressList, int index) {
    if (index < addressList.length - 1) {
      return _getSchemaValue(
          schemaMap[addressList[index]], addressList, index + 1);
    }

    return schemaMap[addressList[index]];
  }
}
