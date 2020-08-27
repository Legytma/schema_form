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
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:intl/intl.dart';
import 'package:json_schema/json_schema.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

export 'schema_property_value_selector.dart';
export 'widget/control/schema/schema_form_widget.dart';
export 'widget/control/schema/state/schema_form_widget_state.dart';
export 'widget/control/schema/template/widget_template.dart';

/// Schema Form Layout Builder function type
typedef SchemaFormLayoutBuilder = Widget Function(
    BuildContext context, List<Widget> children);

/// Schema Form Layout Builder function type
typedef SchemaFormFieldBuilder = Widget Function(
    BuildContext context, String fieldName, JsonSchema fieldSchema);

/// Schema Form class
class SchemaForm extends StatelessWidget {
  final Logger _log = Logger("SchemaForm");

  /// Form Key
  final Key formKey;

  /// Schema
  final JsonSchema jsonSchema;

  /// Layout Builder
  final SchemaFormLayoutBuilder builder;

  final Function(Map<String, dynamic>) onChanged;
  final WillPopCallback onWillPop;
  final bool readOnly;
  final bool autovalidate;
  final Map<String, dynamic> initialValue;

  /// Map of Builders by Schema Type
  final Map<SchemaType, SchemaFormFieldBuilder> typeFieldBuilderMap;

  /// Map of Builders by Field Name
  final Map<String, SchemaFormFieldBuilder> fieldBuilderMap;

