import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';
import 'package:schema_form/common/control/CheckboxFormField.dart';

class JsonSchemaForm extends StatelessWidget {
  final Key formKey;

  JsonSchemaForm({this.formKey});

  @override
  Widget build(BuildContext context) {
    // ignore: close_sinks
    final JsonSchemaBloc jsonSchemaBloc =
        BlocProvider.of<JsonSchemaBloc>(context);

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
    final JsonSchemaBloc jsonSchemaBloc =
        BlocProvider.of<JsonSchemaBloc>(context);

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
          Validator validator = new Validator(mapEntry.value);

          if (!validator.validate(value)) {
            return validator.errors.first;
          }

          return null;
        },
        decoration: InputDecoration(
          hintText: mapEntry.value.defaultValue != null
              ? mapEntry.value.defaultValue
              : '',
          labelText: mapEntry.value.requiredOnParent
              ? mapEntry.value.title + ' *'
              : mapEntry.value.title,
        ),
      ),
    );
  }

  Widget getCheckBox(
      MapEntry<String, JsonSchema> mapEntry, BuildContext context) {
    // ignore: close_sinks
    final JsonSchemaBloc jsonSchemaBloc =
        BlocProvider.of<JsonSchemaBloc>(context);

    return StreamBuilder(
      stream: jsonSchemaBloc.getFieldStream(mapEntry.key),
      builder: (context, snapshot) {
//        if (snapshot.hasData) {
        return CheckboxFormField(
          autoValidate: false,
          initialValue: snapshot?.data ?? false,
          title: mapEntry.value.requiredOnParent
              ? mapEntry.value.title + ' *'
              : mapEntry.value.title,
          validator: (bool value) {
            Validator validator = new Validator(mapEntry.value);

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
