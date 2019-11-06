import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

TextInputType parseKeyboardType(String keyboardTypeName) {
  switch (keyboardTypeName) {
    case 'datetime':
      return TextInputType.datetime;
    case 'emailAddress':
      return TextInputType.emailAddress;
    case 'multiline':
      return TextInputType.multiline;
    case 'number':
      return TextInputType.number;
    case 'phone':
      return TextInputType.phone;
    case 'text':
      return TextInputType.text;
    case 'url':
      return TextInputType.url;
  }

  return null;
}

Brightness parseKeyboardAppearance(String keyboardAppearance) {
  switch (keyboardAppearance) {
    case 'dark':
      return Brightness.dark;
    case 'light':
      return Brightness.light;
  }

  return null;
}

TextCapitalization parseTextCapitalization(String textCapitalization) {
  switch (textCapitalization) {
    case 'characters':
      return TextCapitalization.characters;
    case 'none':
      return TextCapitalization.none;
    case 'sentences':
      return TextCapitalization.sentences;
    case 'words':
      return TextCapitalization.words;
  }

  return null;
}

TextInputAction parseTextInputAction(String textInputAction) {
  switch (textInputAction) {
    case 'none':
      return TextInputAction.none;
    case 'continueAction':
      return TextInputAction.continueAction;
    case 'done':
      return TextInputAction.done;
    case 'emergencyCall':
      return TextInputAction.emergencyCall;
    case 'go':
      return TextInputAction.go;
    case 'join':
      return TextInputAction.join;
    case 'newline':
      return TextInputAction.newline;
    case 'next':
      return TextInputAction.next;
    case 'previous':
      return TextInputAction.previous;
    case 'route':
      return TextInputAction.route;
    case 'search':
      return TextInputAction.search;
    case 'send':
      return TextInputAction.send;
    case 'unspecified':
      return TextInputAction.unspecified;
  }

  return null;
}
