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

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:rxdart/subjects.dart';

import '../check_box_schema_form_field_widget.dart';
import 'widget_template.dart';

class CheckBoxSchemaFormFieldTemplate
    extends WidgetTemplate<CheckBoxSchemaFormFieldWidget> {
  final Key key;
  final String fieldName;
  final BehaviorSubject<bool> controller;
  final FormFieldValidator<bool> validator;
  final FormFieldSetter<bool> onSaved;
  final bool initialValue;
  final InputDecoration decoration;
  final bool autoValidate;
  final bool enabled;
  final Color activeColor;
  final bool isThreeLine;
  final bool selected;
  final ListTileControlAffinity controlAffinity;
  final Color checkColor;
  final ValueChanged<bool> onChanged;

  /// Create [SwitchFormFieldWidget] optionally using [onSaved], [validator],
  /// [initialValue], [onChange], [title] and [autoValidate].
  CheckBoxSchemaFormFieldTemplate({
    this.key,
    this.fieldName,
    this.controller,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.initialValue,
    this.decoration,
    this.autoValidate,
    this.enabled,
    this.activeColor,
    this.isThreeLine,
    this.selected,
    this.controlAffinity,
    this.checkColor,
  });

  @override
  CheckBoxSchemaFormFieldWidget createWidgetInstance(
      BuildContext context, Map<String, dynamic> aditionalProperties) {
    return CheckBoxSchemaFormFieldWidget(
      key: getAditionalPropertyValue("key", aditionalProperties, key),
      fieldName: getAditionalPropertyValue(
          "fieldName", aditionalProperties, fieldName),
      controller: getAditionalPropertyValue(
          "controller", aditionalProperties, controller),
      validator: getAditionalPropertyValue(
          "validator", aditionalProperties, validator),
      onSaved:
          getAditionalPropertyValue("onSaved", aditionalProperties, onSaved),
      onChanged: getAditionalPropertyValue(
          "onChanged", aditionalProperties, onChanged),
      initialValue: getAditionalPropertyValue(
          "initialValue", aditionalProperties, initialValue),
      decoration: getAditionalPropertyValue(
          "decoration", aditionalProperties, decoration),
      enabled:
          getAditionalPropertyValue("enabled", aditionalProperties, enabled),
      checkColor: getAditionalPropertyValue(
          "checkColor", aditionalProperties, checkColor),
      controlAffinity: getAditionalPropertyValue(
          "controlAffinity", aditionalProperties, controlAffinity),
      activeColor: getAditionalPropertyValue(
          "activeColor", aditionalProperties, activeColor),
      isThreeLine: getAditionalPropertyValue(
          "isThreeLine", aditionalProperties, isThreeLine),
      selected:
          getAditionalPropertyValue("selected", aditionalProperties, selected),
      autoValidate: getAditionalPropertyValue(
          "autoValidate", aditionalProperties, autoValidate),
    );
  }

  @override
  List<Object> get props => [
        key,
        fieldName,
        controller,
        onSaved,
        onChanged,
        validator,
        initialValue,
        decoration,
        autoValidate,
        enabled,
        activeColor,
        isThreeLine,
        selected,
        controlAffinity,
        checkColor,
      ];
}
