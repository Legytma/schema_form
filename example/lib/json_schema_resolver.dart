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

// ignore_for_file: implementation_imports

import 'package:json_schema/json_schema.dart';
import 'package:json_schema/src/json_schema/utils.dart';
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

/// Class used to collect statistics
class JsonSchemaResolverStatistics {
  final Logger _log = Logger("JsonSchemaResolverStatistics");

  final BehaviorSubject<JsonSchemaResolverStatistics> _controller =
      BehaviorSubject<JsonSchemaResolverStatistics>();

  final List<String> _urls = <String>[];
  final List<String> _cached = <String>[];
  final List<String> _parentCached = <String>[];
  final List<String> _fetched = <String>[];
  final List<String> _failed = <String>[];

  final List<String> _transactions = <String>[];
  final List<String> _cachedTransactions = <String>[];
  final List<String> _uniqueTransactions = <String>[];

  final DateTime _started = DateTime.now();

  DateTime _lastNotify;

  void _notify() {
    _controller.add(this);

    _lastNotify = DateTime.now();
  }

  void _addTransaction(String transaction) {
    _log.info("addTransaction: $transaction");
    _transactions.add(transaction);

    _notify();
  }

  void _addCachedTransaction(String transaction) {
    _log.info("addCachedTransaction: $transaction");
    _cachedTransactions.add(transaction);

    _notify();
  }

  void _addUniqueTransaction(String transaction) {
    _log.info("addUniqueTransaction: $transaction");
    _uniqueTransactions.add(transaction);

    _notify();
  }

  void _addUrl(String url) {
    _log.info("addUrl: $url");
    _urls.add(url);

    _notify();
  }

  void _addCache(String url) {
    _log.info("addCache: $url");
    _cached.add(url);

    _notify();
  }

  void _addParentCache(String url) {
    _log.info("addParentCache: $url");
    _parentCached.add(url);

    _notify();
  }

  void _addFetch(String url) {
    _log.info("addFetch: $url");
    _fetched.add(url);

    _notify();
  }

  void _addFailed(String url) {
    _log.info("addFailed: $url");
    _failed.add(url);

    _notify();
  }

  /// Get [JsonSchemaResolverStatistics] [Stream]
  Stream<JsonSchemaResolverStatistics> get stream =>
      _controller.asBroadcastStream();

  /// Get [Duration] between start and last change
  Duration get duration => _lastNotify.difference(_started);

  /// Get transactions [List]
  List<String> get transactions => List<String>.unmodifiable(_transactions);

  /// Get cached transactions [List]
  List<String> get cachedTransactions =>
      List<String>.unmodifiable(_cachedTransactions);

  /// Get unique transactions [List]
  List<String> get uniqueTransactions =>
      List<String>.unmodifiable(_uniqueTransactions);

  /// Get urls [List]
  List<String> get urls => List<String>.unmodifiable(_urls);

  /// Get cached [List]
  List<String> get cached => List<String>.unmodifiable(_cached);

  /// Get parent cached [List]
  List<String> get parentCached => List<String>.unmodifiable(_parentCached);

  /// Get fetched [List]
  List<String> get fetched => List<String>.unmodifiable(_fetched);

  /// Get failed [List]
  List<String> get failed => List<String>.unmodifiable(_failed);

  /// Get transaction list length
  int get transactionCount => _transactions.length;

  /// Get cached transaction list length
  int get cachedTransactionCount => _cachedTransactions.length;

  /// Get unique transaction list length
  int get uniqueTransactionCount => _uniqueTransactions.length;

  /// Get url list length
  int get urlCount => _urls.length;

  /// Get cached list length
  int get cachedCount => _cached.length;

  /// Get parent cached list length
  int get parentCachedCount => _parentCached.length;

  /// Get fetched list length
  int get fetchedCount => _fetched.length;

  /// Get failed list length
  int get failedCount => _failed.length;

  /// Get conclusion percentage of transactions
  num get transactionValue =>
      (cachedCount + parentCachedCount + fetchedCount + failedCount) / urlCount;

  /// Get conclusion percentage of requests
  num get requestValue =>
      (cachedCount + parentCachedCount + fetchedCount + failedCount) / urlCount;

  @override
  String toString() {
    return "Transactions: $transactionCount, "
        "CachedTransactions: $cachedTransactionCount, "
        "UniqueTransactions: $uniqueTransactionCount, URLs: $urlCount, "
        "Cached: $cachedCount, ParentCached: $parentCachedCount, "
        "Fetched: $fetchedCount, Failed: $failedCount in $duration";
  }
}

/// JsonSchema resolver abstract
abstract class JsonSchemaResolver {
  /// Cache key name
  static const key = "JsonSchemaResolverCustomCache";

  final Map<String, Future<JsonSchema>> _transactions =
      <String, Future<JsonSchema>>{};

  final _cache = <String, JsonSchema>{};

  /// Get instance of current [JsonSchemaResolverStatistics]
  JsonSchemaResolverStatistics get jsonSchemaResolverStatistics;

  /// Create [JsonSchema] from [schemaUrl] and [schemaVersion]
  Future<JsonSchema> createSchemaFromUrl(String schemaUrl,
      {SchemaVersion schemaVersion}) {
    jsonSchemaResolverStatistics?._addTransaction(schemaUrl);

    Future<JsonSchema> result;

    if (_transactions.containsKey(schemaUrl)) {
      jsonSchemaResolverStatistics?._addCachedTransaction(schemaUrl);

      result = _transactions[schemaUrl];
    } else {
      result = _add(schemaUrl, schemaVersion: schemaVersion);

      _transactions[schemaUrl] = result;

      jsonSchemaResolverStatistics?._addUniqueTransaction(schemaUrl);
    }

    return result;
  }

  /// [JsonSchema] resolver from URL string
  Future<JsonSchema> _add(String schemaUrl,
      {SchemaVersion schemaVersion}) async {
    jsonSchemaResolverStatistics?._addUrl(schemaUrl);

    if (_cache.containsKey(schemaUrl)) {
      jsonSchemaResolverStatistics?._addCache(schemaUrl);

      return _cache[schemaUrl];
    }

    final uriWithFrag = Uri.parse(schemaUrl);
    final uri =
        schemaUrl.endsWith('#') ? uriWithFrag : uriWithFrag.removeFragment();
    final uriWithoutFragment = uri.toString();
    JsonSchema parentSchema;

    if (_cache.containsKey(uriWithoutFragment)) {
      jsonSchemaResolverStatistics?._addParentCache(uriWithoutFragment);

      parentSchema = _cache[uriWithoutFragment];
    } else {
      var schemaData = await requestSchemaData(uri);

      // HTTP servers / file systems ignore fragments, so resolve a sub-map if a fragment was specified.
      parentSchema = await JsonSchema.createSchemaAsync(schemaData,
          schemaVersion: schemaVersion, fetchedFromUri: uri);

      if (parentSchema != null) {
        jsonSchemaResolverStatistics?._addFetch(uriWithoutFragment);

        _cache[uriWithoutFragment] = parentSchema;
      } else {
        jsonSchemaResolverStatistics?._addFailed(uriWithoutFragment);
      }
    }

    final schema =
        JsonSchemaUtils.getSubMapFromFragment(parentSchema, uriWithFrag);

    if (schema != null) {
      _cache[schemaUrl] = schema;
    }

    return schema ?? parentSchema;
  }

  /// Request schema data from URI
  Future<dynamic> requestSchemaData(Uri uri);
}
