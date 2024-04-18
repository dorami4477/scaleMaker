//
//  ViewController.swift
//  scaleMaker
//
//  Created by 박다현 on 4/17/24.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    // MARK: - UI선언
    @IBOutlet weak var textFieldWarning: UILabel!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var titleApplyButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var scale01: UIStackView!
    @IBOutlet weak var scale02: UIStackView!
    @IBOutlet weak var scale03: UIStackView!
    @IBOutlet weak var scale04: UIStackView!
    @IBOutlet weak var scale05: UIStackView!
    @IBOutlet weak var scale07: UIStackView!
    @IBOutlet weak var scale06: UIStackView!
    
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var playButton: UIButton!
    
    var soundPlayer: AVAudioPlayer?
    var timer: Timer?
    var index = 0
    var speed: Double = 1
    
    var scale:[UIStackView] = []
    var circleColor:[CGColor] = []
    
    //scale의 컬러
    let circleColor01:CGColor = UIColor(red: 0.94, green: 0.62, blue: 0.65, alpha: 1.00).cgColor
    let circleColor02:CGColor = UIColor(red: 0.96, green: 0.79, blue: 0.58, alpha: 1.00).cgColor
    let circleColor03:CGColor = UIColor(red: 0.98, green: 0.98, blue: 0.75, alpha: 1.00).cgColor
    let circleColor04:CGColor = UIColor(red: 0.76, green: 0.92, blue: 0.75, alpha: 1.00).cgColor
    let circleColor05:CGColor = UIColor(red: 0.78, green: 0.79, blue: 1.00, alpha: 1.00).cgColor
    let circleColor06:CGColor = UIColor(red: 0.80, green: 0.67, blue: 0.92, alpha: 1.00).cgColor
    let circleColor07:CGColor = UIColor(red: 0.96, green: 0.76, blue: 0.95, alpha: 1.00).cgColor

    // MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        titleTextField.delegate = self
        setupUI()
    }
    
    func setupUI(){
        //버튼들 코너 라운드
        titleApplyButton.layer.cornerRadius = 7
        titleApplyButton.clipsToBounds = true
        playButton.layer.cornerRadius = 7
        playButton.clipsToBounds = true
        
        //스케일과 컬러 배열에 넣기
        scale.append(contentsOf: [scale01, scale02,scale03,scale04,scale05,scale06,scale07])
        circleColor.append(contentsOf: [circleColor01, circleColor02,circleColor03,circleColor04,circleColor05,circleColor06,circleColor07])
        
        titleTextField.placeholder = "제목을 입력하세요."
        textFieldWarning.isHidden = true
        
        // 스케일 원으로 만들기
        let _: [()] = scale.map{
            $0.layer.cornerRadius = $0.frame.size.width / 2 //??큰 아이폰에서는 원이 깨지는 이유를 모르겠음?
            $0.clipsToBounds = true
        }
    }

    
    //버튼 누르면 제목변경
    @IBAction func titleApplyButtonTapped(_ sender: Any) {
        guard let text = titleTextField.text else { return }
        //공백제거 후 텍스트필드가 비었는지 확인
        if !text.trimmingCharacters(in: .whitespaces).isEmpty{
            titleLabel.text = text.trimmingCharacters(in: .whitespaces)
            textFieldWarning.isHidden = true
            titleTextField.text = ""
        }else{
            textFieldWarning.isHidden = false
        }
    }
    
    //슬라이드 변경했을 때 엑션
    @IBAction func sliderChanged(_ sender: UISlider) {
        let sliderSpeed = Double(sender.value * 10)
        self.speed = sliderSpeed
    }
    
    //플레이 버튼 눌렸을 때 액션
    @IBAction func playButtonTapped(_ sender: UIButton) {
        let interval = speed * 0.2

        if sender.titleLabel!.text! == "stop" {
            //스탑 모드로 전환
            slider.isEnabled = true
            timer?.invalidate()
            sender.setTitle("play", for: .normal)
            stopSound()
            
        }else if sender.titleLabel!.text!  == "play" {
            //플레이 모드로 전환
            doSomethingAfter1Second()
            slider.isEnabled = false
            timer?.invalidate()
            timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(doSomethingAfter1Second), userInfo: nil, repeats: true)

        }
    }
    
    @objc func doSomethingAfter1Second(){
        if index < 7 {
            //플레이 모드로 전환
            if index > 0 {
                scale[index - 1].layer.backgroundColor = UIColor.lightGray.cgColor
            }
            playSoundPiano0(index:index)
            playButton.setTitle("stop", for: .normal)
            slider.isEnabled = false
            scale[index].layer.backgroundColor = circleColor[index]
            index += 1
        }else{
            //스탑 모드로 전환
            scale[6].layer.backgroundColor = UIColor.lightGray.cgColor
            timer?.invalidate()
            playButton.setTitle("play", for: .normal)
            slider.isEnabled = true
            stopSound()
            index = 0
        }
    }

    
    
    // mp3 사운드 파일 가져오기
    func playSoundPiano0(index:Int) {
        let soundName = "FX_piano_\(index)"
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "mp3") else { return }
        do {
            soundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            soundPlayer?.numberOfLoops = 0
            soundPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }

    func stopSound() {
        soundPlayer?.stop()
    }
}


// MARK: - EXTENSION 텍스트 델리게이트
extension ViewController:UITextFieldDelegate{
    //재 입력시 경고 문제 안보이게
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = titleTextField.text else { return true }
        if !text.isEmpty{
            textFieldWarning.isHidden = true
        }
        return true
    }
}


