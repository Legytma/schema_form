import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';

class JsonSchemaBlocClickListener implements ClickListener {
  final JsonSchemaBloc _jsonSchemaBloc;

  JsonSchemaBlocClickListener(this._jsonSchemaBloc);

  @override
  void onClicked(String event) {
    if ('SchemaForm://submit' == event) {
      print("Executing: $event");

      _jsonSchemaBloc.add(SubmitJsonSchemaEvent());
    } else {
      print("Click event not implemented: $event");
    }
  }
}
