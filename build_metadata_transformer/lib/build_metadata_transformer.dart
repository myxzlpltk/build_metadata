import 'dart:io';

/// Get the current branch name
Future<String?> getBranchName() => exec(['git', 'branch', '--show-current']);

/// Get the last commit date
Future<String?> getLastCommitDate() =>
    exec(['git', '--no-pager', 'log', '-1', '--format="%ct"']);

/// Get the hash of the current commit
Future<String?> getHash() => exec(['git', 'rev-parse', 'HEAD']);

/// Get the short hash of the current commit
Future<String?> getHashShort() => exec(['git', 'rev-parse', '--short', 'HEAD']);

/// Get current date and time
Future<String> getBuildDate() async =>
    DateTime.now().millisecondsSinceEpoch.toString();

/// Execute a command and return the output
Future<String?> exec(List<String> commands) async {
  try {
    final result = await Process.run(commands.first, commands.sublist(1));
    final output = result.stdout.toString().trim();
    return output.replaceAll('"', '').replaceAll("'", '');
  } catch (e) {
    return null;
  }
}
