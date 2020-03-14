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
import 'package:flutter/services.dart';
import 'package:rxdart/subjects.dart';

import '../date_time_schema_form_field_widget.dart';
import 'widget_template.dart';

/// Schema text form field é um envelopamento do widget [TextFormField]
/// adicionando validação através de schema.
class DateTimeSchemaFormFieldTemplate
    extends WidgetTemplate<DateTimeSchemaFormFieldWidget> {
  final Key key;

  final String fieldName;

  final BehaviorSubject<String> controller;

  /// Initial value
  final String initialValue;

  /// Focus node
  final FocusNode focusNode;

  /// Input decoration
  final InputDecoration decoration;

  /// Keyboard type
  final TextInputType keyboardType;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Text input action
  final TextInputAction textInputAction;

  /// Style
  final TextStyle style;

  /// Struct style
  final StrutStyle strutStyle;

  /// Text direction
  final TextDirection textDirection;

  /// Text align
  final TextAlign textAlign;

  /// Text align vertical
  final TextAlignVertical textAlignVertical;

  /// Auto focus
  final bool autofocus;

  /// Read only
  final bool readOnly;

  /// Toolbar options
  final ToolbarOptions toolbarOptions;

  /// Show cursor
  final bool showCursor;
  final bool obscureText;
  final bool autocorrect;
  final bool enableSuggestions;
  final bool autovalidate;
  final bool maxLengthEnforced;
  final int maxLines;
  final int minLines;
  final bool expands;
  final int maxLength;
  final ValueChanged<String> onChanged;
  final GestureTapCallback onTap;
  final VoidCallback onEditingComplete;
  final ValueChanged<String> onFieldSubmitted;
  final FormFieldSetter<String> onSaved;
  final FormFieldValidator<String> validator;
  final List<TextInputFormatter> inputFormatters;
  final bool enabled;
  final double cursorWidth;
  final Radius cursorRadius;
  final Color cursorColor;
  final Brightness keyboardAppearance;
  final EdgeInsets scrollPadding;
  final bool enableInteractiveSelection;
  final InputCounterWidgetBuilder buildCounter;

  /// Create instance of schema text form field
  DateTimeSchemaFormFieldTemplate({
    this.key,
    this.fieldName,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.decoration,
    this.keyboardType,
    this.textCapitalization,
    this.textInputAction,
    this.style,
    this.strutStyle,
    this.textDirection,
    this.textAlign,
    this.textAlignVertical,
    this.autofocus,
    this.readOnly,
    this.toolbarOptions,
    this.showCursor,
    this.obscureText,
    this.autocorrect,
    this.enableSuggestions,
    this.autovalidate,
    this.maxLengthEnforced,
    this.maxLines,
    this.minLines,
    this.expands,
    this.maxLength,
    this.onChanged,
    this.onTap,
    this.onEditingComplete,
    this.onFieldSubmitted,
    this.onSaved,
    this.validator,
    this.inputFormatters,
    this.enabled,
    this.cursorWidth,
    this.cursorRadius,
    this.cursorColor,
    this.keyboardAppearance,
    this.scrollPadding,
    this.enableInteractiveSelection,
    this.buildCounter,
  });

  @override
  List<Object> get props => [
        key,
        fieldName,
        controller,
        initialValue,
        focusNode,
        decoration,
        keyboardType,
        textCapitalization,
        textInputAction,
        style,
        strutStyle,
        textDirection,
        textAlign,
        textAlignVertical,
        autofocus,
        readOnly,
        toolbarOptions,
        showCursor,
        obscureText,
        autocorrect,
        enableSuggestions,
        autovalidate,
        maxLengthEnforced,
        maxLines,
        minLines,
        expands,
        maxLength,
        onChanged,
        onTap,
        onEditingComplete,
        onFieldSubmitted,
        onSaved,
        validator,
        inputFormatters,
        enabled,
        cursorWidth,
        cursorRadius,
        cursorColor,
        keyboardAppearance,
        scrollPadding,
        enableInteractiveSelection,
        buildCounter,
      ];

  @override
  DateTimeSchemaFormFieldWidget createWidgetInstance(
      BuildContext context, Map<String, dynamic> aditionalProperties) {
    return DateTimeSchemaFormFieldWidget(
      key: getAditionalPropertyValue("key", aditionalProperties, key),
      fieldName: getAditionalPropertyValue(
          "fieldName", aditionalProperties, fieldName),
      controller: getAditionalPropertyValue(
          "controller", aditionalProperties, controller),
      enabled:
          getAditionalPropertyValue("enabled", aditionalProperties, enabled),
      style: getAditionalPropertyValue("style", aditionalProperties, style),
      decoration: getAditionalPropertyValue(
          "decoration", aditionalProperties, decoration),
      maxLines:
          getAditionalPropertyValue("maxLines", aditionalProperties, maxLines),
      strutStyle: getAditionalPropertyValue(
          "strutStyle", aditionalProperties, strutStyle),
      textDirection: getAditionalPropertyValue(
          "textDirection", aditionalProperties, textDirection),
      textAlign: getAditionalPropertyValue(
          "textAlign", aditionalProperties, textAlign),
      autocorrect: getAditionalPropertyValue(
          "autocorrect", aditionalProperties, autocorrect),
      autofocus: getAditionalPropertyValue(
          "autofocus", aditionalProperties, autofocus),
      autovalidate: getAditionalPropertyValue(
          "autovalidate", aditionalProperties, autovalidate),
      buildCounter: getAditionalPropertyValue(
          "buildCounter", aditionalProperties, buildCounter),
      cursorColor: getAditionalPropertyValue(
          "cursorColor", aditionalProperties, cursorColor),
      cursorRadius: getAditionalPropertyValue(
          "cursorRadius", aditionalProperties, cursorRadius),
      cursorWidth: getAditionalPropertyValue(
          "cursorWidth", aditionalProperties, cursorWidth),
      enableInteractiveSelection: getAditionalPropertyValue(
          "enableInteractiveSelection",
          aditionalProperties,
          enableInteractiveSelection),
      enableSuggestions: getAditionalPropertyValue(
          "enableSuggestions", aditionalProperties, enableSuggestions),
      expands:
          getAditionalPropertyValue("expands", aditionalProperties, expands),
      focusNode: getAditionalPropertyValue(
          "focusNode", aditionalProperties, focusNode),
      initialValue: getAditionalPropertyValue(
          "initialValue", aditionalProperties, initialValue),
      inputFormatters: getAditionalPropertyValue(
          "inputFormatters", aditionalProperties, inputFormatters),
      keyboardAppearance: getAditionalPropertyValue(
          "keyboardAppearance", aditionalProperties, keyboardAppearance),
      keyboardType: getAditionalPropertyValue(
          "keyboardType", aditionalProperties, keyboardType),
      maxLength: getAditionalPropertyValue(
          "maxLength", aditionalProperties, maxLength),
      minLines:
          getAditionalPropertyValue("minLines", aditionalProperties, minLines),
      maxLengthEnforced: getAditionalPropertyValue(
          "maxLengthEnforced", aditionalProperties, maxLengthEnforced),
      obscureText: getAditionalPropertyValue(
          "obscureText", aditionalProperties, obscureText),
      onChanged: getAditionalPropertyValue(
          "onChanged", aditionalProperties, onChanged),
      onEditingComplete: getAditionalPropertyValue(
          "onEditingComplete", aditionalProperties, onEditingComplete),
      onFieldSubmitted: getAditionalPropertyValue(
          "onFieldSubmitted", aditionalProperties, onFieldSubmitted),
      onSaved:
          getAditionalPropertyValue("onSaved", aditionalProperties, onSaved),
      onTap: getAditionalPropertyValue("onTap", aditionalProperties, onTap),
      readOnly:
          getAditionalPropertyValue("readOnly", aditionalProperties, readOnly),
      scrollPadding: getAditionalPropertyValue(
          "scrollPadding", aditionalProperties, scrollPadding),
      showCursor: getAditionalPropertyValue(
          "showCursor", aditionalProperties, showCursor),
      textAlignVertical: getAditionalPropertyValue(
          "textAlignVertical", aditionalProperties, textAlignVertical),
      textCapitalization: getAditionalPropertyValue(
          "textCapitalization", aditionalProperties, textCapitalization),
      textInputAction: getAditionalPropertyValue(
          "textInputAction", aditionalProperties, textInputAction),
      toolbarOptions: getAditionalPropertyValue(
          "toolbarOptions", aditionalProperties, toolbarOptions),
      validator: getAditionalPropertyValue(
          "validator", aditionalProperties, validator),
    );
  }
}
