//
//  TimelineViewController.swift
//  coupon
//
//  Created by 植田直人 on 2021/11/18.
//

import UIKit

class TimelineViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!

    // テーブル表示用のデータソース
    var coupons: [TwitterCoupon]? = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // delegateの指定を自分自身（self = TimelineViewController）に設定
        tableView.delegate = self
        // dataSourceの指定を自分自身(self = TimelineViewController)に設定
        tableView.dataSource = self

        TwitterCommunicator().getCouponFromTwitter(){ [weak self] data, error in

            if let error = error {
                print(error)
                return
            }

            let parser = TwitterCouponParser()
            let response = parser.parse(data: data!)
            self?.coupons = response?.data

            DispatchQueue.main.async {
                self?.tableView.reloadData()
            }
        }
    }

}

extension TimelineViewController: UITableViewDelegate {

    // cellがタップされたのを検知したときに実行する処理
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セルがタップされたよ！")
    }

    // セルの見積もりの高さを指定する処理
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    // セルの高さ指定をする処理
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // UITableViewCellの高さを自動で取得する値
        return UITableView.automaticDimension
    }
}

extension TimelineViewController: UITableViewDataSource {
    // 何個のcellを生成するかを設定する関数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // tweetsの配列内の要素数分を指定
        guard let coupons = self.coupons else { return 0 }
        return coupons.count
    }

    // 描画するcellを設定する関数
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TweetTableViewCellを表示したいので、TweetTableViewCellを取得
        let cell = tableView.dequeueReusableCell(withIdentifier: "TweetTableViewCell") as! TweetTableViewCell
        // TweetTableViewCellの描画内容となるtweetを渡す
        cell.fill(tweet: coupons?[indexPath.row])
        return cell
    }
}
