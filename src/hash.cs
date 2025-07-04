// Copyright (C) 2025 Tycho Softworks.
// This code is licensed under MIT license.

using System;
using System.Security.Cryptography;
using System.Buffers.Binary;
using System.Text;

namespace Tychosoft.Hashing {
public enum Algo {
    SHA256,
    SHA512,
    SHA2_256 = SHA256,
    SHA2_512 = SHA512,
    SHA3_256,
    SHA3_512,
}

public class Hash {
    private readonly Algo algo;

    public Hash(Algo algo) {
        this.algo = algo;
    }

    private byte[] Digest(string input) {
        byte[] data = Encoding.UTF8.GetBytes(input);
        return algo switch {
            Algo.SHA256   => SHA256.HashData(data),
            Algo.SHA512   => SHA512.HashData(data),
            Algo.SHA3_256 => SHA3_256.HashData(data),
            Algo.SHA3_512 => SHA3_512.HashData(data),
            _ => throw new NotSupportedException("Unsupported algorithm")
        };
    }

    public ulong ToUInt64(string input) {
        var digest = Digest(input);
        if (digest.Length < 8)
            throw new InvalidOperationException("Digest too short");
        return BitConverter.ToUInt64(digest, 0);
    }

    public uint ToUInt32(string input) => (uint)(ToUInt64(input) & 0xFFFFFFFF);

    public ulong ToBitRange(string input, uint range) {
        if (range is < 1 or > 64)
            throw new ArgumentOutOfRangeException(nameof(range));
        ulong mask = range == 64 ? ulong.MaxValue : (1UL << (int)range) - 1;
        return ToUInt64(input) & mask;
    }
}
} // end namespace

