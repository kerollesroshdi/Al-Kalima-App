//
//  LiveInfo.swift
//  radiotest02
//
//  Created by Kerolles Roshdi on 12/25/18.
//  Copyright © 2018 Kerolles Roshdi. All rights reserved.
//

import Foundation

func getLiveInfo(completion: @escaping (_ current :String, _ next :String) -> ()){
    print("Live Info :")
    let jsonUrlString = "http://broadcast.alkalima.net/api/live-info/?callback"
    guard let url = URL(string: jsonUrlString) else { return }
    
    URLSession.shared.dataTask(with: url){(data ,response,err) in
        guard let data = data else { return }
        do {
            let liveInfo = try JSONDecoder().decode(LiveInfo.self, from: data)
            print("Next: ", liveInfo.next.name)
            print("Current: ", liveInfo.current?.name ?? "OFF LINE")
            completion(liveInfo.current?.name ?? "OFF LINE", liveInfo.next.name)
        } catch let jsonErr {
            print("Error: ", jsonErr)
        }
    }.resume()
    
}


struct LiveInfo: Decodable {
    let next: Track
    let current: Track?
    
}

struct Track: Decodable {
    let name: String
}
