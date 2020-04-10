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
import 'package:json_schema/json_schema.dart';
import 'package:logging/logging.dart';
import 'package:schema_form/enum/PickerType.dart';
import 'package:schema_form/widget/control/schema/schema_form_widget.dart';
import 'package:schema_form/widget/control/schema/state/schema_form_widget_state.dart';
import 'package:schema_form/widget/control/schema/template/switch_schema_form_field_template.dart';
import 'package:schema_form/widget/control/schema/template/text_schema_form_field_template.dart';

import 'main.dart';

class StaticSchemaFormWidget extends StatelessWidget {
  static final Logger _log = Logger('StaticSchemaFormWidget');
  static final String title = 'Static Schema Form Widget';

  final GlobalKey<SchemaFormWidgetState> _schemaFormKey =
      GlobalKey<SchemaFormWidgetState>();

  var formJsonSchema = JsonSchema.createSchema(
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
      }
    },
  );

  @override
  Widget build(BuildContext context) {
    var drawerItens = <Widget>[getDefaultHeader(context)];

    drawerItens.addAll(getItens(context));

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.save), onPressed: _savePressed),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: drawerItens,
        ),
      ),
      body: SchemaFormWidget(
        key: _schemaFormKey,
        jsonSchema: formJsonSchema,
        autovalidate: true,
        onSave: (value) {
          _log.info("onSave: $value");
        },
//        typeTemplateMap: {
//          SchemaType.integer: TextSchemaFormFieldTemplate(
//            inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
//          ),
//        },
        controlTemplateMap: {
          "switch": SwitchSchemaFormFieldTemplate(),
          "testSwitch": SwitchSchemaFormFieldTemplate(),
          "password": TextSchemaFormFieldTemplate(
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
          ),
          "date": TextSchemaFormFieldTemplate(
            pickerType: PickerType.DatePicker,
            dateFormat: "dd/MM/y",
          ),
          "datetime": TextSchemaFormFieldTemplate(
            pickerType: PickerType.DateTimePicker,
            dateFormat: "dd/MM/y hh:mm:ss",
          ),
          "time": TextSchemaFormFieldTemplate(
            pickerType: PickerType.TimePicker,
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
    var schemaFormState = _schemaFormKey.currentState;

    //                  _log.finest("schemaFormState: $schemaFormState");

    var schemaFormSaved = schemaFormState.save();

    _log.info("schemaFormSaved: $schemaFormSaved");
  }
}
