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
import 'package:rxdart/rxdart.dart';

/// teste
@immutable
class SwitchFormFieldWidgetScope {
//  static final Logger _log = Logger("SwitchFormFieldWidgetScope");

  /// Key
  final Key key;

  /// Controller
  final BehaviorSubject<dynamic> controller;

  /// Decoration
  final InputDecoration decoration;

  final FormFieldSetter<bool> onSaved;
  final FormFieldValidator<bool> validator;
  final ValueChanged<bool> onChanged;
  final bool initialValue;
  final bool autoValidate;
  final bool enabled;

  final Color activeColor;
  final bool isThreeLine;
  final bool selected;
  final ImageProvider activeThumbImage;
  final Color activeTrackColor;
  final Color inactiveThumbColor;
  final ImageProvider inactiveThumbImage;
  final Color inactiveTrackColor;

  /// Create [SwitchFormFieldWidgetScope] optionally using [onSaved], [validator],
  /// [initialValue], [onChange], [title] and [autoValidate].
  SwitchFormFieldWidgetScope({
    this.key,
    @required this.controller,
    this.onSaved,
    this.validator,
    this.initialValue = false,
    this.onChanged,
    this.decoration,
    this.autoValidate = false,
    this.enabled = true,
    this.activeColor,
    this.activeThumbImage,
    this.activeTrackColor,
    this.inactiveThumbColor,
    this.inactiveThumbImage,
    this.inactiveTrackColor,
    this.isThreeLine = false,
    this.selected = false,
  })  : assert(key != null),
        assert(controller != null),
        super() {
    controller.stream.listen((value) {
      if (currentKey.currentState?.value != value) {
        currentKey.currentState?.didChange(value);
      }
    });
  }

  GlobalKey<FormFieldState<bool>> get currentKey => key;

  Widget builder(FormFieldState<bool> state) {
    var themeData = Theme.of(state.context);
    var effectiveDecoration = (decoration ??
            InputDecoration(
              contentPadding: Theme.of(state.context)
                      ?.inputDecorationTheme
                      ?.contentPadding ??
                  EdgeInsets.only(left: 16, right: 16),
            ))
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
      value: state?.value ?? controller?.value ?? initialValue ?? false,
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
  }
}
