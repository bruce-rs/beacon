import 'package:beacon/base/data/storage/app_storage.dart';
import 'package:beacon/base/router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sdk_helpers/sdk_helpers.dart';

abstract class BaseController extends GetxController with LoggerMixin {
  @protected
  String get _effectiveTag => tag ?? runtimeType.toString();

  String? get tag => null;

  bool isInitialized = false;

  AppRouter get router => AppRouter.to;

  AppStorage get storage => AppStorage.to;

  final RxBool loading = RxBool(false);
  bool get isLoading => loading.value;

  @override
  onInit() {
    super.onInit();
    log('Initialized', name: _effectiveTag);
  }

  @override
  void onReady() {
    super.onReady();
    log('Ready', name: _effectiveTag);
  }

  @override
  void onClose() {
    super.onClose();
    log('Closed', name: _effectiveTag);
  }

  @mustCallSuper
  void onError(Object? error, StackTrace? stackTrace) {
    e('Error: $error', name: _effectiveTag, error: error, stackTrace: stackTrace);
  }

  void showError(String message, {BuildContext? context}) {
    log('Error: $message', name: _effectiveTag);
    ScaffoldMessenger.of(
      context ?? AppRouter.to.appContext,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: Colors.red));
  }
}
