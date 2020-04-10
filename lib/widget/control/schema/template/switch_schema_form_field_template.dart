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

import '../switch_schema_form_field_widget.dart';
import 'widget_template.dart';

class SwitchSchemaFormFieldTemplate
    extends WidgetTemplate<SwitchSchemaFormFieldWidget> {
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
  final Color activeTrackColor;
  final Color inactiveThumbColor;
  final Color inactiveTrackColor;
  final ImageProvider inactiveThumbImage;
  final ImageProvider activeThumbImage;
  final bool isThreeLine;
  final bool selected;
  final ValueChanged<bool> onChanged;

  /// Create [SwitchFormFieldWidget] optionally using [onSaved], [validator],
  /// [initialValue], [onChange], [title] and [autoValidate].
  SwitchSchemaFormFieldTemplate({
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
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveTrackColor,
    this.inactiveThumbImage,
    this.activeThumbImage,
    this.isThreeLine,
    this.selected,
  });

  @override
  SwitchSchemaFormFieldWidget createWidgetInstance(
      BuildContext context, Map<String, dynamic> aditionalProperties) {
    return SwitchSchemaFormFieldWidget(
      key: getAditionalPropertyValue("key", aditionalProperties, key),
      fieldName: getAditionalPropertyValue(
          "fieldName", aditionalProperties, fieldName),
      controller: getAditionalPropertyValue(
          "controller", aditionalProperties, controller),
      inactiveTrackColor: getAditionalPropertyValue(
          "inactiveTrackColor", aditionalProperties, inactiveTrackColor),
      inactiveThumbImage: getAditionalPropertyValue(
          "inactiveThumbImage", aditionalProperties, inactiveThumbImage),
      inactiveThumbColor: getAditionalPropertyValue(
          "inactiveThumbColor", aditionalProperties, inactiveThumbColor),
      activeTrackColor: getAditionalPropertyValue(
          "activeTrackColor", aditionalProperties, activeTrackColor),
      activeThumbImage: getAditionalPropertyValue(
          "activeThumbImage", aditionalProperties, activeThumbImage),
      decoration: getAditionalPropertyValue(
          "decoration", aditionalProperties, decoration),
      enabled:
          getAditionalPropertyValue("enabled", aditionalProperties, enabled),
      activeColor: getAditionalPropertyValue(
          "activeColor", aditionalProperties, activeColor),
      autoValidate: getAditionalPropertyValue(
          "autoValidate", aditionalProperties, autoValidate),
      initialValue: getAditionalPropertyValue(
          "initialValue", aditionalProperties, initialValue),
      isThreeLine: getAditionalPropertyValue(
          "isThreeLine", aditionalProperties, isThreeLine),
      onChanged: getAditionalPropertyValue(
          "onChanged", aditionalProperties, onChanged),
      onSaved:
          getAditionalPropertyValue("onSaved", aditionalProperties, onSaved),
      selected:
          getAditionalPropertyValue("selected", aditionalProperties, selected),
      validator: getAditionalPropertyValue(
          "validator", aditionalProperties, validator),
    );
  }
}
