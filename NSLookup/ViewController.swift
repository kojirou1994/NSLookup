//
//  ViewController.swift
//  NSLookup
//
//  Created by 王宇 on 2017/2/22.
//  Copyright © 2017年 Putotyra. All rights reserved.
//

import UIKit
import Dispatch

class ViewController: UIViewController {

	@IBOutlet weak var searchBar: UISearchBar!
	
	@IBOutlet weak var tableView: UITableView!
	
	var results: [ResolveResult] = []
	
	let queryQueue = DispatchQueue(label: "DNSQuery")
	
	override func viewDidLoad() {
		super.viewDidLoad()
		tableView.keyboardDismissMode = .onDrag
		// Do any additional setup after loading the view, typically from a nib.
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func clear(_ sender: Any) {
		results = []
		tableView.reloadData()
	}
	
	func query(host: String?) {
		queryQueue.async {
			guard let host = host, let result = ResolveResult.init(domain: host) else {
				return
			}
			self.results.append(result)
			DispatchQueue.main.async {
				self.tableView.reloadData()
			}
            try? result.resolve(using: dns)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
	}
}

var dns = "223.5.5.5" {
	didSet {
		UserDefaults.standard.set(dns, forKey: "dns")
	}
}

extension ViewController: UISearchBarDelegate {
	
	func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
		query(host: searchBar.text)
		searchBar.text = nil
		searchBar.endEditing(true)
	}
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
	
	func numberOfSections(in tableView: UITableView) -> Int {
		return 1
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return results.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
		cell.textLabel?.text = results[indexPath.row].domain
        cell.detailTextLabel?.text = results[indexPath.row].status == .success ? results[indexPath.row].address : results[indexPath.row].status.description
		return cell
	}
}
