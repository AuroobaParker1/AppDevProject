// Copyright (c) 2013-present, the authors of the Pointy Castle project
// This library is dually licensed under LGPL 3 and MPL 2.0.
// See file LICENSE for more information.

library pointycastle.impl.secure_random.test.src.fixed_secure_random;

import "package:pointycastle/api.dart";
import "package:pointycastle/src/impl/secure_random_base.dart";
import "package:pointycastle/src/registry/registry.dart";

class FixedSecureRandom extends SecureRandomBase {
  static final FactoryConfig FACTORY_CONFIG =
      new StaticFactoryConfig(SecureRandom, "Fixed", () => FixedSecureRandom());

  var _next = 0;
  var _values;

  String get algorithmName => "Fixed";

  /// Set the fixed values to use and reset to the beginning of it.

  void seed(covariant KeyParameter params) {
    _values = params.key; // set the values to use (could be null or empty)
    _next = 0; // reset to the beginning of the values
  }

  int nextUint8() {
    if (_values != null && _values.isNotEmpty) {
      if (_next >= _values.length) {
        _next = 0; // reset to beginning of the array
      }
      return _values[_next++];
    } else {
      return 0; // value when not set with any values
    }
  }
}