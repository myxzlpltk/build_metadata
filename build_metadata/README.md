Welcome to `build_metadata`. This package utilize asset transformer to generate metadata for your project.
Therefore there is no platform specific code in this package.
This package is intended to be use with `build_metadata_transformer`

## Features

- Get build time
- Get git branch name
- Get git last commit date
- Get git last commit hash
- Get git last commit short hash

## Getting started

Add `build_metadata` to your `pubspec.yaml` file

```yaml
dependencies:
  build_metadata: latest_version
```

Add `build_metadata_transformer` to your `pubspec.yaml` file

```yaml
dev_dependencies:
  build_metadata_transformer: latest_version
```

## Usage

Get build time

```dart
import 'package:build_metadata/build_metadata.dart';

DateTime buildDate = await BuildMetadata.buildDate;
```
