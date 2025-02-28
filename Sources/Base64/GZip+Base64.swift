//
//  GZip+Base64.swift
//
//  The MIT License (MIT)
//
//  Copyright (c) 2019 Community Arch
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import Foundation
import CFoundation

/// Десериализации с Base64 c GZip
public protocol Base64GZipDecodable: Base64JSONDecoder {}

/// Сериализации с Base64 c GZip
public protocol Base64GZipEncodable: Base64JSONEncoder {}

/// Десериализации и сериализации с Base64 c GZip
public typealias Base64GZipCodable = Base64GZipDecodable & Base64GZipEncodable

// MARK: - KeyedDecodingContainer + Base64 c GZip
public extension KeyedDecodingContainer {
    
    func decode<T>(_ type: T.Type, forKey key: KeyedDecodingContainer<K>.Key) throws -> T where T: Base64GZipDecodable, T: Decodable {
        let string = try decode(String.self, forKey: key)
        guard
            let base64 = try Data(base64Encoded: string, options: [])?.gunzipped()
        else { throw Base64Error.decoding }
        return try T.decoder.decode(T.self, from: base64)
    }
}

// MARK: - KeyedEncodingContainer + Base64 c GZip
public extension KeyedEncodingContainer {
    
    mutating func encode<T>(_ object: T, forKey key: KeyedEncodingContainer<K>.Key) throws where T: Base64GZipEncodable, T: Encodable {
        let base64 = try T.encoder.encode(object).gzipped().base64EncodedString()
        try encode(base64, forKey: key)
    }
}
