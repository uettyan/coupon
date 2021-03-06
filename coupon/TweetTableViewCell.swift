//
//  TweetTableViewCell.swift
//  coupon
//
//  Created by 植田直人 on 2021/11/19.
//

import UIKit

class TweetTableViewCell: UITableViewCell {

    // アイコンを表示するUIImageView
    @IBOutlet weak var iconImageView: UIImageView!
    // 名前を表示するUILabel
    @IBOutlet weak var nameLabel: UILabel!
    // スクリーンネームを表示するUILabel
    @IBOutlet weak var screenNameLabel: UILabel!
    // ツイート本文を表示するUILabel
    @IBOutlet weak var textContentLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    /// tweetとユーザ情報から値を取り出して、UIにセットする
    func fill(tweet: TwitterCoupon?) {
        guard let url = tweet?.user.profileImageURL else { return }
        let downloadTask = URLSession.shared.dataTask(with: URL(string: url)!) { [weak self] data, response, error in
            if let error = error {
                print(error)
                return
            }

            DispatchQueue.main.async {
                self?.iconImageView.image = UIImage(data: data!)
            }
        }
        downloadTask.resume()

        textContentLabel.text = tweet?.text
        nameLabel.text = tweet?.user.name
        // screenNameには "@" が含まれていないので、頭に "@" を入れてあげる必要がある
        guard let screenName = tweet?.user.screenName else { return }
        screenNameLabel.text = "@" + screenName
    }
}
