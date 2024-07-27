import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:build_metadata_transformer/build_metadata_transformer.dart';

const inputOptionName = 'input';
const outputOptionName = 'output';

Future<int> main(List<String> arguments) async {
  // The flutter tool will invoke this program with two arguments, one for
  // the `--input` option and one for the `--output` option.
  // `--input` is the original asset file that this program should transform.
  // `--output` is where the transformation expected to be written.
  final parser = ArgParser()
    ..addOption(inputOptionName, mandatory: true, abbr: 'i')
    ..addOption(outputOptionName, mandatory: true, abbr: 'o');

  final argResults = parser.parse(arguments);
  final filePath = argResults.option(outputOptionName);
  if (filePath == null) {
    stderr.writeln('Missing required argument: $outputOptionName');
    return 2;
  }

  try {
    // Run all futures
    final futures = <Future<String?>>[
      getBranchName(),
      getLastCommitDate(),
      getHash(),
      getHashShort(),
      getBuildDate(),
    ];

    // Get all values
    final [
      branchName,
      lastCommitDate,
      hash,
      hashShort,
      buildDate,
    ] = await Future.wait(futures);

    // Generate the content
    final content = {
      'branchName': branchName,
      'lastCommitDate': lastCommitDate,
      'hash': hash,
      'hashShort': hashShort,
      'buildDate': buildDate,
    };
    final json = jsonEncode(content);

    // Write file
    final file = File(filePath);
    await file.writeAsString(json, flush: true);

    return 0;
  } catch (e) {
    // The flutter command line tool will see a non-zero exit code
    // and fail the build. Anything written to stderr by the asset transformer
    // will be surfaced by flutter.
    stderr.writeln(
      'Unexpected exception when metadata.\n'
      'Details: $e',
    );
    return 1;
  }
}
