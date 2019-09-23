import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:dynamic_widget/dynamic_widget/utils.dart';
import 'package:flutter/material.dart';

class DividerParser extends WidgetParser {
  @override
  bool forWidget(String widgetName) {
    return "Divider" == widgetName;
  }

  @override
  Widget parse(Map<String, dynamic> map, BuildContext buildContext,
      ClickListener listener) {
    Divider divider = Divider(
      color: map.containsKey('color') ? parseHexColor(map['color']) : null,
      endIndent: map.containsKey('endIndent') ? map['endIndent'] : 0.0,
      height: map.containsKey('height') ? map['height'] : 16.0,
      indent: map.containsKey('indent') ? map['indent'] : 0.0,
    );

    return divider;
  }
}
