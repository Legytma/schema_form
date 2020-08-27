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
import 'package:flutter/services.dart';
import 'package:generate_form/form_builder_example.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:json_schema/json_schema.dart';
import 'package:logging/logging.dart';
import 'package:schema_form/enum/picker_type.dart';
import 'package:schema_form/schema_form.dart';
import 'package:schema_form/widget/control/schema/template/switch_schema_form_field_template.dart';
import 'package:schema_form/widget/control/schema/template/text_schema_form_field_template.dart';

const formType = "FormBuilder";

Future<void> main() async {
  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((rec) => developer.log(rec.message,
      error: rec.error,
      level: rec.level.value,
      name: rec.loggerName,
      sequenceNumber: rec.sequenceNumber,
      stackTrace: rec.stackTrace,
      time: rec.time,
      zone: rec.zone));

  if (formType == "FormBuilder") {
    runApp(MyAppFormBuilder());
  } else {
    await initializeDateFormatting("pt_BR", null);

    runApp(MyApp());
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale("pt", "BR"),
      home: MyHomePage(title: 'Schema Form Demo'),
    );
  }
}

class MyHomePage extends StatelessWidget {
  static final Logger _log = Logger('MyHomePage');

  final GlobalKey<SchemaFormWidgetState> _schemaFormKey =
      GlobalKey<SchemaFormWidgetState>();

  final String title;

  JsonSchema formJsonSchema;

//  final formJsonSchema = JsonSchema.createSchema(
//    {
//      "\$schema": "http://json-schema.org/draft-06/schema#",
//      "title": "Example of use",
//      "description": "A simple example of JSON Schema Dynamic Layout Form",
//      "type": "object",
//      "required": ["higroup", "email", "password", "Checkbox", "radiobuton1"],
//      "properties": {
//        "higroup": {
//          "type": "string",
//          "title": "Hi Group",
//          "default": "Hi Group flutter"
//        },
//        "password": {"type": "string", "title": "Password"},
//        "email": {
//          "type": "string",
//          "title": "Email test",
//          "default": "hola a todos",
//          "format": "email"
//        },
//        "url": {
//          "type": "string",
//          "title": "URL",
//          "default": "hola a todos",
//          "format": "uri"
//        },
//        "tareatexttest": {
//          "type": "string",
//          "title": "TareaText test",
//          "default": "hola a todos"
//        },
//        "radiobuton1": {
//          "type": "integer",
//          "title": "Radio Button test 1",
//          "enum": [1, 2, 3],
//        },
//        "radiobuton2": {
//          "type": "integer",
//          "title": "Radio Button test 2",
//          "enum": [1, 2, 3],
//        },
//        "switch": {"type": "boolean", "title": "Switch test", "const": true},
//        "Checkbox": {
//          "type": "boolean",
//          "title": "Checkbox test",
//        },
//        "Checkbox1": {
//          "type": "boolean",
//          "title": "Checkbox test 2",
//        },
//        "dropdownstring": {
//          "type": "string",
//          "title": "DropdownString test",
//          "enum": ["item1", "item2", "item3"],
//        },
//        "dropdownnumber": {
//          "type": "number",
//          "title": "DropdownNumber test",
//          "enum": [1, 2, 3, 3.5],
//        },
//        "liststring": {
//          "type": "string",
//          "title": "List String",
//          "default": "Item",
//        },
//        "listnumber": {
//          "type": "number",
//          "title": "List Number",
//          "default": "0",
//        },
//        "date": {
//          "type": "string",
//          "title": "Date",
//          "default": "1900-01-01",
//          "tooltip": "Date",
//          "format": "date-time"
//        },
//        "datetime": {
//          "type": "string",
//          "title": "Date Time",
//          "default": "1900-01-01 00:00:00",
//          "tooltip": "Date Time",
//          "format": "date-time"
//        },
//        "time": {
//          "type": "string",
//          "title": "Time",
//          "default": "00:00:00",
//          "tooltip": "Time",
//          "format": "date-time"
//        }
//      }
//    },
//  );

  MyHomePage({Key key, this.title}) : super(key: key) {
    JsonSchema.createSchemaFromUrl(
      "https://schema.legytma.com.br/2.0.0/schema/widget/app_bar.schema.json",
    ).then((value) {
      formJsonSchema = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _savePressed),
        ],
      ),
      body: SchemaFormWidget(
        key: _schemaFormKey,
        jsonSchema: formJsonSchema,
        autovalidate: true,
        onSave: (value) {
          _log.info("onSave: $value");
        },
        typeTemplateMap: {
          SchemaType.integer: TextSchemaFormFieldTemplate(
            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
          ),
        },
        controlTemplateMap: {
          "switch": SwitchSchemaFormFieldTemplate(),
          "testSwitch": SwitchSchemaFormFieldTemplate(),
          "password": TextSchemaFormFieldTemplate(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          "date": TextSchemaFormFieldTemplate(
            pickerType: PickerType.datePicker,
            dateFormat: "dd/MM/y",
          ),
          "datetime": TextSchemaFormFieldTemplate(
            pickerType: PickerType.dateTimePicker,
            dateFormat: "dd/MM/y hh:mm:ss",
          ),
          "time": TextSchemaFormFieldTemplate(
            pickerType: PickerType.timePicker,
            dateFormat: "hh:mm:ss",
          ),
        },
//          child: ListView(
//            children: <Widget>[
//              TitleTextSchemaFormWidget(),
//              SubTitleTextSchemaFormWidget(),
//              TextSchemaFormFieldWidget(fieldName: "higroup"),
//              TextSchemaFormFieldWidget(fieldName: "password"),
//              TextSchemaFormFieldWidget(fieldName: "email"),
//              TextSchemaFormFieldWidget(fieldName: "url"),
//              TextSchemaFormFieldWidget(fieldName: "tareatexttest"),
//              SwitchSchemaFormFieldWidget(fieldName: "switch"),
//              CheckboxSchemaFormFieldWidget(fieldName: "Checkbox"),
//              CheckboxSchemaFormFieldWidget(fieldName: "Checkbox1"),
//              TextSchemaFormFieldWidget(fieldName: "date"),
//              TextSchemaFormFieldWidget(fieldName: "datetime"),
//              TextSchemaFormFieldWidget(fieldName: "time"),
//              RaisedButton(onPressed: savePressed, child: Text("Save")),
//            ],
//          ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.save),
        onPressed: _savePressed,
      ),
    );
  }

  void _savePressed() {
    final schemaFormState = _schemaFormKey.currentState;

    final schemaFormSaved = schemaFormState.save();

    _log.info("schemaFormSaved: $schemaFormSaved");
  }
}
