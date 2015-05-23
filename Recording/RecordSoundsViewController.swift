//
//  RecordSoundsViewController.swift
//  Recording
//
//  Created by YASH on 16/05/15.
//  Copyright (c) 2015 YASH. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController,AVAudioRecorderDelegate
{

    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordInProgress: UILabel!
    
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordStop: UILabel!
    
    
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool)
    {
        recordButton.enabled = true
        //Hide the stop Button
        
        stopButton.hidden = true
    }

@IBAction func recordAudio(sender: UIButton) {
        
        recordButton.enabled = false
        recordInProgress.hidden = false
        stopButton.hidden = false
    
        //TODO: Record user's voice.
    let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as! String
    
    let currentDateTime = NSDate()
    let formatter = NSDateFormatter()
    formatter.dateFormat = "ddMMyyyy-HHmmss"
    let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
    let pathArray = [dirPath, recordingName]
    let filePath = NSURL.fileURLWithPathComponents(pathArray)
    println(filePath)
    
    var session = AVAudioSession.sharedInstance()
    session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
    
    audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
    
    audioRecorder.delegate = self
    
    audioRecorder.meteringEnabled = true
    audioRecorder.prepareToRecord()
    audioRecorder.record()
    
        println("in recordAudio")
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool)
    {
        if(flag)
        {
            //TODO : Step 1 - Save the recorded audio
            recordedAudio = RecordedAudio()
            recordedAudio.filePathUrl = recorder.url// refernce to the audio file that is actually recorded on the phone
            recordedAudio.title = recorder.url.lastPathComponent //gives name of the recorded file
        
            //TODO : Step 2 - Move to the next screen aka perform segue
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio) //object recordedAudio initiated segue
        }
        else
        {
            println("Recording Failed!")
            recordButton.enabled = true
            stopButton.hidden = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if(segue.identifier=="stopRecording")
        {
            let playSoundsVC:PlaySoundsViewController = segue.destinationViewController as! PlaySoundsViewController
            let data = sender as! RecordedAudio
            playSoundsVC.receivedAudio = data
        }
    }
    @IBAction func stopRecording(sender: AnyObject)
    {
        recordInProgress.hidden = true
        recordStop.hidden = false
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
    }
   
}