  /// Create instance
  SchemaForm({
    Key key,
    this.formKey,
    @required this.jsonSchema,
    this.builder,
    this.onChanged,
    this.onWillPop,
    this.readOnly = false,
    this.autovalidate = false,
    this.initialValue,
    this.typeFieldBuilderMap,
    this.fieldBuilderMap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Provider<SchemaForm>.value(
      value: this,
      child: FormBuilder(
        key: formKey,
        onChanged: onChanged,
        onWillPop: onWillPop,
        readOnly: readOnly,
        autovalidate: autovalidate,
        initialValue: _makeInitialValue(),
        child: builder == null
            ? Column(children: _makeFormFields(context))
            : builder(context, _makeFormFields(context)),
      ),
    );
  }

  List<Widget> _makeFormFields(BuildContext context) {
    var fields = <Widget>[];

    jsonSchema.properties.forEach((fieldName, fieldJsonSchema) {
      var fieldBuilder = _makeEditTextBuilder;

      if (fieldBuilderMap != null && fieldBuilderMap.containsKey(fieldName)) {
        fieldBuilder = fieldBuilderMap[fieldName];
      } else {
        try {
          var fieldType = fieldJsonSchema.type;

          if (typeFieldBuilderMap != null &&
              typeFieldBuilderMap.containsKey(fieldType)) {
            fieldBuilder = typeFieldBuilderMap[fieldType];
          } else {
            switch (fieldType) {
              case SchemaType.string:
                switch (fieldJsonSchema.format) {
                  case 'date-time':
                    fieldBuilder = _makeDateTimePickerBuilder;
                    break;
                  case 'uri':
                    break;
                  case 'uri-reference':
                    break;
                  case 'uri-template':
                    break;
                  case 'email':
                    break;
                  case 'ipv4':
                    break;
                  case 'ipv6':
                    break;
                  case 'hostname':
                    break;
                  case 'json-pointer':
                    break;
                  default:
                    fieldBuilder = _makeEditTextBuilder;
                }
                break;
              case SchemaType.number:
                fieldBuilder = _makeNumberTouchSpin;
                break;
              case SchemaType.integer:
                fieldBuilder = _makeIntegerTouchSpin;
                break;
              case SchemaType.boolean:
                fieldBuilder = _makeCheckboxBuilder;
                break;
              case SchemaType.boolean:
                fieldBuilder = _makeCheckboxBuilder;
                break;
            }
          }
          // ignore: avoid_catches_without_on_clauses
        } catch (e) {
          _log.severe("No field type found: $e", e);
        }
      }

      fields.add(Selector<SchemaForm, JsonSchema>(
        selector: (selectorContext, schemaForm) =>
            schemaForm.jsonSchema.properties[fieldName],
        builder: (buildContext, value, child) =>
            fieldBuilder(buildContext, fieldName, fieldJsonSchema),
      ));
      // fields.add(fieldBuilder(context, fieldName, fieldJsonSchema));
    });

    return fields;
  }

  Widget _makeEditTextBuilder(
      BuildContext context, String fieldName, JsonSchema fieldSchema) {
    return FormBuilderTextField(
      attribute: fieldName,
      decoration: InputDecoration(
        labelText:
            "${fieldSchema.title}${fieldSchema.requiredOnParent ? '*' : ''}",
        helperText: fieldSchema.description,
      ),
      validators: _getValidators(fieldSchema),
    );
  }

  Widget _makeDateTimePickerBuilder(
      BuildContext context, String fieldName, JsonSchema fieldSchema) {
    return FormBuilderDateTimePicker(
      attribute: fieldName,
      decoration: InputDecoration(
        labelText:
            "${fieldSchema.title}${fieldSchema.requiredOnParent ? '*' : ''}",
        helperText: fieldSchema.description,
      ),
    );
  }

  Widget _makeNumberTouchSpin(
      BuildContext context, String fieldName, JsonSchema fieldSchema) {
    return FormBuilderTouchSpin(
      attribute: fieldName,
      decoration: InputDecoration(
        labelText:
            "${fieldSchema.title}${fieldSchema.requiredOnParent ? '*' : ''}",
        helperText: fieldSchema.description,
      ),
      initialValue: 0,
      step: 1,
      min: -100,
      max: 100,
      validators: _getValidators(fieldSchema),
    );
  }

  Widget _makeIntegerTouchSpin(
      BuildContext context, String fieldName, JsonSchema fieldSchema) {
    return FormBuilderTouchSpin(
      attribute: fieldName,
      decoration: InputDecoration(
        labelText:
            "${fieldSchema.title}${fieldSchema.requiredOnParent ? '*' : ''}",
        helperText: fieldSchema.description,
      ),
      initialValue: 0,
      step: 1,
      min: -100,
      max: 100,
      validators: _getValidators(fieldSchema),
    );
  }

  Widget _makeCheckboxBuilder(
      BuildContext context, String fieldName, JsonSchema fieldSchema) {
    return FormBuilderCheckbox(
      attribute: fieldName,
      label: Text(
          "${fieldSchema.title}${fieldSchema.requiredOnParent ? '*' : ''}"),
      decoration: InputDecoration(
        labelText:
            "${fieldSchema.title}${fieldSchema.requiredOnParent ? '*' : ''}",
        helperText: fieldSchema.description,
      ),
      validators: _getValidators(fieldSchema),
    );
  }

  dynamic _makeInitialValue() {
    dynamic value =
        initialValue ?? jsonSchema.defaultValue ?? <String, dynamic>{};

    for (var propertyEntry in jsonSchema.properties.entries) {
      final fieldName = propertyEntry.key;

      if (!value.containsKey(fieldName)) {
        final fieldSchema = propertyEntry.value;
        final fieldDefaultValue = fieldSchema.defaultValue;

        if (fieldDefaultValue != null) {
          if (fieldSchema.typeList != null &&
              fieldSchema.type == SchemaType.string &&
              fieldSchema.format == 'date-time') {
            try {
              final dateTimeFormat = DateFormat("yyyy-MM-dd hh:mm:ss");

              value[fieldName] = dateTimeFormat.parse(fieldDefaultValue);
              // ignore: avoid_catches_without_on_clauses
            } catch (e) {
              try {
                final dateFormat = DateFormat("yyyy-MM-dd");

                value[fieldName] = dateFormat.parse(fieldDefaultValue);
                // ignore: avoid_catches_without_on_clauses
              } catch (e) {
                try {
                  final timeFormat = DateFormat("hh:mm:ss");

                  value[fieldName] = timeFormat.parse(fieldDefaultValue);
                  // ignore: avoid_catches_without_on_clauses
                } catch (e) {}
              }
            }
          } else {
            value[fieldName] = fieldDefaultValue;
          }
        } else if (fieldSchema.typeList != null) {
          switch (fieldSchema.type) {
            case SchemaType.boolean:
              value[fieldName] = false;
              break;

            case SchemaType.integer:
              value[fieldName] = 0;
              break;

            case SchemaType.number:
              value[fieldName] = 0.0;
              break;

            case SchemaType.string:
              if (fieldSchema.format == 'date-time') {
                value[fieldName] = DateTime.now();
              }
              break;
          }
        }
      }
    }

    return value;
  }

  String _jsonSchemaValidate(JsonSchema fieldSchema, dynamic value) {
    var messages;
    var validationErrors = fieldSchema.validateWithErrors(value);

    if (validationErrors != null && validationErrors.length > 0) {
      for (var validationError in validationErrors) {
        var validationErrorMessage = validationError.message;
        final valueString = "$value";
        const gotString = " got ";

        if (valueString.trim().isNotEmpty &&
            validationErrorMessage != null &&
            validationErrorMessage.endsWith(valueString)) {
          validationErrorMessage = validationErrorMessage.substring(
              0, validationErrorMessage.length - valueString.length);
        }

        if (validationErrorMessage != null &&
            validationErrorMessage.endsWith(gotString)) {
          validationErrorMessage = validationErrorMessage.substring(
              0, validationErrorMessage.length - gotString.length);
        }

        if (messages == null) {
          messages = "";
        } else {
          messages = "\n";
        }

        messages = "$messages$validationErrorMessage";
      }
    }

    return messages;
  }

  List<dynamic> _getValidators(JsonSchema fieldSchema) {
    var validators = [
      (value) => _jsonSchemaValidate(fieldSchema, value),
    ];

    if (fieldSchema.requiredOnParent) {
      validators.add(FormBuilderValidators.required());
    }

    return validators;
  }
}
