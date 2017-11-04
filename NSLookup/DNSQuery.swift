//
//  DNSQuery.swift
//  NSLookup
//
//  Created by 王宇 on 2017/2/22.
//  Copyright © 2017年 Putotyra. All rights reserved.
//

import Foundation

func resolve(host: String, using dnsServer: String) -> String? {
	let res = res_9_state.allocate(capacity: 1)
	setupDnsServer(res: res, dnsServer: dnsServer)
	return queryIP(res: res, host: host)
}

func queryIP(res: res_9_state, host: String) -> String? {
	let answer = UnsafeMutablePointer<u_char>.allocate(capacity: Int(NS_PACKETSZ))
	let len = res_9_nquery(res, host, Int32(ns_c_in.rawValue), Int32(ns_t_a.rawValue), answer, NS_PACKETSZ)
	var handle = res_9_ns_msg()
	res_9_ns_initparse(answer, len, &handle)
	
	if handle._counts.1 > 0 {
		var rr = res_9_ns_rr()
		if res_9_ns_parserr(&handle, ns_s_an, 0, &rr) == 0 {
			return rr.rdata.withMemoryRebound(to: in_addr.self, capacity: 1, { (p) -> String in
				return String(cString: inet_ntoa(p.pointee))
			})
		}
	}
	return nil
}

func setupDnsServer(res: res_9_state, dnsServer: String) {
	res_9_ninit(res)
	var addr = in_addr()
	inet_aton(dnsServer, &addr)
	res.pointee.nsaddr_list.0.sin_addr = addr
	res.pointee.nsaddr_list.0.sin_family = sa_family_t(AF_INET)
	res.pointee.nsaddr_list.0.sin_port = in_port_t(NS_DEFAULTPORT).bigEndian
	res.pointee.nscount = 1
}
