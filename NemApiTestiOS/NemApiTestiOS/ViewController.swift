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

    private func sendXem(_ receiverAddress: String, _ amount: UInt64) {
        let transaction = TransferTransaction(
            publicKey: keyPair.publicKey,
            receiverAddress: receiverAddress,
            amount: amount
        )

        // 転送データのバイト列を取得
        let transactionBytes = transaction.transactionBytes
        // データ列を署名
        let signature = CryptoUtil.sign(keyPair, transactionBytes)

        // データ列と署名を合わせて 転送トランザクションを発行する
        let requestAnnounce = RequestAnnounce(
            data: ConvertUtil.toHexString(transactionBytes),
            signature: ConvertUtil.toHexString(signature))

        _ = client.transactionAnnounce(requestAnnounce)
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self](response) in
                guard let weakSelf = self else {
                    return
                }
                var message = "type = \(response.type)\n" +
                    "code = \(response.code)\n" +
                    "message = \(response.message)\n"

                if let hash = response.transactionHash?.data {
                    message += "hash = \(hash)\n"
                }
                if let innerHash = response.innerTransactionHash?.data {
                    message += "inner = \(innerHash))\n"
                }

                print(message)
                weakSelf.textMessage.text = message
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
        let alert = UIAlertController(title: "Send XEM", message: "Input Address and Micro NEM", preferredStyle: .alert)

        alert.addTextField { (textField) in
            textField.keyboardType = .asciiCapable
            textField.placeholder = "Receiver Address"
        }
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
            textField.placeholder = "Micro NEM"
        }
        let okAction = UIAlertAction(title: "OK", style: .default) { [weak self](action:UIAlertAction!) -> Void in
            guard let weakSelf = self else {
                return
            }
            // 入力したテキストをコンソールに表示
            let addressField = alert.textFields![0] as UITextField
            let microXemField = alert.textFields![1] as UITextField
            guard let address = addressField.text,
                let microXemText = microXemField.text,
                let microXem = Int(microXemText) else {
                    print("Failed to analyze input")
                    return
            }
            weakSelf.textMessage.text = ""
            weakSelf.sendXem(address, UInt64(microXem))
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { (action:UIAlertAction!) -> Void in }

        alert.addAction(cancelAction)
        alert.addAction(okAction)

        present(alert, animated: true, completion: nil)
    }

}

