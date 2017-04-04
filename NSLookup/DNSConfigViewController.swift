//
//  DNSConfigViewController.swift
//  NSLookup
//
//  Created by 王宇 on 2017/2/22.
//  Copyright © 2017年 Putotyra. All rights reserved.
//

import UIKit

class DNSConfigViewController: UIViewController {

	@IBOutlet weak var dnsServerTextField: UITextField!
	
	
	@IBAction func doneButtonTapped(_ sender: Any) {
		if let newDns = dnsServerTextField.text, newDns != "" {
			dns = newDns
		}
		self.dismiss(animated: true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()
		dnsServerTextField.placeholder = dns
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
