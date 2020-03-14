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
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

/// Implements [FormField]<[bool]> of the [SwitchListTile] control.
class RadioButtonFormFieldWidget extends FormField<bool> {
  static final Logger _log = Logger("RadioButtonFormFieldWidget");

  final BehaviorSubject<dynamic> controller;

  FormFieldState<bool> _currentState;
  StreamSubscription<dynamic> _subscription;

  InputDecoration _decoration;

  /// Create [RadioButtonFormFieldWidget] optionally using [onSaved], [validator],
  /// [initialValue], [onChange], [title] and [autoValidate].
  RadioButtonFormFieldWidget({
    Key key,
    @required this.controller,
    FormFieldSetter<bool> onSaved,
    FormFieldValidator<bool> validator,
    bool initialValue = false,
    ValueChanged<bool> onChanged,
    InputDecoration decoration,
    bool autoValidate = false,
    bool enabled = true,
    Color activeColor,
    Color activeTrackColor,
    Color inactiveThumbColor,
    Color inactiveTrackColor,
    ImageProvider inactiveThumbImage,
    ImageProvider activeThumbImage,
    bool isThreeLine = false,
    bool selected = false,
  }) : super(
          key: key,
          onSaved: onSaved,
          validator: validator,
          initialValue: initialValue,
          autovalidate: autoValidate,
          enabled: enabled,
          builder: (state) {
            var widget = (state.widget as RadioButtonFormFieldWidget);

            widget._currentState = state;

            var themeData = Theme.of(state.context);
            var effectiveDecoration = widget._decoration
                .copyWith(errorText: state.errorText, enabled: enabled)
                .applyDefaults(themeData.inputDecorationTheme);

            if (effectiveDecoration.errorStyle == null) {
              effectiveDecoration = effectiveDecoration.copyWith(
                errorStyle: TextStyle(color: themeData.errorColor),
              );
            }

            var titleWidget = Text(
              effectiveDecoration.labelText,
              style: state.hasError
                  ? effectiveDecoration.errorStyle
                  : effectiveDecoration.labelStyle,
            );

//            _log.finest(effectiveDecoration);

            var subtitleWidget = state.hasError
                ? Text(
                    effectiveDecoration.errorText,
                    style: effectiveDecoration.errorStyle,
                  )
                : effectiveDecoration.helperText == null
                    ? null
                    : Text(
                        effectiveDecoration.helperText,
                        style: effectiveDecoration.helperStyle,
                      );

            return SwitchListTile(
              activeColor: activeColor,
              activeThumbImage: activeThumbImage,
              activeTrackColor: activeTrackColor,
              inactiveThumbColor: inactiveThumbColor,
              inactiveThumbImage: inactiveThumbImage,
              inactiveTrackColor: inactiveTrackColor,
              isThreeLine: isThreeLine ?? false,
              selected: selected ?? false,
              contentPadding: effectiveDecoration.contentPadding,
              dense: effectiveDecoration.isDense,
              value: state?.value ??
                  widget?.controller?.value ??
                  initialValue ??
                  false,
              title: titleWidget,
              subtitle: subtitleWidget,
              secondary: effectiveDecoration.icon,
              onChanged: (value) {
                state.didChange(value);

                if (value != controller.value) {
                  controller.add(value);
                }

                if (onChanged != null) {
                  onChanged(value);
                }
              },
            );
          },
        ) {
    if (_subscription != null) {
      _subscription.cancel();
      _subscription = null;
    }

    _subscription = controller.stream.listen((value) {
      if (_currentState?.value != value) {
        _currentState?.didChange(value);
      }
    });

    _decoration = (decoration ?? InputDecoration());
  }
}
