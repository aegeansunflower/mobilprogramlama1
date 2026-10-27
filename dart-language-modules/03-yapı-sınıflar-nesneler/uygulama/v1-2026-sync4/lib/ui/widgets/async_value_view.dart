// DART KONUSU: Class modifiers — Riverpod'un `sealed class AsyncValue`
// hiyerarşisi üzerinde eksiksiz `switch` (AsyncData / AsyncError /
// AsyncLoading). Classes & objects — generics (`AsyncValueView<T>`).

/// Riverpod `AsyncValue` için yükleniyor / hata / veri görünümü.
library;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show AsyncData, AsyncError, AsyncLoading, AsyncValue;
import 'package:sarkisla_yoklama/ui/theme/tokens.dart';
import 'package:sarkisla_yoklama/ui/widgets/status.dart';

/// [value] durumuna göre içerik gösterir.
final class AsyncValueView<T> extends StatelessWidget {
  const AsyncValueView({
    required this.value,
    required this.data,
    this.onRetry,
    super.key,
  });

  final AsyncValue<T> value;
  final Widget Function(T data) data;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) => switch (value) {
    AsyncData(:final value) => data(value),
    AsyncError(:final error) => Padding(
      padding: const EdgeInsets.all(Space.lg),
      child: ErrorBanner(
        '${context.l10n.genericError}: $error',
        onRetry: onRetry,
      ),
    ),
    AsyncLoading() => const Padding(
      padding: EdgeInsets.all(Space.xxl),
      child: Center(child: CircularProgressIndicator()),
    ),
  };
}
