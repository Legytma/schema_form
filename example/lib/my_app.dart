// Copyright (c) 2020 Legytma Soluções Inteligentes (https://legytma.com.br).
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

import 'package:flutter/material.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';
import 'package:schema_form/schema_form.dart';

import 'json_utils.dart';

/// Static main [StatelessWidget]
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Flutter JsonSchema Demo';
    final jsonSchemaBloc = JsonSchemaBloc(formContext: context);

    loadSchemasFrom(
      context,
      FileLocate.asset,
      jsonSchemaBloc,
    );

    return MaterialApp(
      locale: Locale("pt", "BR"),
      title: appTitle,
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        drawer: Drawer(
          child: ListView(
            // Important: Remove any padding from the ListView.
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Text(appTitle),
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
              ),
              ListTile(
                title: Text('Load from Asset'),
                onTap: () => loadSchemasFrom(
                  context,
                  FileLocate.asset,
                  jsonSchemaBloc,
                ),
              ),
              ListTile(
                title: Text('Load from Storage'),
                onTap: () => loadSchemasFrom(
                  context,
                  FileLocate.storage,
                  jsonSchemaBloc,
                ),
              ),
              ListTile(
                title: Text('Load from URL'),
                onTap: () => loadSchemasFrom(
                  context,
                  FileLocate.url,
                  jsonSchemaBloc,
                ),
              ),
            ],
          ),
        ),
        body: SchemaForm(jsonSchemaBloc: jsonSchemaBloc),
      ),
    );
  }
}
