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

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:json_schema/json_schema.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/subjects.dart';

import '../../../sub_title_text_schema_form_widget.dart';
import '../../../title_text_schema_form_widget.dart';
import '../check_box_schema_form_field_widget.dart';
import '../schema_form_widget.dart';
import '../text_schema_form_field_widget.dart';
import 'schema_form_widget_scope.dart';

/// Schema form state
class SchemaFormWidgetState extends State<SchemaFormWidget> {
  static final Logger _log = Logger("SchemaFormWidgetState");

  final Map<String, BehaviorSubject<dynamic>> _formFieldControllers =
      <String, BehaviorSubject<dynamic>>{};
  final StreamController<Map<String, dynamic>> _dataController =
      StreamController<Map<String, dynamic>>();
  StreamSubscription<Map<String, dynamic>> _dataStreamSubscription;
  final StreamController<String> _validationController =
      StreamController<String>();
  Stream<String> _validationStream;

  Map<String, dynamic> _data;
  String _validationMessages;

  int _generation = 0;

  /// Global form state key
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  /// Get Json Schema of form
  JsonSchema get jsonSchema => widget.jsonSchema;

  Stream<String> get validationStream => _validationStream;

  String get validationMessages => _validationMessages;

  /// Get current form value
  Map<String, dynamic> get value => _data;

  set value(Map<String, dynamic> data) => _dataController.add(data);

  dynamic getValue(String key) => _data[key];

  void setValue(String key, dynamic data) =>
      _formFieldControllers[key].add(data);

  @override
  void initState() {
    super.initState();

    _data = widget.initialData ?? <String, dynamic>{};

    _validationStream = _validationController.stream.asBroadcastStream();

    _dataStreamSubscription = _dataController.stream.listen((data) {
      _data = data;

      _log.finest("\t\t\t_data: $_data");

      data.forEach((key, value) {
        if (_formFieldControllers.containsKey(key)) {
          _formFieldControllers[key].add(value);
        }
      });

      if (widget.autovalidate) {
        validate();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _log.finest("Executing build...");

    return SchemaFormWidgetScope(
      schemaFormState: this,
      generation: _generation,
      child: Form(
        key: formKey,
        child: widget.child ?? _childBuilder(context),
        autovalidate: widget.autovalidate,
        onChanged: widget.onChanged,
        onWillPop: widget.onWillPop,
      ),
    );
  }

  Widget _childBuilder(BuildContext context) {
    var children = <Widget>[];

    if (widget.defaultHeader) {
      children.add(TitleTextSchemaFormWidget());
      children.add(SubTitleTextSchemaFormWidget());
    }

    if (jsonSchema.properties.isNotEmpty) {
      jsonSchema.properties.forEach((key, value) {
        children.add(_makeSchemaFormFieldWidget(context, key, value));
      });
    }

    return ListView(children: children);
  }

  Widget _makeSchemaFormFieldWidget(
      BuildContext context, String fieldName, JsonSchema fieldSchema) {
    var controlTemplateMap = widget.controlTemplateMap;

    if (controlTemplateMap != null &&
        controlTemplateMap.isNotEmpty &&
        controlTemplateMap.containsKey(fieldName)) {
      var widgetTemplate = controlTemplateMap[fieldName];

      return widgetTemplate
          .createWidgetInstance(context, {"fieldName": fieldName});
    }

    var typeTemplateMap = widget.typeTemplateMap;

    if (typeTemplateMap != null &&
        typeTemplateMap.isNotEmpty &&
        typeTemplateMap.containsKey(fieldSchema.type)) {
      var widgetTemplate = typeTemplateMap[fieldSchema.type];

      return widgetTemplate
          .createWidgetInstance(context, {"fieldName": fieldName});
    }

    switch (fieldSchema.type) {
      case SchemaType.string:
      case SchemaType.number:
      case SchemaType.integer:
        return TextSchemaFormFieldWidget(fieldName: fieldName);
      case SchemaType.boolean:
        return CheckBoxSchemaFormFieldWidget(fieldName: fieldName);
      default:
        throw Exception("Control not found to field '$fieldName'"
            " with schema '$fieldSchema'");
    }
  }

  /// Reset form value
  void reset() {
    formKey.currentState.reset();
  }

  /// Validate form value
  bool validate() {
    var formValid = formKey.currentState.validate();

    var validationErrors = jsonSchema.validateWithErrors(value);

    var schemaValid = validationErrors == null || validationErrors.isEmpty;

    _log.fine("validationErrors: $validationErrors");

    _validationMessages = null;

    for (var validationError in validationErrors) {
      if (_validationMessages == null) {
        _validationMessages = "${validationError.message}";
      } else {
        _validationMessages =
            "$_validationMessages\n${validationError.message}";
      }
    }

    _validationController.add(_validationMessages);

    return formValid && schemaValid;
  }

  /// Save form value
  bool save() {
    if (!validate()) {
      return false;
    }

    formKey.currentState.save();

    if (widget.onSave != null) {
      widget.onSave(value);
    }

    return true;
  }

  /// Get field schema
  JsonSchema getFieldSchema(String key) => jsonSchema.properties[key];

  /// Create field controller
  BehaviorSubject<dynamic> createFieldController(String key, {dynamic value}) {
    if (_formFieldControllers.containsKey(key)) {
      return _formFieldControllers[key];
    }

    var fieldController = BehaviorSubject<dynamic>();

    fieldController.stream.listen((fieldValue) {
      _data[key] = fieldValue;

      if (widget.autovalidate) {
        validate();
      }
    });

    if (_data != null && _data[key] != null) {
      fieldController.add(_data[key]);
    } else if (value != null) {
      fieldController.add(value);
    }

    _formFieldControllers[key] = fieldController;

    return fieldController;
  }

  /// Dispose field controller
  void disposeFieldController({String key}) {
    _formFieldControllers.removeWhere((_key, value) {
      if (_key == null || _key == "" || _key == key) {
        value.close();

        return true;
      }

      return false;
    });
  }

  @override
  void dispose() {
    _dataStreamSubscription.cancel();
    _dataStreamSubscription = null;

    disposeFieldController();

    _dataController.close();
    _validationController.close();

    super.dispose();
  }

  void _forceRebuild() {
    setState(() {
      ++_generation;
    });
  }
}
