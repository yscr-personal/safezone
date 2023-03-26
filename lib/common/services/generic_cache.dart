import 'package:unb/common/services/protocols/i_cache.dart';

class CacheValue<V> {
  final V value;
  final DateTime timestamp;

  CacheValue(this.value, this.timestamp);
}

class GenericCache<K, V> implements ICache<K, V> {
  static const DEFAULT_CACHE_TIMEOUT_IN_SECONDS = 600;

  int _timeoutInSeconds;
  final Map<K, CacheValue<V>> _cache = {};

  GenericCache() : this.withTimeout(DEFAULT_CACHE_TIMEOUT_IN_SECONDS);

  GenericCache.withTimeout(final int timeoutInSeconds)
      : _timeoutInSeconds = timeoutInSeconds {
    clear();
  }

  @override
  void clear() {
    for (final entry in _cache.entries) {
      if (entry.value.timestamp.isBefore(
          DateTime.now().subtract(Duration(seconds: _timeoutInSeconds)))) {
        remove(entry.key);
      }
    }
  }

  @override
  bool containsKey(final K key) {
    return _cache.containsKey(key);
  }

  @override
  V? get(final K key) {
    clear();
    return containsKey(key) ? _cache[key]!.value : null;
  }

  @override
  void put(final K key, final V value) {
    _cache[key] = CacheValue(value, DateTime.now());
  }

  @override
  void remove(final K key) {
    _cache.remove(key);
  }
}
