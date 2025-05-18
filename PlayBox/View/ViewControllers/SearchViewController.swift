import UIKit

class SearchViewController: UIViewController {
    
    class func viewController() -> UIViewController? {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as? SearchViewController
        return viewController
    }
    
    @IBOutlet weak var optionsButton: UIButton!
    
    var radioButton : RadioButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemCyan
        
        radioButton = RadioButton(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        
        self.view.addSubview(radioButton)
        radioButton.center = self.view.center
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        //print("Slider value: \(sender.value)")
    }
    
    @IBAction func selectPhotoAction(_ sender: UIAction) {
        print("selectPhotoAction")
        optionsButton.setTitle(sender.title, for: .normal)
    }
    
    @IBAction func viewPhotoAction(_ sender: UIAction) {
        print("viewPhotoAction")
        optionsButton.setTitle(sender.title, for: .normal)
    }
}

