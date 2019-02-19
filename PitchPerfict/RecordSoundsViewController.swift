//
//  RecordSoundsViewController.swift
//  PitchPerfict
//
//  Created by Bashayer  on 25/10/2018.
//  Copyright © 2018 Bashayer . All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    @IBOutlet weak var recordingLable: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        
    }
    
    @IBAction func recordAudio(_ sender: Any) {
        configerUI( stopRecordingButton1:true,  recordButton1:false,  recordingLable1:"Recording in Progress")
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
       try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: .default, options: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    @IBAction func stopRecording(_ sender: Any) {
        configerUI( stopRecordingButton1:false,  recordButton1:true,  recordingLable1:"Tab To Record")

        audioRecorder.stop()
        let audioSession =  AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording"{
            let playSoundsVc = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVc.recordedAudioURL = recordedAudioURL
            
        }
    }
    

    func configerUI( stopRecordingButton1:Bool,  recordButton1:Bool,  recordingLable1:String) {
        stopRecordingButton.isEnabled = stopRecordingButton1
        recordButton.isEnabled = recordButton1
        recordingLable.text =  recordingLable1
    }
    
   
}

