//
//  Models.swift
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

/// Любой ответ любого запроса
public typealias Response = Model & Decodable

/// Любые параметры любого запроса
public typealias Parameters = Model & Encodable

/// Любые параметры/ответ любого запроса
public typealias UniversalModel = Model & Codable

/// Любой ответ любого запроса в виде массива
public typealias CollectionResponse = Response & CollectionRepresented

/// Любые параметры любого запроса в виде массива
public typealias CollectionParameters = Parameters & CollectionRepresented

/// Протокол представления объекта модели в виде массива
public protocol CollectionRepresented: Collection {

    /// Тип элемента массива
    associatedtype Item: Any

    /// Массив объектов модели
    var list: [Item] { get }
}

// MARK: - CollectionRepresented + Model
extension CollectionRepresented where Item: Model, Index == Int {

    public var startIndex: Int {
        list.startIndex
    }

    public var endIndex: Int {
        list.endIndex
    }

    public func index(after i: Int) -> Int {
        list.index(after: i)
    }

    public subscript(_ index: Index) -> Item {
        list[index]
    }
}

/// Протокол реализующий логику парсинга дефолтное значение для энематоров
public protocol RawResponse: Response, RawRepresentable {

    /// Дефолтное значение
    static var `default`: Self { get }

    /// Инициализация с помощью первоначальнего значения
    /// если значение не известное возвращается дефолтное значение
    /// - Parameter rawValue: Значение первоначальное
    init(try rawValue: RawValue)
}

// MARK: - RawResponse + Default
public extension RawResponse {

    init(try rawValue: RawValue) {
        if let result = Self.init(rawValue: rawValue) {
            self = result
        } else {
            self = .default
        }
    }

    init?(_ rawValueOrNil: RawValue?) {
        guard let rawValueOrNil = rawValueOrNil else { return nil }
        self.init(rawValue: rawValueOrNil)
    }
}

// MARK: - RawResponse + Response
public extension RawResponse where RawValue: Response {

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(RawValue.self)
        if let result = Self.init(rawValue: rawValue) {
            self = result
        } else {
            self = .default
        }
    }
}

/// Протокол создание объекта моделий через билдер
public protocol ParametersBuilder: AnyObject {

    /// Создание объекта моделий через билдер
    func build<ParametersType>() throws -> ParametersType where ParametersType: Parameters
}

/// Пустой обеъкт мадели
public struct Empty: UniversalModel {

    public init() {}

    public init(from decoder: Decoder) throws {
        var container = try decoder.unkeyedContainer()
        guard
            try container.decodeIfPresent([String: String].self) == nil
        else { throw NetworkError.parsing(Data()) }
        guard
            let response = try container.decodeIfPresent(String.self), response.isEmpty
        else { throw NetworkError.parsing(Data()) }
    }
}
