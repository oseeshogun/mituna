import 'package:hive_flutter/hive_flutter.dart';

class HiveKey<T, BoxType> {
  HiveKey(this.key, {this.defaultValue, this.defaultBox});

  final String key;
  final T? defaultValue;
  final Box<BoxType>? defaultBox;

  T? value([Box? box]) {
    return (box ?? defaultBox)?.get(key, defaultValue: defaultValue) as T ??
        defaultValue;
  }

  put(T? value, [Box? box]) {
    (box ?? defaultBox)?.put(key, value);
    return value;
  }

  T? reset([Box? box]) {
    (box ?? defaultBox)?.put(key, defaultValue);
    return defaultValue;
  }

  delete([Box? box]) {
    (box ?? defaultBox)?.delete(key);
  }

  @override
  String toString() {
    return key.toString();
  }

  @override
  bool operator ==(Object other) =>
      other is HiveKey<T, BoxType> && other.key == key;

  @override
  int get hashCode => key.hashCode;
}
