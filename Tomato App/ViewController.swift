import UIKit
import SnapKit

var isWorkTime = true
var isAnimationStarted = false
class ViewController: UIViewController {


    //MARK: - UI elements
    private let foreProgresBar = CAShapeLayer()
    private let backProgresBar = CAShapeLayer()
    private let animation = CABasicAnimation(keyPath: "strokeEnd")

    private lazy var timer = Timer()
    private lazy var time = 25 {
        didSet {
            if time > 9 {
            currentTimeLabel.text = "00:\(time)"
            }
           else {
               currentTimeLabel.text = "00:0\(time)"
           }
        }
    }

    private lazy var taskLabel: UILabel = {
        let label = UILabel()
        label.text = "Focus time"
        label.textColor = .white
        label.font = .systemFont(ofSize: 30)
        return label
    }()

    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "00:25"
        label.textColor = .white
        label.font = .systemFont(ofSize: 25)
        return label
    }()

    private lazy var startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(touched), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        drawBackLayer()
        view.backgroundColor = UIColor(named: "redColor")
    }

    private func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self,
                                     selector: #selector(tick),
                                     userInfo: nil,
                                     repeats: true)
    }

    //MARK: - Target Functions
    @objc private func touched() {
        if startStopButton.currentImage == UIImage(named: "play"){
            startStopButton.setImage(UIImage(named: "pause"), for: .normal)
            drawForeLayer()
            startResumeAnimation()
            runTimer()
        } else {
            startStopButton.setImage(UIImage(named: "play"), for: .normal)
            timer.invalidate()
            pauseAnimation()
        }
    }

    @objc private func tick() {
        if time == 0 {
            timer.invalidate()
            if isWorkTime {
                stopAnimation()
                isWorkTime = false
                time = 10
                view.backgroundColor = UIColor(named: "greenColor")
                taskLabel.text = "Break time"
                touched()
            } else {
                stopAnimation()
                isWorkTime = true
                time = 25
                view.backgroundColor = UIColor(named: "redColor")
                taskLabel.text = "Focus time"
                touched()

            }
        }
        else {
            self.time -= 1
        }
    }
    
    //MARK: - Progress Functions
    private func drawBackLayer() {   //Progress background
        let center = CGPoint(x: view.center.x, y: view.center.y + 35)
        backProgresBar.path = UIBezierPath(arcCenter: center,
                                           radius: 100, startAngle: -CGFloat.pi / 2,
                                           endAngle: CGFloat.pi * 2,
                                           clockwise: true).cgPath

        backProgresBar.strokeColor = UIColor.white.cgColor
        backProgresBar.fillColor = UIColor.clear.cgColor
        backProgresBar.lineWidth = 15
        view.layer.addSublayer(backProgresBar)
    }

    private func drawForeLayer() { //Progress
        let center = CGPoint(x: view.center.x, y: view.center.y + 35)
        foreProgresBar.path = UIBezierPath(arcCenter: center,
                                           radius: 100, startAngle: -CGFloat.pi / 2,
                                           endAngle: CGFloat.pi * 3 / 2,
                                           clockwise: true).cgPath
        if isWorkTime {
            foreProgresBar.strokeColor = UIColor(named: "redColor")?.cgColor
        } else {
            foreProgresBar.strokeColor = UIColor(named: "greenColor")?.cgColor
        }
        foreProgresBar.fillColor = UIColor.clear.cgColor
        foreProgresBar.lineWidth = 15
        view.layer.addSublayer(foreProgresBar)
    }

    private func startResumeAnimation() {
        if !isAnimationStarted {
            startAnimation()
        } else {
            resumeAniamtion()
        }
    }

    private func startAnimation() {
        foreProgresBar.speed = 1.0
        foreProgresBar.timeOffset = 0.0
        foreProgresBar.beginTime = 0.0
        foreProgresBar.strokeEnd = 0.0
        animation.keyPath = "strokeEnd"
        animation.toValue = 1
        animation.fromValue = 0
        animation.duration = CFTimeInterval(time)
        animation.isRemovedOnCompletion = false
        animation.isAdditive = true
        animation.fillMode = CAMediaTimingFillMode.forwards
        foreProgresBar.add(animation, forKey: "strokeEnd")
        isAnimationStarted = true
    }

    private func stopAnimation() {
        foreProgresBar.speed = 1.0
        foreProgresBar.timeOffset = 0.0
        foreProgresBar.beginTime = 0.0
        foreProgresBar.strokeEnd = 0.0
        foreProgresBar.removeAllAnimations()
        isAnimationStarted = false
    }

    private func pauseAnimation() {
        let timeSincePaused = foreProgresBar.convertTime(CACurrentMediaTime(), from: nil)
        foreProgresBar.speed = 0.0
        foreProgresBar.timeOffset = timeSincePaused
    }

    private func resumeAniamtion() {
        let paudesTime = foreProgresBar.timeOffset
        foreProgresBar.speed = 1.0
        foreProgresBar.timeOffset = 0.0
        foreProgresBar.beginTime = 0.0
        let timeSincePaused = foreProgresBar.convertTime(CACurrentMediaTime(), from: nil) - paudesTime
        foreProgresBar.beginTime = timeSincePaused
    }

    //MARK: - Setup Functions
    private func setupView() {
        [currentTimeLabel, startStopButton, taskLabel].forEach() {
            view.addSubview($0)
        }
    }

    private func setupConstraints() {
        currentTimeLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(365)
            make.center.equalTo(view.center)
        }

        startStopButton.snp.makeConstraints { make in
            make.top.equalTo(currentTimeLabel.snp.bottom).offset(60)
            make.leading.equalToSuperview().offset(180)
            make.height.equalTo(30)
            make.width.equalTo(35)
        }

        taskLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(100)
            make.leading.equalToSuperview().offset(125)
        }
    }

}

