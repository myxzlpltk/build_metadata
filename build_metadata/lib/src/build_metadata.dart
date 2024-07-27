import 'dart:convert';
import 'dart:developer';

import 'package:async/async.dart';
import 'package:flutter/services.dart';

///
abstract final class BuildMetadata {
  /// Memoizer to cache the metadata
  static final _memoizer = AsyncMemoizer<Map<String, String>>();

  /// Get the metadata
  static Future<Map<String, String>> getMetadata() =>
      _memoizer.runOnce(() async {
        try {
          // Prepare metadata
          final metadata = <String, String>{};
          // Load metadata
          final content = await rootBundle.loadString('packages/build_metadata/assets/metadata.json');
          final data = json.decode(content);
          // Add metadata
          if (data is Map<String, dynamic>) {
            for (final entry in data.entries) {
              metadata[entry.key] = entry.value.toString();
            }
          }
          // Return metadata
          return metadata;
        } catch (e, st) {
          log('BuildMetadata', error: e, stackTrace: st);
          return <String, String>{};
        }
      });

  /// Get value
  static Future<String> _getValue(String key) =>
      getMetadata().then((value) => value[key] ?? '');

  /// Get epoch
  static Future<DateTime> _getDateTime(String key) => getMetadata()
      .then((value) => int.tryParse(value[key] ?? '0') ?? 0)
      .then(DateTime.fromMillisecondsSinceEpoch);

  /// Get branch name
  static Future<String> get branchName => _getValue('branchName');

  /// Get last commit date
  static Future<DateTime> get lastCommitDate => _getDateTime('lastCommitDate');

  /// Get build date
  static Future<DateTime> get buildDate => _getDateTime('buildDate');

  /// Get hash
  static Future<String?> get hash => _getValue('hash');

  /// Get short hash
  static Future<String?> get hashShort => _getValue('hashShort');
}
