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
import 'package:intl/intl.dart';
import 'package:json_schema/json_schema.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../enum/PickerType.dart';
import '../schema_form_widget.dart';
import '../text_schema_form_field_widget.dart';
import 'schema_form_widget_state.dart';

/// Schema text form field widget state
class TextSchemaFormFieldWidgetState extends State<TextSchemaFormFieldWidget> {
  static final Logger _log = Logger("TextSchemaFormFieldWidgetState");

  BehaviorSubject<dynamic> _controller;
  TextEditingController _textEditingController;
  StreamSubscription _streamSubscription;
  JsonSchema _fieldSchema;
  DateFormat _dateFormat;
  DateFormat _dateFormatDefault;

  InputDecoration _inputDecoration;

  SchemaFormWidgetState _schemaFormWidgetState;

  TextInputType _textInputType;

  PickerType _pickerType;

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
        value: _textEditingController?.text ??
            widget.initialValue ??
            _fieldSchema.defaultValue,
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

    if (_textEditingController != null) {
      _textEditingController.dispose();
      _textEditingController = null;
    }

    _textEditingController = TextEditingController(
      text: widget.initialValue ?? _fieldSchema.defaultValue,
    );

    _pickerType = widget.pickerType;

    if (_pickerType == null &&
        _fieldSchema.format != null &&
        _fieldSchema.format == "date-time") {
      _pickerType = PickerType.DateTimePicker;
    }

    if (widget.dateFormat != null) {
      _dateFormat = DateFormat(widget.dateFormat);
      _dateFormatDefault = DateFormat("y-MM-dd hh:mm:ss");
    } else if (_pickerType != null) {
      switch (_pickerType) {
        case PickerType.DateTimePicker:
          _dateFormat = DateFormat("y-MM-dd hh:mm:ss");
          break;
        case PickerType.DatePicker:
          _dateFormat = DateFormat("y-MM-dd");
          break;
        case PickerType.TimePicker:
          _dateFormat = DateFormat("hh:mm:ss");
      }
      _dateFormatDefault = DateFormat("y-MM-dd hh:mm:ss");
    }

    _streamSubscription = _controller.stream.listen((value) {
      _log.finest("Executing _streamSubscription with value: '$value'");

      if (_dateFormat != null) {
        try {
          var parsedValue = _dateFormatDefault.parse(value);

          value = _dateFormat.format(parsedValue);
        } on Exception catch (e) {
          _log.warning("Ignoring invalid value: $value -> $e");
        }
      }

      if (_textEditingController != null &&
          value != _textEditingController.text) {
        _log.finest(
            "'$value' is different of '${_textEditingController?.text}'");

        _textEditingController.value = _textEditingController.value.copyWith(
          text: value,
          selection: _textEditingController.value.selection,
        );
      }
    });

    _textEditingController.addListener(() {
//      _log.finest("Excecuting _textEditingControllerListner...");
      final value = _textEditingController?.text;

      try {
        if (_fieldSchema.type == SchemaType.integer ||
            _fieldSchema.type == SchemaType.number) {
          var parsedValue = num.parse(value);

          _controller.add(parsedValue);
        } else if (_dateFormat != null) {
          var parsedValue = _dateFormat.parse(value);
          var defaultValue = _dateFormatDefault.format(parsedValue);

          _controller.add(defaultValue);
        } else {
          _controller.add(value);
        }
      } on Exception catch (e) {
        _log.warning("Ignoring invalid value: $value -> $e");
      }
    });

    Widget pickerIcon;

    if (_pickerType != null) {
      pickerIcon = GestureDetector(
        child: Icon(Icons.calendar_today),
        onTap: () {
          var currentDateTime = DateTime.now();

          final currentValue = _controller.value;

          try {
            currentDateTime =
                _dateFormatDefault.parse(currentValue) ?? DateTime.now();
          } on Exception catch (e) {
            _log.warning("Ignoring invalid value: $currentValue -> $e");
          }

          if (_pickerType == PickerType.DateTimePicker ||
              _pickerType == PickerType.DatePicker) {
            showDatePicker(
              context: context,
              initialDate: currentDateTime,
              firstDate: DateTime(1900),
              lastDate: DateTime(2099),
            ).then((dateValue) {
              if (_pickerType == PickerType.DateTimePicker) {
                showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.fromDateTime(currentDateTime),
                ).then((timeValue) {
                  final timeValueDateTime = DateTime(
                      dateValue.year,
                      dateValue.month,
                      dateValue.day,
                      timeValue.hour,
                      timeValue.minute);
                  final timeValueString =
                      _dateFormatDefault.format(timeValueDateTime);

                  _controller.add(timeValueString);
                });
              } else {
                final dateValueString = _dateFormatDefault.format(dateValue);

                _controller.add(dateValueString);
              }
            });
          } else if (_pickerType == PickerType.TimePicker) {
            showTimePicker(
              context: context,
              initialTime: TimeOfDay.fromDateTime(currentDateTime),
            ).then((timeValue) {
              final timeValueDateTime = DateTime(
                  currentDateTime.year,
                  currentDateTime.month,
                  currentDateTime.day,
                  timeValue.hour,
                  timeValue.minute);
              final timeValueString =
                  _dateFormatDefault.format(timeValueDateTime);

              _controller.add(timeValueString);
            });
          }
        },
      );
    }

    _inputDecoration = (widget.decoration ??
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
      suffixIcon: pickerIcon ?? widget.decoration?.suffixIcon,
    );

    _textInputType = widget.keyboardType;

    if (_textInputType == null) {
      if (_fieldSchema.type == SchemaType.integer ||
          _fieldSchema.type == SchemaType.number) {
        _textInputType = TextInputType.number;
      } else if (_dateFormat != null) {
        _textInputType = TextInputType.datetime;
      } else if (_fieldSchema.format != null) {
        if (_fieldSchema.format == "uri") {
          _textInputType = TextInputType.url;
        } else if (_fieldSchema.format == "email") {
          _textInputType = TextInputType.emailAddress;
        }
      }
    }
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
      keyboardType: _textInputType,
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

    _schemaFormWidgetState.disposeFieldController(key: widget.fieldName);

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
    dynamic valueToValidate = value;

    if (value != null &&
        (_fieldSchema.type == SchemaType.integer ||
            _fieldSchema.type == SchemaType.number)) {
      try {
        final parsedValue = num.parse(value);

        valueToValidate = parsedValue;
      } on Exception catch (e) {
        _log.warning("Ignoring invalid value: $value -> $e");
      }
    } else if (_dateFormat != null) {
      try {
        final parsedValue = _dateFormat.parse(value);

        valueToValidate = _dateFormatDefault.format(parsedValue);
      } on Exception catch (e) {
        _log.warning("Ignoring invalid value: $value -> $e");
      }
    }

    if (!validator.validate(valueToValidate, reportMultipleErrors: true)) {
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
