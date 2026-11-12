package ru.edu.redislite.core;

import java.util.Set;
import java.util.concurrent.ConcurrentHashMap;

public class KeyValueStore {
    private final ConcurrentHashMap<String, String> data = new ConcurrentHashMap<>();

    public void set(String key, String value) {
        if (key == null || key.isEmpty()) throw new IllegalArgumentException("key must not be null or empty");
        if (value == null) throw new IllegalArgumentException("value must not be null");
        data.put(key, value);
    }

    public String get(String key) {
        if (key == null || key.isEmpty()) throw new IllegalArgumentException("key must not be null or empty");
        return data.get(key);
    }

    public int del(String key) {
        if (key == null || key.isEmpty()) throw new IllegalArgumentException("key must not be null or empty");
        return data.remove(key) != null ? 1 : 0;
    }

    public boolean exists(String key) {
        if (key == null || key.isEmpty()) throw new IllegalArgumentException("key must not be null or empty");
        return data.containsKey(key);
    }

    public Set<String> keys() {
        return new java.util.HashSet<>(data.keySet());
    }
}
