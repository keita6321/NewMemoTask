import UIKit
import SlideMenuControllerSwift

class SlideTaskViewController: SlideMenuController {
    
    override func awakeFromNib() {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "Task")
        let leftVC = storyboard?.instantiateViewController(withIdentifier: "LeftTask")
        //UIViewControllerにはNavigationBarは無いためUINavigationControllerを生成しています。
        let navigationController = UINavigationController(rootViewController: mainVC!)
        //ライブラリ特有のプロパティにセット
        mainViewController = navigationController
        leftViewController = leftVC
        SlideMenuOptions.leftViewWidth = 200
        print("allTaskViewの左ページ幅")
        print(SlideMenuOptions.leftViewWidth)
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
