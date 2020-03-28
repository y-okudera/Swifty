//
//  JSONFileReader.swift
//  SwiftyTests
//
//  Created by Yuki Okudera on 2020/03/28.
//  Copyright © 2020 Yuki Okudera. All rights reserved.
//

import Foundation

enum JSONFileReaderError: Error {
    case jsonFileNotFound
    case decodingError(Error)
    case others(Error)
}

final class JSONFileReader<T: Decodable> {
    
    private let jsonFileName: String
    private let decodeType: T.Type
    
    /// Init
    /// - Parameters:
    ///   - jsonFileName: JSONファイル名(xx.json)
    ///   - decodeType: Decodable Type
    init(jsonFileName: String, decodeType: T.Type) {
        self.jsonFileName = jsonFileName
        self.decodeType = decodeType
    }
    
    /// Decode a JSON file.
    func decode(handler: (Result<T, JSONFileReaderError>) -> ()) {
        do {
            let name = jsonFileName.deletingPathExtension
            let type = jsonFileName.pathExtension
            let bundle = Bundle(for: JSONFileReader<T>.self)
            guard let jsonFilePath = bundle.path(forResource: name, ofType: type) else {
                handler(.failure(.jsonFileNotFound))
                return
            }
            let jsonFileURL = URL(fileURLWithPath: jsonFilePath)
            let jsonData = try Data(contentsOf: jsonFileURL)
            
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            let decodedObject = try decoder.decode(decodeType, from: jsonData)
            handler(.success(decodedObject))
            
        } catch let decodingError as DecodingError {
            print("decodingError: \(decodingError)")
            handler(.failure(.decodingError(decodingError)))
        } catch let error {
            print("error: \(error)")
            handler(.failure(.others(error)))
        }
    }
}

private extension String {
    
    private var ns: NSString {
        return (self as NSString)
    }
    
    /// Get the file extension.
    var pathExtension: String {
        return ns.pathExtension
    }
    
    /// Delete the file extension.
    var deletingPathExtension: String {
        return ns.deletingPathExtension
    }
}

