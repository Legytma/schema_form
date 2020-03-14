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
import 'package:flutter/widgets.dart';
import 'package:json_schema/json_schema.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/subjects.dart';

import '../../check_box_form_field_widget.dart';
import '../check_box_schema_form_field_widget.dart';
import '../schema_form_widget.dart';
import 'schema_form_widget_state.dart';

class CheckboxSchemaFormFieldWidgetState
    extends State<CheckBoxSchemaFormFieldWidget> {
  static final Logger _log = Logger("CheckboxSchemaFormFieldWidgetState");

  BehaviorSubject<dynamic> _controller;
  StreamSubscription _streamSubscription;
  JsonSchema _fieldSchema;

  InputDecoration _decoration;

  SchemaFormWidgetState _schemaFormWidgetState;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _log.finest("Executing didChangeDependencies...");

    _schemaFormWidgetState = SchemaFormWidget.of(context);

    _fieldSchema = _schemaFormWidgetState.getFieldSchema(widget.fieldName);

    BehaviorSubject<dynamic> currentController;

    if (widget.controller != null) {
      currentController = widget.controller;
    } else {
      currentController = _schemaFormWidgetState.createFieldController(
        widget.fieldName,
        value: widget.initialValue ?? _fieldSchema.defaultValue,
      );
    }

    if (_controller != currentController) {
      if (_controller != null && _streamSubscription != null) {
        _streamSubscription.cancel();
        _streamSubscription = null;

//        _controller.close();
      }

      _controller = currentController;
    }

    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }

    _decoration = (widget.decoration ??
            InputDecoration(
              contentPadding:
                  Theme.of(context)?.inputDecorationTheme?.contentPadding ??
                      EdgeInsets.only(left: 16, right: 16),
            ))
        .copyWith(
      labelText: _fieldSchema.title,
      helperText: _fieldSchema.description,
      hintText:
          "${_fieldSchema.examples.isEmpty ? "" : _fieldSchema.examples?.first}",
    );
  }

  @override
  Widget build(BuildContext context) {
//    _log.finer("initialValue: ${widget.initialValue},"
//        " defaultValue: ${_fieldSchema.defaultValue},"
//        " value: ${_controller.value}");
//    _log.finer("titles: ${widget.title} ?? ${_fieldSchema.title}");
//
//    var themeData = Theme.of(context);

    return CheckBoxFormFieldWidget.createScope(
      controlAffinity:
          widget.controlAffinity ?? ListTileControlAffinity.platform,
      checkColor: widget.checkColor,
      selected: widget.selected,
      isThreeLine: widget.isThreeLine,
      activeColor: widget.activeColor,
      enabled: widget.enabled,
      controller: _controller,
      initialValue: widget.initialValue ??
          _fieldSchema.defaultValue ??
          _controller.value ??
          false,
      validator: _validator,
      onSaved: widget.onSaved,
      autoValidate: widget.autoValidate ?? false,
      decoration: _decoration,
      onChanged: widget.onChanged,
    );
  }

  @override
  void dispose() {
    _log.finest("Executing dispose...");

    _streamSubscription?.cancel();
    _streamSubscription = null;

    _schemaFormWidgetState?.disposeFieldController(key: widget.fieldName);

    super.dispose();
  }

  String _validator(bool value) {
    if (widget.validator != null) {
      var result = widget.validator(value);

      if (result != null && result != "") {
        return result;
      }
    }

    if (_fieldSchema.requiredOnParent && (value == null || value == '')) {
      return "Required";
    }

    var validator = Validator(_fieldSchema);

    if (!validator.validate(value, reportMultipleErrors: true)) {
      var validationMessages;

      for (var errorObject in validator.errorObjects) {
        if (validationMessages == null) {
          validationMessages = "${errorObject.message}";
        } else {
          validationMessages = "$validationMessages\n${errorObject.message}";
        }
      }

      return validationMessages;
    }

    return null;
  }
}
