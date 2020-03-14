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

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:json_schema/json_schema.dart';
import 'package:schema_form/bloc/json_schema_bl.dart';

/// [enum] type of location where files are stored.
enum FileLocate {
  /// Asset folder of project.
  asset,

  /// Storage of cell phone.
  storage,

  /// URL of file.
  url,
}

/// Load [JsonSchema] from [FileLocate]
Future loadSchemasFrom(BuildContext context, FileLocate fileLocate,
    JsonSchemaBloc jsonSchemaBloc) {
  var loads = <Future>[];

  loads.add(loadJsonFrom(context, fileLocate, "testLayoutSchema.json").then(
      (layoutSchema) =>
          jsonSchemaBloc.add(LoadLayoutSchemaEvent(layout: layoutSchema))));

  loads.add(loadJsonFrom(context, fileLocate, "testDataSchema.json").then(
      (jsonMap) => jsonSchemaBloc.add(
          LoadDataSchemaEvent(dataSchema: JsonSchema.createSchema(jsonMap)))));

  loads.add(loadJsonFrom(context, fileLocate, "testDataValue.json")
      .then((dataValue) => jsonSchemaBloc.add(LoadDataEvent(data: dataValue))));

  return Future.wait(loads);
}

/// Load JSON from [FileLocate]
Future<Map<String, dynamic>> loadJsonFrom(
    BuildContext context, FileLocate fileLocate, String fileName) async {
  switch (fileLocate) {
    case FileLocate.asset:
      return await loadJsonFromAsset(context, 'assets/$fileName');
    case FileLocate.storage:
      return await loadJsonFromStorage(
          context, '/storage/emulated/0/Json/files/$fileName');
    case FileLocate.url:
      return await loadJsonFromUrl(context,
          'https://legytma-platform-open-api-back.herokuapp.com/schema/mongo/$fileName');
    default:
      throw "Não implementado!";
  }
}

/// Load JSON from Asset.
Future<Map<String, dynamic>> loadJsonFromAsset(
    BuildContext context, String filePath) async {
//    print("filePath: $filePath");

  var content = await DefaultAssetBundle.of(context).loadString(filePath);

//    print("content: $content");

  Map<String, dynamic> jsonMap = json.decode(content);

  return jsonMap;
}

/// Load JSON from cell phone storage.
Future<Map<String, dynamic>> loadJsonFromStorage(
    BuildContext context, String filePath) async {
//    print("filePath: $filePath");

  var file = File(filePath);

  if (file.existsSync()) {
    var content = file.readAsStringSync();

//      print("content: $content");

    Map<String, dynamic> jsonMap = json.decode(content);

    return jsonMap;
  }

  throw "File not found!";
}

/// Load JSON from URL.
Future<Map<String, dynamic>> loadJsonFromUrl(
    BuildContext context, String filePath) async {
//    print("filePath: $filePath");

  var username = '';
  var password = '';
  var basicAuth = 'Basic ${base64Encode(utf8.encode('$username:$password'))}';
//    print('basicAuth: $basicAuth');

  var response = await http.get(Uri.encodeFull(filePath), headers: {
    "Accept": "application/json",
    "Authorization": basicAuth,
  });

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonMap = json.decode(response.body);

    return jsonMap;
  }

  throw "${response.statusCode} - ${response.reasonPhrase}: ${response.body}";
}
