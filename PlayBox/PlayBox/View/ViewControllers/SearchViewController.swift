import UIKit

class SearchViewController: UIViewController {
    
    class func viewController() -> UIViewController? {
        let storyBoard = UIStoryboard(name: "Home", bundle: nil)
        let viewController = storyBoard.instantiateViewController(withIdentifier: "SearchVC") as? SearchViewController
        return viewController
    }
    
    @IBOutlet weak var optionsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.systemCyan
        
        // Create a circular button
        
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

extension SearchViewController {
    
    func setupRadioButton() {
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.addSubview(button)
        
        button.backgroundColor = .systemGray
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 300).isActive = true
        button.widthAnchor.constraint(equalToConstant: 300).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.clipsToBounds = true
        button.layer.cornerRadius = button.bounds.width / 2 // Half of width/height for a perfect circle
        
        // Create the vertical curved slider (curve to the left)
        let slider = CustomSlider(frame: CGRect(x: 0, y: 0, width: 270, height: 270))
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50 // Default value
        
        DispatchQueue.main.async {
            slider.backgroundColor = UIColor.clear
            slider.setMaximumTrackImage(UIImage(), for: .normal)
            slider.setMinimumTrackImage(UIImage(), for: .normal)
        }
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        // Add the slider to the button
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.widthAnchor.constraint(equalToConstant: slider.bounds.width).isActive = true
        slider.heightAnchor.constraint(equalToConstant: slider.bounds.height).isActive = true
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
        slider.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
    }
    
}
