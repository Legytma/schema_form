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

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:json_schema/json_schema.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';
import 'package:schema_form/schema_form.dart';
import 'package:json_schema/src/json_schema/global_platform_functions.dart';

import 'package:schema_form/schema_property_value_selector.dart';

import 'json_schema_resolver.dart';
import 'resolver/base_cache_manager_json_schema_resolver.dart';

class MyAppFormBuilder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale("pt", "BR"),
      home: MyFormBuilderHomePage(title: 'Form Builder Demo'),
    );
  }
}

class MyFormBuilderHomePage extends StatelessWidget {
  static final Logger _log = Logger('MyHomePage');
  final String title;

  final GlobalKey<FormBuilderState> formBuilderKey =
      GlobalKey<FormBuilderState>();

  final formJsonSchema = JsonSchema.createSchema(
    {
      "\$schema": "http://json-schema.org/draft-06/schema#",
      "title": "Example of use",
      "description": "A simple example of JSON Schema Dynamic Layout Form",
      "type": "object",
      "required": ["higroup", "email", "password", "Checkbox", "radiobuton1"],
      "properties": {
        "higroup": {
          "type": "string",
          "title": "Hi Group",
          "default": "Hi Group flutter"
        },
        "password": {"type": "string", "title": "Password"},
        "email": {
          "type": "string",
          "title": "Email test",
          "default": "hola a todos",
          "format": "email"
        },
        "url": {
          "type": "string",
          "title": "URL",
          "default": "hola a todos",
          "format": "uri"
        },
        "tareatexttest": {
          "type": "string",
          "title": "TareaText test",
          "default": "hola a todos"
        },
        "radiobuton1": {
          "type": "integer",
          "title": "Radio Button test 1",
          "enum": [1, 2, 3],
        },
        "radiobuton2": {
          "type": "integer",
          "title": "Radio Button test 2",
          "enum": [1, 2, 3],
        },
        "switch": {"type": "boolean", "title": "Switch test", "const": true},
        "Checkbox": {
          "type": "boolean",
          "title": "Checkbox test",
        },
        "Checkbox1": {
          "type": "boolean",
          "title": "Checkbox test 2",
        },
        "dropdownstring": {
          "type": "string",
          "title": "DropdownString test",
          "enum": ["item1", "item2", "item3"],
        },
        "dropdownnumber": {
          "type": "number",
          "title": "DropdownNumber test",
          "enum": [1, 2, 3, 3.5],
        },
        "liststring": {
          "type": "string",
          "title": "List String",
          "default": "Item",
        },
        "listnumber": {
          "type": "number",
          "title": "List Number",
          "default": "0",
        },
        "date": {
          "type": "string",
          "title": "Date",
          "default": "1900-01-01",
          "tooltip": "Date",
          "format": "date-time"
        },
        "datetime": {
          "type": "string",
          "title": "Date Time",
          "default": "1900-01-01 00:00:00",
          "tooltip": "Date Time",
          "format": "date-time"
        },
        "time": {
          "type": "string",
          "title": "Time",
          "default": "00:00:00",
          "tooltip": "Time",
          "format": "date-time"
        }
      },
      "default": {"higroup": "Hi Group inicial"}
    },
  );

  MyFormBuilderHomePage({Key key, this.title}) : super(key: key) {
    // SchemaWidget.registerParsers();
    // configureJsonSchemaForBrowser();

    var jsonSchemaResolver = BaseCacheManagerJsonSchemaResolver(
      JsonSchemaResolverStatistics(),
      JsonSchemaDefaultCacheManager(),
    );

    globalCreateJsonSchemaFromUrl = jsonSchemaResolver.createSchemaFromUrl;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _savePressed),
          IconButton(icon: Icon(Icons.delete), onPressed: _resetPressed),
        ],
      ),
      body: FutureBuilder<JsonSchema>(
        future: JsonSchema.createSchemaFromUrl(
          "https://schema.legytma.com.br/2.0.0/schema/widget/material_app.schema.json",
        ),
        builder: (futureContext, snapshot) {
          if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return SchemaForm(
            formKey: formBuilderKey,
            jsonSchema: snapshot.data,
            autovalidate: false,
            initialValue: <String, dynamic>{},
            builder: (buildContext, fields) {
              var children = <Widget>[
                SchemaPropertyValueSelector<String>(
                  dataAddress: "title",
                  defaultValue: "",
                  builder: (selectorContext, value, child) {
                    return Text(
                      value,
                      style: Theme.of(selectorContext).textTheme.headline6,
                    );
                  },
                ),
                SchemaPropertyValueSelector<String>(
                  dataAddress: "description",
                  defaultValue: "",
                  builder: (selectorContext, value, child) {
                    return Text(
                      value,
                      style: Theme.of(selectorContext).textTheme.headline6,
                    );
                  },
                ),
              ];

              children.addAll(fields);

              children.add(
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    RaisedButton(
                      child: Text("Submit"),
                      onPressed: _savePressed,
                    ),
                    RaisedButton(
                      child: Text("Reset"),
                      onPressed: _resetPressed,
                    ),
                  ],
                ),
              );

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: children,
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _savePressed,
      ),
    );
  }

  void _savePressed() {
    final formBuilderState = formBuilderKey.currentState;

    if (formBuilderState.saveAndValidate()) {
      final formBuilderValue = formBuilderState.value;

      _log.info("formBuilderValue: $formBuilderValue");
    } else {
      _log.finest("Invalid state...");
    }
  }

  void _resetPressed() {
    formBuilderKey.currentState.reset();
  }
}
