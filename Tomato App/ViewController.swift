import UIKit
import SnapKit

class ViewController: UIViewController {

    private lazy var startTime = 25
    private lazy var stopTime = 10

    //MARK: - UI elements
    private lazy var timer = Timer()
    private lazy var time = startTime {
        didSet {
            currentTimeLabel.text = "\(time)"
        }
    }

    private lazy var currentTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "25"
        label.textColor = .black
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private lazy var startStopButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "play"), for: .normal)
        button.addTarget(self, action: #selector(touched), for: .touchUpInside)

        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }

    //MARK: - Target Functions
    @objc private func touched() {
        if startStopButton.currentImage == UIImage(named: "play") {
            startStopButton.setImage(UIImage(named: "pause"), for: .normal)
        } else {
            startStopButton.setImage(UIImage(named: "play"), for: .normal)
        }
    }

    @objc private func tick(){
        if time == 0{
            timer.invalidate()
        }
            self.time -= 1
    }

    //MARK: - Setup Functions
    private func setupView(){
        [currentTimeLabel, startStopButton].forEach(){
            view.addSubview($0)
        }
    }

    private func setupConstraints(){
        currentTimeLabel.snp.makeConstraints{ make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(350)
            make.center.equalTo(view.center)
        }

        startStopButton.snp.makeConstraints{ make in
            make.top.equalTo(currentTimeLabel.snp.bottom).offset(50)
            make.leading.equalToSuperview().offset(175)
            make.height.equalTo(40)
            make.width.equalTo(45)
        }
    }

}

