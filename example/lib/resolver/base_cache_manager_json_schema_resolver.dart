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

// Created by Alex at 19/08/2020.

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

import '../json_schema_resolver.dart';

/// Default implementation of [BaseCacheManager] to
/// [BaseCacheManagerJsonSchemaResolver]
class JsonSchemaDefaultCacheManager extends BaseCacheManager {
  /// Cache key
  static const key = 'jsonSchemaDefaultCacheManager';

  static JsonSchemaDefaultCacheManager _instance;

  /// Create instance
  factory JsonSchemaDefaultCacheManager({
    Duration maxAgeCacheObject,
    int maxNrOfCacheObjects = 1000,
    FileService fileService,
  }) {
    _instance ??= JsonSchemaDefaultCacheManager._(
      maxAgeCacheObject: maxAgeCacheObject,
      maxNrOfCacheObjects: maxNrOfCacheObjects,
      fileService: fileService,
    );

    return _instance;
  }

  JsonSchemaDefaultCacheManager._({
    Duration maxAgeCacheObject,
    int maxNrOfCacheObjects = 1000,
    FileService fileService,
  }) : super(
          key,
          maxAgeCacheObject: maxAgeCacheObject,
          maxNrOfCacheObjects: maxNrOfCacheObjects,
          fileService: fileService,
        );

  @override
  Future<String> getFilePath() async {
    var directory = await getTemporaryDirectory();

    return path.join(directory.path, key);
  }
}

/// JsonSchema resolver abstract
class BaseCacheManagerJsonSchemaResolver extends JsonSchemaResolver {
  final JsonSchemaResolverStatistics _jsonSchemaResolverStatistics;
  final BaseCacheManager _baseCacheManager;

  /// create instance
  BaseCacheManagerJsonSchemaResolver(
    this._jsonSchemaResolverStatistics,
    this._baseCacheManager,
  );

  @override
  JsonSchemaResolverStatistics get jsonSchemaResolverStatistics =>
      _jsonSchemaResolverStatistics;

  @override
  Future<dynamic> requestSchemaData(Uri uri) async {
    final response = await _baseCacheManager.getSingleFile(uri.toString());

    if (response != null && response.existsSync()) {
      return response.readAsStringSync();
    }

    throw Exception("Error on request $uri: Failed to open file $response");
  }
}
