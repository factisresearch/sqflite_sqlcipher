# sqflite_sqlcipher

This is a fork from the plugin [sqflite](https://github.com/tekartik/sqflite).  **Up to date with version 1.1.7+3**

This fork adds an optional parameter "password" to open encrypted databases. Everything else behaves like the `sqflite` plugin, same API.

The SQLCipher version of the plugin is 4.10. If you try to open a database encrypted with a lower version of SQLCipher, the plugin will try to migrate it to a new version using the operation `PRAGMA cipher_migrate` (This automatic migration to version 4 is only done in Android. PR welcome for this feature in iOS).

### Install

To add it in your project include this in the `pubspec.yml`.
```
dependencies:
  sqflite: (whichever since it will be overriden with this fork)

dependency_overrides:
  sqflite:
    git:
      url: https://www.github.com/davidmartos96/sqflite_sqlcipher.git
      path: sqflite
      ref: 8f7a3899d3bd80090a8be2f68a0f285e753401e9
```
Dependency overrides are used to avoid conflict with other projects that depend on "normal" sqflite. For example https://github.com/renefloor/flutter_cache_manager

### iOS
**REQUIRED:** Include this in your iOS `Podfile`
```
pod 'SQLCipher', '~>4.1.0'
```
If you try to use a database encrypted with a SqlCipher version lower than 4, the version in the Podfile can be changed to a lower one `'~>3.4.2'`. But note that if doing that, the running database on Android will be version 4 (since it migrates automatically) and on iOS will be version 3.

### Android
If using ProGuard, add the following rules:
```
-keep class net.sqlcipher.** { *; }
-keep class net.sqlcipher.database.* { *; }
```

---

[![pub package](https://img.shields.io/pub/v/sqflite.svg)](https://pub.dev/packages/sqflite)
[![Build Status](https://travis-ci.org/tekartik/sqflite.svg?branch=master)](https://travis-ci.org/tekartik/sqflite)
[![codecov](https://codecov.io/gh/tekartik/sqflite/branch/master/graph/badge.svg)](https://codecov.io/gh/tekartik/sqflite)

SQLite plugin for [Flutter](https://flutter.io).
Supports both iOS and Android.

* Support transactions and batches
* Automatic version management during open
* Helpers for insert/query/update/delete queries
* DB operation executed in a background thread on iOS and Android

## Documentation

* [Documentation](https://github.com/tekartik/sqflite/blob/master/sqflite/README.md)
* [API reference](https://pub.dartlang.org/documentation/sqflite/latest/sqflite/sqflite-library.html)
* [How to](https://github.com/tekartik/sqflite/blob/master/sqflite/doc/how_to.md) guide
