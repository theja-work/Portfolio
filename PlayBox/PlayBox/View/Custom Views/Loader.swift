//
//  Loader.swift
//  PlayBox
//
//  Created by Thejas on 04/03/25.
//

import UIKit

class Loader: UIView {

    private var shapeLayers: [CAShapeLayer] = []
    private var timer: Timer?
    internal var shadeAffect: Bool = false
    private var blurEffectView: UIVisualEffectView?

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
        let circlePos = bounds.width / 2 * 0.4
        let circleSize = bounds.width * 0.6
        let circlePath = UIBezierPath(ovalIn: CGRect(x: circlePos, y: circlePos, width: circleSize, height: circleSize))

        let trianglePath = UIBezierPath()
        let topX = bounds.width * 0.4
        let topY = bounds.width * 0.35
        let midY = bounds.width * 0.65
        let botY = bounds.width * 0.5

        trianglePath.move(to: CGPoint(x: topX, y: topY)) // Top vertex
        trianglePath.addLine(to: CGPoint(x: topX, y: midY)) // Bottom-left vertex
        trianglePath.addLine(to: CGPoint(x: midY, y: botY)) // Bottom-right vertex
        trianglePath.close()

        let paths = [circlePath, trianglePath]

        for path in paths {
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.fillColor = UIColor.clear.cgColor
            shapeLayer.lineWidth = bounds.width / 32
            shapeLayer.strokeEnd = 1.0
            layer.addSublayer(shapeLayer)
            shapeLayers.append(shapeLayer)
        }

        setBackground()
    }

    private func setBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.systemBlue.cgColor,
            UIColor.white.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        layer.insertSublayer(gradientLayer, at: 0)
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
                
                shapeLayer.add(animation, forKey: "drawLine")
            }
        }
    }

    deinit {
        timer?.invalidate()
        blurEffectView = nil
    }
}
