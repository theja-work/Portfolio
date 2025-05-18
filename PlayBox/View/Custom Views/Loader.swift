//
//  Loader.swift
//  PlayBox
//
//  Created by Thejas on 04/03/25.
//

import UIKit

final class Loader: UIView {

    private var shapeLayers: [CAShapeLayer] = []
    private var timer: Timer?
    internal var shadeAffect: Bool = false
    private var blurEffectView: UIVisualEffectView?
    
    private var gradientLayer : CAGradientLayer {
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = skin.gradients
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        
        return gradientLayer
    }
    
    var skin : LoaderSkin = .App {
        
        didSet {
            setBackground()
        }
        
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        commonInit()
    }

    private func commonInit() {
        clipsToBounds = true
        layer.cornerRadius = self.bounds.width * 0.2
        addPaths()
        
        // Ensure blur is added in the parent view (if exists)
        DispatchQueue.main.async {
            if let superview = self.superview {
                self.setupBlurEffectView(in: superview)
            }
        }
    }
    
    private func setupView() {
        clipsToBounds = true
        layer.cornerRadius = bounds.width * 0.2
        addPaths()
    }

    func addLoader(to view: UIView) {
        self.center = view.center
        view.addSubview(self)
        self.isHidden = true
        setupBlurEffectView(in: view)
    }

    private func addPaths() {
        
        let width = bounds.width.rounded()
        
        let circlePos = width / 2 * 0.4
        let circleSize = width * 0.6
        let circlePath = UIBezierPath(ovalIn: CGRect(x: circlePos, y: circlePos, width: circleSize, height: circleSize))

        let trianglePath = UIBezierPath()
        let topX = width * 0.4
        let topY = width * 0.35
        let midY = width * 0.65
        let botY = width * 0.5

        trianglePath.move(to: CGPoint(x: topX, y: topY)) // Top vertex
        trianglePath.addLine(to: CGPoint(x: topX, y: midY)) // Bottom-left vertex
        trianglePath.addLine(to: CGPoint(x: midY, y: botY)) // Bottom-right vertex
        trianglePath.close()

        let paths = [circlePath, trianglePath]

        for path in paths {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = skin.strokeColor
            shapeLayer.fillColor = skin.fillColor
            shapeLayer.lineWidth = bounds.width / 32
            shapeLayer.strokeEnd = 1.0
            layer.addSublayer(shapeLayer)
            shapeLayers.append(shapeLayer)
        }

        setBackground()
    }

    private func setBackground() {
        DispatchQueue.main.async {
            self.gradientLayer.colors = self.skin.gradients
            
            if self.layer.sublayers?.first != self.gradientLayer {
                self.layer.insertSublayer(self.gradientLayer, at: 0)
            }
            
        }
    }

    func showLoader() {
        guard timer == nil else { return }
        
        DispatchQueue.main.async {
            if let superview = self.superview {
                self.setupBlurEffectView(in: superview) // Ensure blur effect is ready
            }
            self.updateShadeAffect(isVisible: true) // Show blur instantly
            self.isHidden = false
        }

        animate()
        timer = Timer.scheduledTimer(withTimeInterval: 2.0, repeats: true) { [weak self] _ in
            self?.animate()
        }
    }

    func hideLoader() {
        DispatchQueue.main.async {
            self.isHidden = true
            self.updateShadeAffect(isVisible: false) // Hide blur instantly
        }

        timer?.invalidate()
        timer = nil
    }

    private func setupBlurEffectView(in superView: UIView) {
        
        guard shadeAffect else {return}
        
        if blurEffectView == nil {
            let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView?.backgroundColor = .clear
            blurEffectView?.frame = superView.bounds
            blurEffectView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            //blurEffectView?.isHidden = true // Keep hidden initially
            blurEffectView?.isUserInteractionEnabled = false
            superView.insertSubview(blurEffectView!, belowSubview: self)
        }
    }

    private func updateShadeAffect(isVisible: Bool) {
        DispatchQueue.main.async {
            guard let blurEffectView = self.blurEffectView else { return }

            if isVisible, self.shadeAffect {
                blurEffectView.effect = UIBlurEffect(style: .dark)
                //blurEffectView.alpha = 0.6
            } else {
                blurEffectView.effect = nil
            }
        }
    }

    private func animate() {
        DispatchQueue.main.async {
            for (index, shapeLayer) in self.shapeLayers.enumerated() {
                let animation = index == 0 ? CABasicAnimation(keyPath: "strokeEnd") : CABasicAnimation(keyPath: "strokeStart")
                animation.fromValue = 0
                animation.toValue = 1
                animation.duration = index == 0 ? 1.0 : 0.64
                animation.beginTime = CACurrentMediaTime()
                animation.fillMode = .forwards
                animation.autoreverses = true
                animation.isRemovedOnCompletion = false
                animation.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
                animation.repeatCount = .infinity
                
                shapeLayer.add(animation, forKey: "draw")
            }
        }
    }

    deinit {
        timer?.invalidate()
        blurEffectView = nil
    }
}

enum LoaderSkin {
    
    case App
    case CellImage
    case PlayerView
    case AppLaunch
    
    var gradients : [CGColor] {
        
        switch self {
        case .App : return [UIColor.systemBlue.cgColor , UIColor.white.cgColor]
        case .AppLaunch : return [UIColor.systemYellow.cgColor , UIColor.systemBlue.withAlphaComponent(0.6).cgColor]
        case .CellImage : return [UIColor.systemBlue.withAlphaComponent(0.6).cgColor , UIColor.systemOrange.withAlphaComponent(0.6).cgColor]
        case .PlayerView : return [UIColor.blue.withAlphaComponent(0.6).cgColor , UIColor.systemOrange.withAlphaComponent(0.6).cgColor]
        }
        
    }
    
    var strokeColor : CGColor {
        switch self {
        case .App , .AppLaunch:
            return UIColor.black.cgColor
        case .CellImage:
            return UIColor.systemYellow.cgColor
        case .PlayerView:
            return UIColor.black.cgColor
        }
    }
    
    var fillColor : CGColor {
        switch self {
        case .App , .AppLaunch , .CellImage:
            return UIColor.clear.cgColor
        case .PlayerView:
            return UIColor.white.cgColor
        }
    }
    
    
}
