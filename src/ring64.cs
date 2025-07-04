// Copyright (C) 2025 Tycho Softworks.
// This code is licensed under MIT license.

using System;
using System.Collections.Generic;
using System.Threading;

namespace Tychosoft.Hashing {
public class Ring64 {
    private readonly SortedDictionary<ulong, string> ring = new();
    private readonly ReaderWriterLockSlim rwlock = new();
    private readonly int vnodes = 100;
    private readonly Hash hash;
    private long count = 0;

    public Ring64(Algo algo, int vnodes = 100) {
        this.hash = hash ?? throw new ArgumentNullException(nameof(hash));
        this.vnodes = vnodes;
    }

    public long Count() {
        return Interlocked.Read(ref count);
    }

    public bool Insert(string node) {
        bool inserted = false;
        rwlock.EnterWriteLock();
        try {
            for (int i = 0; i < vnodes; ++i) {
                string vnode = $"{node}#{i}";
                ulong index = hash.ToUInt64(vnode);
                if (!ring.ContainsKey(index)) {
                    ring[index] = node;
                    inserted = true;
                }
            }
        } finally {
            rwlock.ExitWriteLock();
        }
        if (inserted) {
            Interlocked.Increment(ref count);
        }
        return inserted;
    }

    public bool Remove(string node) {
        bool removed = false;
        rwlock.EnterWriteLock();
        try {
            for (int i = 0; i < vnodes; ++i) {
                string vnode = $"{node}#{i}";
                ulong index = hash.ToUInt64(vnode);
                if (ring.TryGetValue(index, out string? stored) && stored == node) {
                    ring.Remove(index);
                    removed = true;
                }
            }
        } finally {
            rwlock.ExitWriteLock();
        }
        if(removed)
            Interlocked.Decrement(ref count);
        return removed;
    }

    public string Get(string key) {
        ulong index = hash.ToUInt64(key);
        rwlock.EnterReadLock();
        try {
            foreach (var kvp in ring) {
                if (kvp.Key >= index)
                    return kvp.Value;
            }
            return ring.Count > 0
                ? new List<string>(ring.Values)[0]
                : throw new InvalidOperationException("Ring is empty");
        } finally {
            rwlock.ExitReadLock();
        }
    }
}
} // end namespace

