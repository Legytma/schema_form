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
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';
import 'package:schema_form/common/control/checkbox_form_field.dart';

class JsonSchemaForm extends StatelessWidget {
  final Key formKey;

  JsonSchemaForm({this.formKey});

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(context);

    return BlocBuilder<JsonSchemaBloc, JsonSchemaState>(
      bloc: jsonSchemaBloc,
      condition: (previousState, state) {
//        print("state.jsonSchema: ${state.jsonSchema}");

        return previousState.dataSchema != state.dataSchema;
      },
      builder: (context, event) {
//        print("jsonSchema: $jsonSchema");

        if (event.dataSchema == null) {
          return Container(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else {
          return Form(
            key: formKey,
            child: Container(
              padding: EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                    event.dataSchema.properties.entries.map<Widget>((item) {
                  return getWidget(context, item);
                }).toList(),
              ),
            ),
          );
        }
      },
    );
  }

  Widget getWidget(
      BuildContext context, MapEntry<String, JsonSchema> mapEntry) {
    print(
        "key: ${mapEntry.key}, title: ${mapEntry.value.title}, type: ${mapEntry.value.type}");

    switch (mapEntry.value.type) {
      case SchemaType.string:
        print("Loaded!");

        return getTextField(mapEntry, context);
      case SchemaType.boolean:
        print("Loaded!");

        return getCheckBox(mapEntry, context);
      default:
        print("Não implementado ainda...");

        return Container();
    }
  }

  Widget getTextField(
      MapEntry<String, JsonSchema> mapEntry, BuildContext context) {
    // ignore: close_sinks
    final jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(context);

    return Container(
      child: TextFormField(
        onSaved: (value) {
          jsonSchemaBloc.add(
            ChangeValueJsonSchemaEvent(
              key: mapEntry.key,
              value: value,
            ),
          );
        },
        validator: (String value) {
          var validator = Validator(mapEntry.value);

          if (!validator.validate(value)) {
            return validator.errors.first;
          }

          return null;
        },
        decoration: InputDecoration(
          hintText: mapEntry.value.defaultValue != null
              ? mapEntry.value.defaultValue
              : '',
          labelText: mapEntry.value.title +
              (mapEntry.value.requiredOnParent ? ' *' : ''),
        ),
      ),
    );
  }

  Widget getCheckBox(
      MapEntry<String, JsonSchema> mapEntry, BuildContext context) {
    // ignore: close_sinks
    final jsonSchemaBloc = BlocProvider.of<JsonSchemaBloc>(context);

    return StreamBuilder(
      stream: jsonSchemaBloc.getFieldStream(mapEntry.key),
      builder: (context, snapshot) {
//        if (snapshot.hasData) {
        return CheckboxFormField(
          autoValidate: false,
          initialValue: snapshot?.data ?? false,
          title: mapEntry.value.title +
              (mapEntry.value.requiredOnParent ? ' *' : ''),
          validator: (bool value) {
            var validator = Validator(mapEntry.value);

            if (!validator.validate(value)) {
              return validator.errors.first;
            }

            return null;
          },
          onSaved: (bool value) {
            jsonSchemaBloc.add(
              ChangeValueJsonSchemaEvent(
                key: mapEntry.key,
                value: value,
              ),
            );

            return;
          },
          onChange: (value) {
            jsonSchemaBloc.add(
              ChangeValueJsonSchemaEvent(
                key: mapEntry.key,
                value: value,
              ),
            );

            return;
          },
        );
//        } else {
//          return Container();
//        }
      },
    );
  }
}
