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

import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dynamic_widget/dynamic_widget.dart';
import 'package:flutter/widgets.dart';
import 'package:json_schema/json_schema.dart';
import 'package:json_schema/vm.dart';
import 'package:rxdart/subjects.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';

/// [Bloc] for managing [JsonSchemaState] through the use of [JsonSchemaEvent]
/// which implements [ClickListener] used to handle the click event of controls.
///
/// This is the business logic used to manage the form.
class JsonSchemaBloc extends Bloc<JsonSchemaEvent, JsonSchemaState>
    implements ClickListener {
  final Map<String, BehaviorSubject<dynamic>> _formData =
      <String, BehaviorSubject<dynamic>>{};

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  /// Get to the [FormState].
  GlobalKey<FormState> get formKey => _formKey;

  final PublishSubject<String> _submitData = PublishSubject<String>();

  /// Property used to store [VoidCallback] that will be used to handle the
  /// [Form.onFormChanged] event.
  VoidCallback onFormChanged;

  /// Property used to store [WillPopCallback] that will be used to handle the
  /// [Form.onFormWillPop] event.
  WillPopCallback onFormWillPop;

  /// Property used to store [BuildContext] used if you need to retrieve form
  /// state through context.
  ///
  /// TODO Remove this workaround.
  BuildContext formContext;

  /// Get to the [Stream]<[String]> of the submit data.
  Stream<String> get submitData => _submitData;

  /// Create a [JsonSchemaBloc] using [formContext] and optionally
  /// [onFormChanged] and [onFormWillPop].
  JsonSchemaBloc({
    @required this.formContext,
    this.onFormChanged,
    this.onFormWillPop,
  }) {
    configureJsonSchemaForVm();
//    configureJsonSchemaForBrowser();
  }

  /// Get [JsonSchema] from the [fieldName] property of [dataSchema] present in
  /// the current state.
  JsonSchema getPropertySchema(String fieldName) =>
      state?.dataSchema?.properties[fieldName];

  /// Get [Stream]<[dynamic]> for the form's [fieldName] field.
  Stream<dynamic> getFieldStream(String fieldName) =>
      _formData[fieldName].stream;

  void _initDataBinding(Map<String, dynamic> properties) {
//    print("properties: $properties");
    properties?.forEach((key, prop) {
//      print("Creating: $key");
//      print("prop: $prop");
//      print("currentState.data: ${state.data}");
//      print("currentState.data[key]: ${state.data[key]}");
//      print(
//          "currentState.data[key] ?? prop.defaultValue: ${state.data[key] ?? prop.defaultValue}");
      _formData[key] =
          BehaviorSubject<dynamic>.seeded(state.data[key] ?? prop.defaultValue);
//      print("Created: $key");
    });
  }

  /// Get JSON [String] for form data after [validate].
  String getFormData() {
    if (validate()) {
      return json.encode(state.data);
    }

    return "Não foi possível validar os dados";
  }

  /// Validate form data using [JsonSchema]
  bool validate() {
//    print("_data: ${state.data}");
    return state.dataSchema == null
        ? false
        : state.dataSchema.validate(state.data, reportMultipleErrors: true);
  }

  Future<void> close() async {
    await () async => _formDataClose();

    await super.close();
  }

  void _formDataClose() {
//    print("Initial _formData.length: ${_formData.length}");

    _formData.removeWhere((key, value) {
//      print("Closing: $key");
      value.close();
//      print("Closed: $key");

      return true;
    });

//    print("Final _formData.length: ${_formData.length}");
  }

  @override
  JsonSchemaState get initialState => JsonSchemaState.initial();

  @override
  Stream<JsonSchemaState> mapEventToState(JsonSchemaEvent event) async* {
    if (event is LoadDataSchemaEvent) {
      _formDataClose();

      _initDataBinding(event.dataSchema?.properties);

      yield state.copyWith(dataSchema: event.dataSchema);
//      print("LoadJsonSchemaEvent executed");
//
//      currentState.data?.forEach((key, value) {
//        print("Loaded(key: ${key}, value: ${value})");
//        if (_formData.containsKey(key)) {
//          _formData[key].add(value);
//        }
//      });
    } else if (event is LoadDataEvent) {
      var currentData = event.data ?? state.data;

      currentData?.forEach((key, value) {
        if (_formData.containsKey(key)) {
          _formData[key].add(value);
//          print("Loaded(key: $key, value: $value)");
        }
      });

      yield state.copyWith(data: event.data);
//      print("LoadDataEvent executed");
    } else if (event is LoadLayoutSchemaEvent) {
      yield state.copyWith(layout: event.layout);
//      print("LoadLayoutSchemaEvent executed");
    } else if (event is ChangeValueJsonSchemaEvent) {
//      print("event.key: ${event.key}, event.value: ${event.value}");

      if (_formData.containsKey(event.key)) {
        _formData[event.key].add(event.value);
      }

      var currentData = state.data;

      currentData[event.key] = event.value;

//      print("ChangeValueJsonSchemaEvent executed");
      yield state.copyWith(data: currentData);
    } else if (event is SubmitJsonSchemaEvent) {
      try {
//        print("currentState.data: ${state.data}");

        var formState = formKey?.currentState ?? Form.of(formContext);

//        print("formState: $formState");

        if (formState.validate()) {
//          print("Valid form state");

          formState.save();

          var validator = Validator(state.dataSchema);

          if (validator.validate(state.data)) {
            _submitData.add(json.encode(state.data));
          } else {
            _submitData.add(validator.errors.toString());
          }
        } else {
          _submitData.add("Invalid form state");
        }
      } on Error catch (e) {
        _submitData.add(e.toString());
      }

      yield state;
    }
  }

  @override
  void onClicked(String event) {
    if ('SchemaForm://submit' == event) {
      print("Executing: $event");

      add(SubmitJsonSchemaEvent());
    } else {
      print("Click event not implemented: $event");
    }
  }
}
