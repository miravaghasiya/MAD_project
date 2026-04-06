import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'api_provider.dart';

final productListProvider =
    FutureProvider.autoDispose<List<dynamic>>((ref) async {
  final api = ref.watch(apiServiceProvider);
  return await api.fetchProducts();
});
