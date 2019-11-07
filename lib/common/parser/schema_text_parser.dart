/******************************************************************************
 * Copyright (c) 2019 Legytma Soluções Inteligentes (https://legytma.com.br). *
 *                                                                            *
 *  Licensed under the Apache License, Version 2.0 (the "License");           *
 *  you may not use this file except in compliance with the License.          *
 *  You may obtain a copy of the License at                                   *
 *                                                                            *
 *       http://www.apache.org/licenses/LICENSE-2.0                           *
 *                                                                            *
 * Unless required by applicable law or agreed to in writing, software        *
 * distributed under the License is distributed on an "AS IS" BASIS,          *
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   *
 * See the License for the specific language governing permissions and        *
 * limitations under the License.                                             *
 ******************************************************************************/

import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';

class SchemaTextParser implements WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "SchemaText" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    final jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(buildContext);

    var addressList = map['propertyAddress'].toString().split(".");
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

  dynamic _getSchemaValue(Map<String, dynamic> schemaMap, List<String> addressList, int index) {
    if (index < addressList.length - 1) {
      return _getSchemaValue(
          schemaMap[addressList[index]], addressList, index + 1);
    }

    return schemaMap[addressList[index]];
  }
}
