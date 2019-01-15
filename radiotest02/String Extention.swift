//
//  String Extention.swift
//  radiotest02
//
//  Created by Kerolles Roshdi on 12/25/18.
//  Copyright © 2018 Kerolles Roshdi. All rights reserved.
//

import Foundation

extension String {
    var htmlDecoded: String {
        let decoded = try? NSAttributedString(data: Data(utf8), options: [
            .documentType: NSAttributedString.DocumentType.html,
            .characterEncoding: String.Encoding.utf8.rawValue
            ], documentAttributes: nil).string
        
        return decoded ?? self
    }
}
