//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Mehrdad on 7/11/18.
//  Copyright © 2018 Mehrdad. All rights reserved.
//

import UIKit
import AVFoundation


// MARK: RecordSoundsViewController: UIViewController

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    
    // MARK: Properties
    var audioRecorder: AVAudioRecorder!
    
    
    // MARK: Outlets
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    
    // MARK: View
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("ViewDidLoad called")
        self.stopRecordingButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear called")
        toggleUI(false)
    }
    
    
    // MARK: Actions
    
    @IBAction func RecordAudio(_ sender: Any) {
        toggleUI(true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
        
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        toggleUI(false)
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func toggleUI(_ recordingState: Bool) {
        switch recordingState {
        case true:
            recordingLabel.text = "Recording in Progress"
            self.recordButton.isEnabled = false
            self.stopRecordingButton.isEnabled = true
        case false:
            recordingLabel.text = "Tap to Record"
            self.recordButton.isEnabled = true
            self.stopRecordingButton.isEnabled = false
        }
    }

    
    // MARK: Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
}
