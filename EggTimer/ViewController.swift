//
//  ViewController.swift
//  EggTimer
//
//  Created by Mendy Barouk on 15/03/2017.
//  Copyright © 2017 Mendy Barouk. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var pickerData: [String] = []
    var cookingTime: Int = 0
    var timer: Timer = Timer()
    var cookingActived: Bool = false
    var sound: AVAudioPlayer = AVAudioPlayer()

    //Outlets
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var startButton: UIButton!
    
    @IBOutlet weak var eggsPickerView: UIPickerView!
    
    //Action
    @IBAction func startAction(_ sender: UIButton) {
        if !cookingActived {
            timer = Timer.scheduledTimer(
                timeInterval: 1,
                target: self,
                selector: #selector(ViewController.decrementCooking),
                userInfo: nil,
                repeats: true
            )
            cookingActived = true
            startButton.setTitleColor(.orange, for: .normal)
            startButton.setTitle("Pause", for: .normal)
            timer.fire()
            
        } else {
            timer.invalidate()
            cookingActived = false
            startButton.setTitleColor(nil, for: .normal)
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    @IBAction func resetAction(_ sender: UIButton) {
        reset()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        eggsPickerView.dataSource = self
        eggsPickerView.delegate = self
        
        pickerData = ["Hard egg", "Boiled egg", "Poched egg", "Egg casserole", "Poached egg", "Omelette"]
        cookingSelected(rowOfPickerView: 0)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //MARK: --protocol UIPickerViewDataSource--
    
    
    // returns the number of 'columns' to display.
    public func numberOfComponents(in pickerView: UIPickerView) -> Int{
        return 1
    }
    
    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    //MARK: --protocol UIPickerViewDelegate--
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
         cookingSelected(rowOfPickerView: row)
    }
    
    
    //MARK: --My function--
    func cookingSelected(rowOfPickerView: Int) {
        switch rowOfPickerView {
        case 0: cookingTime = 600
        case 1: cookingTime = 180
        case 2: cookingTime = 300
        case 3: cookingTime = 15
        case 4: cookingTime = 240
        case 5: cookingTime = 300
        default:
            print("no selection")
        }
        timerLabel.text = timerString()
    }
    
    func timerString() -> String {
        let hour = cookingTime / 3600
        let minute = cookingTime / 60 % 60
        let second = cookingTime % 60
        
        return String(format: "%02i:%02i:%02i", hour, minute, second)
    }
    
    func decrementCooking() {
        if cookingTime == 10 {
            initSound(nameSound: "bip")
            timerLabel.textColor = .orange
        } else if cookingTime == 0 {
            initSound(nameSound: "alarm")
            timerLabel.textColor = .red
        }
        if cookingTime <= 10 {
            sound.play()
            if cookingTime == 0 {
                timer.invalidate()
                DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                    self.reset()
                })
                return
            }
        }
        cookingTime -= 1
        timerLabel.text = timerString()
    }
    
    func initSound(nameSound: String) {
        let fileSound = Bundle.main.url(forResource: nameSound, withExtension: ".mp3")
        do {
            try sound = AVAudioPlayer(contentsOf: fileSound!)
        } catch {
            print("Playback error")
        }
    }
    
    func reset() {
        if cookingActived {
            timer.invalidate()
            startButton.setTitle("Start", for: .normal)
            timerLabel.textColor = .black
            startButton.setTitleColor(nil, for: .normal)
            sound.stop()
        }

        cookingSelected(rowOfPickerView: 0)
        eggsPickerView.selectRow(0, inComponent: 0, animated: true)
        cookingActived = false
    }
    
    
    
    
    
    
    
    
    

}

