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

    private var address = ""

    @IBOutlet weak var textAddress: UILabel!
    @IBOutlet weak var textMessage: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchAccountInfo()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    private func fetchAccountInfo() {
        _ = client.getAccountFromPublicKey(ConvertUtil.toHexString(keyPair.publicKey))
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](accountMetaDataPair) in
                guard let weakSelf = self else {
                    return
                }
                print("address = \(accountMetaDataPair.account.address)")
                print("balance = \(accountMetaDataPair.account.balance)")
                weakSelf.address = accountMetaDataPair.account.address
                weakSelf.textAddress.text = weakSelf.address
                weakSelf.textMessage.text = "balance = \(accountMetaDataPair.account.balance)"
            }, onError: { (error) in
                print("Error occured: \(error.localizedDescription)")
            }, onCompleted: {
            }, onDisposed: {}
        )
    }

    @IBAction func onTouchedAccountInfoButton(_ sender: Any) {
        textMessage.text = ""
        fetchAccountInfo()
    }

    @IBAction func onTouchedSendXemButton(_ sender: Any) {
    }

}

