import 'package:flutter_test/flutter_test.dart';
import 'package:schema_form/SchemaForm.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';

void main() {
  test('adds one to input values', () {
    JsonSchemaBloc jsonSchemaBloc = JsonSchemaBloc(formContext: null);

    final schemaForm = new SchemaForm(jsonSchemaBloc: jsonSchemaBloc);

    print("schemaForm: $schemaForm");

    jsonSchemaBloc.close();
  });
}
