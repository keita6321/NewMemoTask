import UIKit
import SlideMenuControllerSwift

class SlideTaskViewController: SlideMenuController {
    
    override func awakeFromNib() {
        let mainVC = storyboard?.instantiateViewController(withIdentifier: "Task")
        let leftVC = storyboard?.instantiateViewController(withIdentifier: "LeftTask")
        //UIViewControllerにはNavigationBarは無いためUINavigationControllerを生成しています。
        //let navigationController = UINavigationController(rootViewController: mainVC!)
        //ライブラリ特有のプロパティにセット
        //mainViewController = navigationController
        mainViewController = mainVC
        leftViewController = leftVC
        SlideMenuOptions.leftViewWidth = 200
        print("allTaskViewの左ページ幅")
        print(SlideMenuOptions.leftViewWidth)
        super.awakeFromNib()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "all"
        NotificationCenter.default.addObserver(self, selector: #selector(self.didCloseMenu), name: NSNotification.Name(rawValue: "taskType"), object: nil)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(self.tapAddButton))
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tapAddButton(){
        performSegue(withIdentifier: "toAddTask", sender: nil)
    }
    func didCloseMenu(notification: Notification) {
        print(notification.userInfo)
        
        if let userInfo = notification.userInfo {
            switch userInfo["selectedType"] as! Int {
            case 0:
navigationItem.title = "all"
            case 1:
navigationItem.title = "expired"
            case 2:
                navigationItem.title = "today"
            default:
                break
            }
        } else {
            print("userInfoがnilです")
        }
    }
}
