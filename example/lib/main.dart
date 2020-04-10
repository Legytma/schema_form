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

import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:logging/logging.dart';

import 'app_routed.dart';
import 'dynamic_schema_form_widget.dart';
import 'json_utils.dart';
import 'static_schema_form_widget.dart';

//const String APP_TO_RUN_ID = null;
//const String APP_TO_RUN_ID = "";
const String APP_TO_RUN_ID = "routed";
//const String APP_TO_RUN_ID = "testAppLayoutSchema.json";
//const String APP_TO_RUN_ID = "testUberWaitSchema.json";
//const String APP_TO_RUN_ID = "testUberHomeSchema.json";

void main() {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) => developer.log(rec.message,
      error: rec.error,
      level: rec.level.value,
      name: rec.loggerName,
      sequenceNumber: rec.sequenceNumber,
      stackTrace: rec.stackTrace,
      time: rec.time,
      zone: rec.zone));

  initializeDateFormatting("pt_BR", null).then((_) {
    runApp(AppRouted());
//    if (APP_TO_RUN_ID == "") {
//      runApp(MyAppStatic());
//    } else if (APP_TO_RUN_ID == null) {
//      runApp(MyApp());
//    } else if (APP_TO_RUN_ID == "routed") {
//      runApp(MyAppRouted());
//    } else {
//      runApp(MyDynamicApp(APP_TO_RUN_ID));
//    }
  });
}

Widget getDefaultHeader(BuildContext context) {
  final Map<String, dynamic> params = ModalRoute.of(context).settings.arguments;

  return DrawerHeader(
    child: Text(params['title']),
    decoration: BoxDecoration(
      color: Colors.blue,
    ),
  );
}

List<Widget> getItens(BuildContext context) {
//    final Map<String, dynamic> params =
//        ModalRoute.of(context).settings.arguments;

  return <Widget>[
    ListTile(
      title: Text(StaticSchemaFormWidget.title),
      onTap: () => Navigator.of(context).popAndPushNamed(
        "static",
        arguments: {
          "title": StaticSchemaFormWidget.title,
        },
      ),
    ),
    _getDynamicItens(
      context,
      FileLocate.asset,
      "${DynamicSchemaFormWidget.title}: App Layout",
      "testAppLayoutSchema.json",
    ),
    _getDynamicItens(
      context,
      FileLocate.asset,
      "${DynamicSchemaFormWidget.title}: Uber Home",
      "testUberHomeSchema.json",
    ),
    _getDynamicItens(
      context,
      FileLocate.asset,
      "${DynamicSchemaFormWidget.title}: Uber Wait",
      "testUberWaitSchema.json",
    ),
  ];
}

Widget _getDynamicItens(BuildContext context, FileLocate fileLocate,
    String title, String filePath) {
  return ListTile(
    title: Text(title),
    onTap: () => Navigator.of(context).popAndPushNamed(
      "dynamic",
      arguments: {
        "title": title,
        "fileLocate": fileLocate,
        "filePath": filePath,
      },
    ),
  );
}

Widget getDefaultAppBar(BuildContext context) {
  final Map<String, dynamic> params = ModalRoute.of(context).settings.arguments;

  return AppBar(
    title: Text(params['title']),
  );
}
