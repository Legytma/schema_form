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
import 'package:rxdart/rxdart.dart';

import '../../../enum/picker_type.dart';
import 'state/text_schema_form_field_widget_state.dart';

/// Schema text form field é um envelopamento do widget [TextFormField]
/// adicionando validação através de schema.
class TextSchemaFormFieldWidget extends StatefulWidget {
  /// Controls the text being edited.
  ///
  /// If null, this widget will create its own [TextEditingController] and
  /// initialize its [TextEditingController.text] with [initialValue].
  final BehaviorSubject<String> controller;

  /// Field name
  final String fieldName;

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
  final String dateFormat;

  final PickerType pickerType;

  /// Create instance of schema text form field
  const TextSchemaFormFieldWidget({
    Key key,
    @required this.fieldName,
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
    this.dateFormat,
    this.pickerType,
  })  : assert(fieldName != null),
        super(key: key);

  @override
  TextSchemaFormFieldWidgetState createState() =>
      TextSchemaFormFieldWidgetState();
}
