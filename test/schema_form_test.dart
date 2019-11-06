import 'package:flutter_test/flutter_test.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';
import 'package:schema_form/schema_form.dart';

void main() {
  test('adds one to input values', () {
    var jsonSchemaBloc = JsonSchemaBloc(formContext: null);

    final schemaForm = SchemaForm(jsonSchemaBloc: jsonSchemaBloc);

    print("schemaForm: $schemaForm");

    jsonSchemaBloc.close();
  });
}
