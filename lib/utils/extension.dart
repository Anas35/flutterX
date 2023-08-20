import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_x/utils/expection.dart';

const _defaultMessage = "Something went wrong, please try again";

extension CustomAsync<T> on AsyncValue<T> {
  Widget withDefault({required Widget Function(T) data}) {
    return when(
      data: data,
      error: (error, stk) {
        return Center(
          child: Text(error is FlutterXException ? error.message ?? _defaultMessage : error.toString()),
        );
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Widget withSliverDefault({required Widget Function(T) data}) {
    return when(
      data: data,
      error: (error, stk) {
        return SliverToBoxAdapter(
          child: Center(
            child: Text(error is FlutterXException ? error.message ?? _defaultMessage : error.toString()),
          ),
        );
      },
      loading: () {
        return const SliverToBoxAdapter(
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void handleListen({
    required void Function() data, 
    required void Function(String) error,
  }) {
    whenOrNull(
      error: (err, _) {
        final message = err is FlutterXException ? err.message ?? _defaultMessage : _defaultMessage;
        error(message);
      },
      data: (value) {
        if (value is bool && value) {
          data();
        }
      },
    );
  }
}

extension Context on BuildContext {
  void snackbar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.red,
    ));
  }
}

