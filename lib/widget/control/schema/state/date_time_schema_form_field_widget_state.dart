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
import 'package:flutter/services.dart';
import 'package:json_schema/json_schema.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

import '../date_time_schema_form_field_widget.dart';
import '../schema_form_widget.dart';

/// Schema text form field widget state
class DateTimeSchemaFormFieldWidgetState
    extends State<DateTimeSchemaFormFieldWidget> {
  static final Logger _log = Logger("DateTimeSchemaFormFieldWidgetState");

  BehaviorSubject<dynamic> _controller;
  TextEditingController _textEditingController;
  StreamSubscription _streamSubscription;
  JsonSchema _fieldSchema;

  InputDecoration _inputDecoration;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _log.finest("Executing didChangeDependencies...");

    var schemaFormWidgetState = SchemaFormWidget.of(context);

    _fieldSchema = schemaFormWidgetState.getFieldSchema(widget.fieldName);

    BehaviorSubject<dynamic> currentController;

    if (widget.controller != null) {
      currentController = widget.controller;
    } else {
      currentController = schemaFormWidgetState.createFieldController(
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

    if (_textEditingController != null) {
      _textEditingController.dispose();
      _textEditingController = null;
    }

    _textEditingController = TextEditingController(
      text: widget.initialValue ?? _fieldSchema.defaultValue,
    );

    _textEditingController.addListener(() {
//      _log.finest("Excecuting _textEditingControllerListner...");

      _controller.add(_textEditingController?.text);
    });

    if (_streamSubscription != null) {
      _streamSubscription.cancel();
      _streamSubscription = null;
    }

    _streamSubscription = _controller.stream.listen((value) {
//      _log.finest("Executing _streamSubscription with value: '$value'");

      if (_textEditingController != null &&
          value != _textEditingController.text) {
//        _log.finest("'$value' is different of '${_textEditingController?.text
//        }'");

        _textEditingController.text = value;
      }
    });

    _inputDecoration = (widget.decoration ??
            InputDecoration(
              contentPadding:
                  Theme.of(context)?.inputDecorationTheme?.contentPadding ??
                      EdgeInsets.only(left: 16, right: 16),
              suffixIcon: Icon(Icons.calendar_today),
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
    _log.finest("Executing build...");

    return TextFormField(
      controller: _textEditingController,
      onChanged: widget.onChanged,
      autovalidate: widget.autovalidate ?? false,
      textDirection: widget.textDirection,
      focusNode: widget.focusNode,
      autofocus: widget.autofocus ?? false,
      autocorrect: widget.autocorrect ?? true,
      buildCounter: widget.buildCounter,
      cursorColor: widget.cursorColor,
      cursorRadius: widget.cursorRadius,
      cursorWidth: widget.cursorWidth ?? 2.0,
      decoration: _inputDecoration,
      enabled: widget.enabled ?? true,
      enableInteractiveSelection: widget.enableInteractiveSelection ?? true,
      enableSuggestions: widget.enableSuggestions ?? true,
      expands: widget.expands ?? false,
//      initialValue: widget.initialValue,
      inputFormatters: widget.inputFormatters,
      keyboardAppearance: widget.keyboardAppearance,
      keyboardType: widget.keyboardType,
      maxLength: widget.maxLength,
      maxLengthEnforced: widget.maxLengthEnforced ?? true,
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines,
      obscureText: widget.obscureText ?? false,
      onEditingComplete: widget.onEditingComplete,
      onFieldSubmitted: widget.onFieldSubmitted,
      onSaved: widget.onSaved,
      onTap: widget.onTap,
      readOnly: widget.readOnly ?? false,
      scrollPadding: widget.scrollPadding ?? const EdgeInsets.all(20.0),
      showCursor: widget.showCursor,
      strutStyle: widget.strutStyle,
      style: widget.style,
      textAlign: widget.textAlign ?? TextAlign.start,
      textAlignVertical: widget.textAlignVertical,
      textCapitalization: widget.textCapitalization ?? TextCapitalization.none,
      textInputAction: widget.textInputAction,
      toolbarOptions: widget.toolbarOptions,
      validator: _validator,
    );
  }

  @override
  void dispose() {
    _log.finest("Executing dispose...");

    _textEditingController.dispose();
    _textEditingController = null;

    _streamSubscription.cancel();
    _streamSubscription = null;

    SchemaFormWidget.of(context).disposeFieldController(key: widget.fieldName);

    super.dispose();
  }

  String _validator(String value) {
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

      for (var error in validator.errors) {
        if (validationMessages == null) {
          validationMessages = "$error";
        } else {
          validationMessages = "$validationMessages\n$error";
        }
      }

      return validationMessages;
    }

    return null;
  }
}
