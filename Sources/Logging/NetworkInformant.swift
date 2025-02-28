//
//  NetworkInformant.swift
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

import CFoundation
import Foundation

/// Логирование сетвых запросов
public protocol RequestLog: CustomCURLStringConvertible {

    /// Запрос
    var requestDescription: String { get }
}

/// Логирование сетвых ответов
public protocol ResponseLog: CustomCURLStringConvertible {

    /// Ответ
    var responseDescription: String { get }
}

// Объект реализующий логирование Network клиента
public final class NetworkInformant {

    private let logger: Logger
    private let tag = "Network"

    public init(logger: Logger) {
        self.logger = logger
    }

    public func log(request: RequestLog,
                    _ file: StaticString = #file,
                    _ function: StaticString = #function,
                    _ line: Int = #line) {
        logger.debug(with: tag, """
        Sending request {
            Description: \n\t\(request.requestDescription)
            CURL: \n\t\(request.curl)
        }
        """, file, function, line)
    }

    public func log(response: ResponseLog,
                    _ file: StaticString = #file,
                    _ function: StaticString = #function,
                    _ line: Int = #line) {
        logger.debug(with: tag, """
        Received response {
            Description: \n\t\(response.responseDescription)
            CURL: \n\t\(response.curl)

        }
        """, file, function, line)
    }
    
    public func logError(response: ResponseLog,
                         _ file: StaticString = #file,
                         _ function: StaticString = #function,
                         _ line: Int = #line) {
        logger.error(with: tag, """
        Received response {
            Description: \n\t\(response.responseDescription)
            CURL: \n\t\(response.curl)
        
        }
        """, file, function, line)
    }

    public func cancel(request: RequestLog,
                       _ file: StaticString = #file,
                       _ function: StaticString = #function,
                       _ line: Int = #line) {
        logger.debug(with: tag, """
        Cancel request {
            Description: \n\t\(request.requestDescription)
            CURL: \n\t\(request.curl)
        }
        """, file, function, line)
    }
    
    public func log(json data: Data,
                    _ file: StaticString = #file,
                    _ function: StaticString = #function,
                    _ line: Int = #line) {
        logger.json(data, file, function, line)
    }

    public func log(debug message: @autoclosure () -> Any,
                    _ file: StaticString = #file,
                    _ function: StaticString = #function,
                    _ line: Int = #line) {
        logger.debug(message(), file, function, line)
    }

    public func log(error message: @autoclosure () -> Any,
                    _ file: StaticString = #file,
                    _ function: StaticString = #function,
                    _ line: Int = #line) {
        logger.error(message(), file, function, line)
    }
}
