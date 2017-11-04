//
//  ResolveResult.swift
//  NSLookup
//
//  Created by 王宇 on 2017/6/19.
//  Copyright © 2017年 Putotyra. All rights reserved.
//

import Foundation

class ResolveResult {
    let domain: String
    var address: String?
    var status: Status = .resolving
    
    enum Status: CustomStringConvertible {
        case success
        case failed
        case resolving
        
        var description: String {
            switch self {
            case .failed:
                return "Failed"
            case .resolving:
                return "Resolving"
            case .success:
                return "Success"
            }
        }
    }
    
    init?(domain: String) {
        guard domain.count != 0 else {
            return nil 
        }
        self.domain = domain
    }
    
    func resolve(using dnsServer: String) throws {
        let res = res_9_state.allocate(capacity: 1)
        setupDnsServer(res: res, dnsServer: dnsServer)
        guard let ip = queryIP(res: res, host: domain) else {
            self.status = .failed
            throw NSError()
        }
        self.address = ip
        self.status = .success
    }
}
