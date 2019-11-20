// Copyright (c) 2019 Legytma Soluções Inteligentes (https://legytma.com.br).
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

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
    var divider = Divider(
      color: map.containsKey('color') ? parseHexColor(map['color']) : null,
      endIndent: map.containsKey('endIndent') ? map['endIndent'] : 0.0,
      height: map.containsKey('height') ? map['height'] : 16.0,
      indent: map.containsKey('indent') ? map['indent'] : 0.0,
    );

    return divider;
  }
}
