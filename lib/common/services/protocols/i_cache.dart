abstract class ICache<K, V> {
  void clear();

  bool containsKey(K key);

  V? get(K key);

  void put(K key, V value);

  void remove(K key);
}
