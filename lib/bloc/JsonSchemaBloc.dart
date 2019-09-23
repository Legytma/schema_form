import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:json_schema/json_schema.dart';
import 'package:json_schema/vm.dart';
import 'package:rxdart/subjects.dart';
import 'package:schema_form/bloc/JsonSchemaBl.dart';

class JsonSchemaBloc extends Bloc<JsonSchemaEvent, JsonSchemaState>
    implements ClickListener {
  final Map<String, BehaviorSubject<dynamic>> _formData =
      Map<String, BehaviorSubject<dynamic>>();

  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  GlobalKey<FormState> get formKey => _formKey;

  final PublishSubject<String> _submitData = PublishSubject<String>();

  VoidCallback onFormChanged;
  WillPopCallback onFormWillPop;

  BuildContext formContext;

  Stream<String> get submitData => _submitData;

  JsonSchemaBloc({
    @required this.formContext,
    this.onFormChanged,
    this.onFormWillPop,
  }) {
    configureJsonSchemaForVm();
//    configureJsonSchemaForBrowser();
  }

  JsonSchema getPropertySchema(String fieldName) =>
      currentState?.dataSchema?.properties[fieldName];

  Stream<dynamic> getFieldStream(String fieldName) =>
      _formData[fieldName].stream;

  void initDataBinding(Map<String, dynamic> properties) {
    print("properties: $properties");
    properties?.forEach((key, prop) {
      print("Creating: $key");
      print("prop: $prop");
      print("currentState.data: ${currentState.data}");
      print("currentState.data[key]: ${currentState.data[key]}");
      print(
          "currentState.data[key] ?? prop.defaultValue: ${currentState.data[key] ?? prop.defaultValue}");
      _formData[key] = BehaviorSubject<dynamic>.seeded(
          currentState.data[key] ?? prop.defaultValue);
      print("Created: $key");
    });
  }

  String getFormData() {
    if (validate()) {
      return json.encode(currentState.data);
    }

    return "Não foi possível validar os dados";
  }

  bool validate() {
    print("_data: ${currentState.data}");
    return currentState.dataSchema == null
        ? false
        : currentState.dataSchema
            .validate(currentState.data, reportMultipleErrors: true);
  }

  dispose() {
    _formDataClose();
  }

  void _formDataClose() {
    print("Initial _formData.length: ${_formData.length}");

    _formData.removeWhere((key, value) {
      print("Closing: $key");
      value.close();
      print("Closed: $key");

      return true;
    });

    print("Final _formData.length: ${_formData.length}");
  }

  @override
  get initialState => JsonSchemaState.initial();

  @override
  Stream<JsonSchemaState> mapEventToState(event) async* {
    if (event is LoadDataSchemaEvent) {
      _formDataClose();

      initDataBinding(event.dataSchema?.properties);

      yield currentState.copyWith(dataSchema: event.dataSchema);
      print("LoadJsonSchemaEvent executed");
//
//      currentState.data?.forEach((key, value) {
//        print("Loaded(key: ${key}, value: ${value})");
//        if (_formData.containsKey(key)) {
//          _formData[key].add(value);
//        }
//      });
    } else if (event is LoadDataEvent) {
      Map<String, dynamic> currentData = event.data ?? currentState.data;

      currentData?.forEach((key, value) {
        if (_formData.containsKey(key)) {
          _formData[key].add(value);
          print("Loaded(key: ${key}, value: ${value})");
        }
      });

      yield currentState.copyWith(data: event.data);
      print("LoadDataEvent executed");
    } else if (event is LoadLayoutSchemaEvent) {
      yield currentState.copyWith(layout: event.layout);
      print("LoadLayoutSchemaEvent executed");
    } else if (event is ChangeValueJsonSchemaEvent) {
      print("event.key: ${event.key}, event.value: ${event.value}");

      if (_formData.containsKey(event.key)) {
        _formData[event.key].add(event.value);
      }

      Map<String, dynamic> currentData = currentState.data;

      currentData[event.key] = event.value;

      print("ChangeValueJsonSchemaEvent executed");
      yield currentState.copyWith(data: currentData);
    } else if (event is SubmitJsonSchemaEvent) {
      try {
        print("currentState.data: ${currentState.data}");

        FormState formState = formKey?.currentState ?? Form.of(formContext);

        print("formState: $formState");

        if (formState.validate()) {
          print("Valid form state");

          formState.save();

          Validator validator = new Validator(currentState.dataSchema);

          if (validator.validate(currentState.data)) {
            _submitData.add(json.encode(currentState.data));
          } else {
            _submitData.add(validator.errors.toString());
          }
        } else {
          _submitData.add("Invalid form state");
        }
      } catch (e) {
        _submitData.add(e.toString());
      }

      yield currentState;
    }
  }

  @override
  void onClicked(String event) {
    if ('SchemaForm://submit' == event) {
      print("Executing: $event");

      dispatch(SubmitJsonSchemaEvent());
    } else {
      print("Click event not implemented: $event");
    }
  }
}
