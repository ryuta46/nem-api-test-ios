//
//  ViewController.swift
//  NemApiTestiOS
//
//  Created by Taizo Kusuda on 2017/11/11.
//  Copyright © 2017年 ryuta46. All rights reserved.
//

import UIKit
import RxSwift

class ViewController: UIViewController {
    private let client = NemApiClient("62.75.251.134")

    private lazy var keyPair: KeyPair = CryptoUtil.loadKeys()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchAccountInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    private func fetchAccountInfo() {
        _ = client.getAccountFromPublicKey(ConvertUtil.toHexString(keyPair.publicKey))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { (accountMetaDataPair) in
                print("address = \(accountMetaDataPair.account.address)")
                print("balance = \(accountMetaDataPair.account.balance)")
            }, onError: { (error) in
            }, onCompleted: {
            }, onDisposed: {}
        )
    }
}

