//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by howard.lee on 7/20/15.
//  Copyright (c) 2015 howard.lee. All rights reserved.
//

import UIKit
import AVFoundation

let RecordingLabelTextNormal = "Tap To Record"
let RecordingLabelTextRecording = "Recording"
let RecordingLabelTextProcessing = "Processing"

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingInProgress: UILabel!

    // buttons
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!

    var audioRecorder: AVAudioRecorder!
    var recordedAudio: AudioModel!

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated);
        stopButton.hidden = true
        recordingInProgress.text = RecordingLabelTextNormal
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton) {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String

        let recordingName = "my_audio.wav"
        let filePath = NSURL.fileURLWithPathComponents([dirPath, recordingName])
        println(filePath)

        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)

        audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()

        // Update UI
        recordingInProgress.text = RecordingLabelTextRecording
        stopButton.hidden = false
        stopButton.enabled = true
        recordButton.enabled = false
    }

    @IBAction func stopRecordingAudio(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)

        // disable user input while we process
        stopButton.enabled = false
        recordingInProgress.text = RecordingLabelTextProcessing
    }

    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {

        if (flag) {
            recordedAudio = AudioModel(filePathUrl: recorder.url, title: recorder.url.lastPathComponent)
            self.performSegueWithIdentifier("stopRecordingSegue", sender: recordedAudio)
        } else {
            println("Recording was unsuccessful")
        }

        // Update UI
        recordingInProgress.text = RecordingLabelTextNormal
        stopButton.hidden = true
        recordButton.enabled = true
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecordingSegue") {
            let playSoundsVC: PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! AudioModel
            playSoundsVC.receivedAudio = data
        }
    }
}

