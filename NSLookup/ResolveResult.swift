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
    var status: Status = .resolving
    
    enum Status: CustomStringConvertible {
        case success(address: String)
        case failed(message: String)
        case resolving
        
        var description: String {
            switch self {
            case .failed(let message):
                return NSLocalizedString("Failed: ", comment: "DNS查询失败") + message
            case .resolving:
                return NSLocalizedString("Resolving", comment: "DNS正在查询。")
            case .success(let address):
                return address
            }
        }
    }
    
    init?(domain: String) {
        guard domain.count != 0 else {
            return nil 
        }
        self.domain = domain
    }
    
    func resolve(using dnsServer: String) {
        let res = res_9_state.allocate(capacity: 1)
        setupDnsServer(res: res, dnsServer: dnsServer)
        guard let ip = queryIP(res: res, host: domain) else {
            self.status = .failed(message: NSLocalizedString("DNS Error.", comment: "获取dns错误提示信息。"))
            return
        }
        self.status = .success(address: ip)
    }
}
