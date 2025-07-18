// ignore_for_file: empty_catches

import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/material.dart';
import 'package:swap_controller/ffi/swap_controller_native.dart';

/// By Azkadev
class SwapControllerClientFlutter {
  SwapControllerNativeLibrary _swapControllerNativeLibrary = SwapControllerNativeLibrary(DynamicLibrary.process());

  /// By Azkadev
  static SwapControllerClientFlutter swapControllerClientFlutter = SwapControllerClientFlutter();

  static NativeCallable<Void Function(Pointer<Char>)> _initializedAzkadevGamePadNativeGeneralUniverseCallbackFunction({
    required SwapControllerClientFlutter swapControllerClientFlutter,
  }) {
    return NativeCallable<Void Function(Pointer<Char>)>.listener((Pointer<Char> raw) {
      try {
        final valueRaw = raw.cast<Utf8>();
        final value = valueRaw.toDartString();
        if (value.isNotEmpty) {
          // final Map updateRaw = json.decode(value);
        }
        try {
          malloc.free(valueRaw);
        } catch (e) {}
      } catch (e) {}
    });
  }

  /// By Azkadev
  void ensureIntiialied() {
    WidgetsFlutterBinding.ensureInitialized();
    if (Platform.isLinux) {
      _swapControllerNativeLibrary = SwapControllerNativeLibrary(DynamicLibrary.open("libgamepadazkadev.so"));
      _swapControllerNativeLibrary.InitializedAzkadevGamePadNativeGeneralUniverseCallbackFunction(
        Pointer.fromAddress(
          SwapControllerClientFlutter._initializedAzkadevGamePadNativeGeneralUniverseCallbackFunction(
            swapControllerClientFlutter: this,
          ).nativeFunction.address,
        ),
      );
    }
  }

  /// By Azkadev
  Map invokeRaw(Map parameters) {
    try {
      final Pointer<Char> parametersNativeChar = json.encode(parameters).toNativeUtf8().cast<Char>();
      final rawValueNativeUtf8 = _swapControllerNativeLibrary.InvokeAzkadevGamePadNativeFunction(parametersNativeChar).cast<Utf8>();
      final Map result = json.decode(rawValueNativeUtf8.toDartString());
      malloc.free(parametersNativeChar);
      malloc.free(rawValueNativeUtf8);
      return result;
    } catch (e) {
      return {
        "@type": "error",
        "message": "crash",
      };
    }
  }

  /// By Azkadev
  Map invoke(Map parameters) {
    return invokeRaw(
      parameters,
    );
  }
}
