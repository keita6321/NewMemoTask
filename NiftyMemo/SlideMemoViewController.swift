import UIKit
import SlideMenuControllerSwift

class SlideMemoViewController: SlideMenuController {

    override func awakeFromNib() {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "Memo")
        let leftVC = storyboard?.instantiateViewController(withIdentifier: "LeftMemo")
        //UIViewControllerにはNavigationBarは無いためUINavigationControllerを生成しています。
        // let navigationController = UINavigationController(rootViewController: mainVC!)
        //ライブラリ特有のプロパティにセット
        mainViewController = mainVC
        leftViewController = leftVC
        SlideMenuOptions.leftViewWidth = 200
        print("メモ追加画面のスライドメニュー幅")
        print(SlideMenuOptions.leftViewWidth)
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 試しのタイトル
        self.navigationItem.title = "memo"
        //self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.tapAddButton))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
