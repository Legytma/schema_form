import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';

class JsonSchemaBlocClickListener implements ClickListener {
  final JsonSchemaBloc _jsonSchemaBloc;

  JsonSchemaBlocClickListener(this._jsonSchemaBloc);

  @override
  void onClicked(String event) {
    if ('SchemaForm://submit' == event) {
      print("Executing: $event");

      _jsonSchemaBloc.dispatch(SubmitJsonSchemaEvent());
    } else {
      print("Click event not implemented: $event");
    }
  }
}
