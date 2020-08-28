import 'package:flutter/material.dart';
import 'package:json_schema/json_schema.dart';
import 'package:provider/provider.dart';

import 'schema_form.dart';

/// Schema Property Value Selector
class SchemaPropertyValueSelector<T> extends Selector<JsonSchema, T> {
  /// Value used on null
  final T defaultValue;

  /// Create instance
  SchemaPropertyValueSelector({
    Key key,
    @required String dataAddress,
    this.defaultValue,
    @required ValueWidgetBuilder<T> builder,
    ShouldRebuild<T> shouldRebuild,
    Widget child,
  })  : assert(dataAddress != null),
        super(
          key: key,
          shouldRebuild: shouldRebuild,
          builder: builder,
          selector: (selectorContext, value) {
            var addressList = dataAddress.split(".");
            Map<String, dynamic> schemaMap = value?.schemaMap;

            return _getSchemaValue(schemaMap, addressList, 0, defaultValue);
          },
          child: child,
        );

  static dynamic _getSchemaValue(
    Map<String, dynamic> schemaMap,
    List<String> addressList,
    int index,
    dynamic defaultValue,
  ) {
    if (schemaMap == null) {
      return defaultValue;
    }

    if (index < addressList.length - 1) {
      return _getSchemaValue(
            schemaMap[addressList[index]],
            addressList,
            index + 1,
            defaultValue,
          ) ??
          defaultValue;
    }

    return schemaMap[addressList[index]] ?? defaultValue;
  }
}
