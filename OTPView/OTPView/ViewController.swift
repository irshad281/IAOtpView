//
//  ViewController.swift
//  OTPView
//
//  Created by Innotical  Solutions  on 29/10/17.
//  Copyright © 2017 Innotical  Solutions . All rights reserved.
//

import UIKit

class ViewController: UIViewController ,OtpDelegate{

    @IBOutlet weak var otpView: IAOtpView!
    override func viewDidLoad() {
        super.viewDidLoad()
        otpView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didChnageText(_ text: String, isValid: Bool) {
        // Do whatever you want with otp
        print("Otp :-",text)
        print("isValid :-",isValid)
    }
}

