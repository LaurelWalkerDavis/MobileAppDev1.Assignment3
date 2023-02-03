//
//  ViewController.swift
//  Clock
//
//  Created by Laurel Walker Davis on 1/31/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

    
    // Timer Vars
    @IBOutlet weak var timeRemaining: UILabel!
    @IBOutlet weak var selectorTime: UIDatePicker!
    var timer = Timer()
    var timeLeft : Int?
    var date : Date?
    var remainingTime : Date?
    var countDown : Int = -1
    
    // Clock Vars
    @IBOutlet weak var liveClockLabel: UILabel!
    var clockTimer = Timer()
    var calendar = Calendar.current
    
    // View Vars
    @IBOutlet weak var NolaDayBack: UIImageView!
    @IBOutlet weak var NolaNightBack: UIImageView!
    @IBOutlet weak var startStopButton: UIButton!
    var jazz: AVAudioPlayer?
    var musicPlaying : Bool = false
    
    
    
////////////  MAIN   ////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Get liveClock
        getLiveClock()
        startStopButton.setTitle("Start Timer", for: .normal)
        // Set view
        setBackground()
        timeRemaining.text = " "
    }
    

    
////////////  DISPLAY FUNCTIONS    ////////////
    func setBackground() {
        if (getIsAM()) {
            NolaDayBack.isHidden = false
            NolaNightBack.isHidden = true
            print("AM")
        } else {
            print("PM")
            NolaDayBack.isHidden = true
            NolaNightBack.isHidden = false
        }
    }
    
    func getIsAM() -> Bool {
        // Determine AM / PM
        let hour = calendar.component(.hour, from: Date())
        print(hour)
        if (hour < 12) {
            return true
        } else {
            return false
        }
    }
    
////////////  SOUND FUNCTIONS  ////////////
    func playSound() {
        guard let path = Bundle.main.path(forResource: "retrosoul", ofType:"mp3") else { return }
        let url = URL(fileURLWithPath: path)
        do {
            jazz = try AVAudioPlayer(contentsOf: url)
            jazz?.play()
            musicPlaying = true
        }
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    func stopSound() {
        jazz?.stop()
        musicPlaying = false
        viewStartTimer()
        
    }

    
///////// TIMER FUNCTIONS///////
    @IBAction func startTimer(_ sender: UIButton) {
        if !musicPlaying {
            timer.invalidate()
            viewStartTimer()
            remainingTime = selectorTime.date
            countDown = Int(selectorTime.countDownDuration)
            
            // show progress :
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(self.startCountDown), userInfo: nil, repeats: true)
        }
        else {
            timer.invalidate()
            viewStopMusic()
            stopSound()
            countDown = -1
        }
    }
    
    @objc func startCountDown() {
        // Displays the time remaining at the bottom
        let comps = Calendar.current.dateComponents([.hour, .minute, .second], from: remainingTime!)
        let hour = comps.hour!
        let minute = comps.minute!
        let seconds = comps.second!
        timeRemaining.text = (String(format: "Time Remaining: %02d:%02d:%02d", hour, minute, seconds))
        remainingTime! -= 1
        
        // Tracks countdown
        if countDown > 0 {
            countDown -= 1
        }
        else {
            playSound()
            viewStopMusic()
            timer.invalidate()
        }
    }
    
    func viewStartTimer() {
        startStopButton.setTitle("Start Timer", for: .normal)
    }
    
    func viewStopMusic() {
        startStopButton.setTitle("Stop Music", for: .normal)
    }
    

////////////  LIVE CLOCK FUNCTIONS   ////////////
    func getLiveClock() {
        clockTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.currentTime), userInfo: nil, repeats: true)
    }
    
    @objc func currentTime() {
        let clockFormatter = DateFormatter()
        clockFormatter.dateFormat = "E, d MMM yyyy H:mm:ss"
        liveClockLabel.text = clockFormatter.string(from: Date())
        setBackground()
    }

}

