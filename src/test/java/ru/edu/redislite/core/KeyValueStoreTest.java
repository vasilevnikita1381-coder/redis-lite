package ru.edu.redislite.core;

import org.junit.jupiter.api.*;
import static org.junit.jupiter.api.Assertions.*;

class KeyValueStoreTest {
    private KeyValueStore store;
    @BeforeEach void setUp() { store = new KeyValueStore(); }

    @Test void setStoresValue() { store.set("a","1"); assertEquals("1", store.get("a")); }
    @Test void setOverwrites() { store.set("a","1"); store.set("a","2"); assertEquals("2", store.get("a")); }
    @Test void setNullValueThrows() { assertThrows(IllegalArgumentException.class, () -> store.set("a", null)); }
    @Test void getMissingReturnsNull() { assertNull(store.get("x")); }
    @Test void getEmptyKeyThrows() { assertThrows(IllegalArgumentException.class, () -> store.get("")); }
    @Test void delExistingReturnsOne() { store.set("k","v"); assertEquals(1, store.del("k")); }
    @Test void delMissingReturnsZero() { assertEquals(0, store.del("nope")); }
    @Test void existsTrue() { store.set("k","v"); assertTrue(store.exists("k")); }
    @Test void existsFalse() { assertFalse(store.exists("x")); }
    @Test void keysEmpty() { assertTrue(store.keys().isEmpty()); }
    @Test void keysContains() { store.set("a","1"); assertTrue(store.keys().contains("a")); }
}
