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
        
        // Create a circular button - 5 , - 9 , - 6
        setupRadioButton()
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
        let buttonHeight = 230.0
        let buttonWidth = 230.0
        let button = CircularGradientButton(frame: CGRect(x: 0, y: 0, width: buttonWidth, height: buttonHeight))
        view.addSubview(button)
        
        button.backgroundColor = .systemTeal
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
        button.widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.clipsToBounds = true
        
        // Create the curved slider
        let slider = CustomSlider(frame: CGRect(x: 0, y: 0, width: 200, height: 200))
        slider.minimumValue = 0
        slider.maximumValue = 100
        slider.value = 50 // Default value
        
        DispatchQueue.main.async {
            slider.backgroundColor = UIColor.clear
            slider.setMaximumTrackImage(UIImage(), for: .normal)
            slider.setMinimumTrackImage(UIImage(), for: .normal)
        }
        
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        
        view.addSubview(slider)
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.widthAnchor.constraint(equalToConstant: slider.bounds.width).isActive = true
        slider.heightAnchor.constraint(equalToConstant: slider.bounds.height).isActive = true
        slider.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        slider.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        // Add tick marks around the circular button
        addReadingsAroundButton(button: button)
    }

    func addReadingsAroundButton(button: UIButton) {
        let totalTicks = 100
        let radius = button.bounds.width / 2 - 18 // Keep some padding
        let centerX = view.center.x
        let centerY = view.center.y

        // Adjust angle increment to reduce spacing (slightly tighter placement)
        let adjustedAngleIncrement = (2 * CGFloat.pi) / (CGFloat(totalTicks) * 1) // Slightly closer
        
        for i in 0..<totalTicks {
            let angle = CGFloat(i) * adjustedAngleIncrement - CGFloat.pi / 2 // Start from top (-90°)
            
            let tickX = centerX + radius * cos(angle)
            let tickY = centerY + radius * sin(angle)
            
            if i % 5 == 4 { // Every 5th tick is a number label
                let label = UILabel()
                label.text = (i == 4) ? "5    •" : (i == 99) ? "0    •" : "\(5 * (i / 5 + 1)) •" // Ensure 100th tick is '0'
                label.font = UIFont.systemFont(ofSize: 10, weight: .heavy)
                label.textColor = .black
                label.sizeToFit()

                // Rotate perpendicular to other ticks
                let rotationAngle = angle + .pi
                label.transform = CGAffineTransform(rotationAngle: rotationAngle)
                
                label.center = CGPoint(x: tickX, y: tickY)
                view.addSubview(label)
            } else { // Regular tick marks '|'
                let tickLabel = UILabel()
                tickLabel.text = "|"
                tickLabel.font = UIFont.systemFont(ofSize: 10, weight: .semibold)
                tickLabel.textColor = .white
                tickLabel.sizeToFit()
                
                let rotationAngle = angle + .pi / 2
                tickLabel.transform = CGAffineTransform(rotationAngle: rotationAngle)
                tickLabel.center = CGPoint(x: tickX, y: tickY)
                view.addSubview(tickLabel)
            }
        }
    }
    
}
