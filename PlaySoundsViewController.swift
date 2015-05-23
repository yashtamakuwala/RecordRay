//
//  PlaySoundsViewController.swift
//  Recording
//
//  Created by YASH on 20/05/15.
//  Copyright (c) 2015 YASH. All rights reserved.
//

import UIKit
import AVFoundation


class PlaySoundsViewController: UIViewController {
    
    var audioPlayer:AVAudioPlayer!
    var audioPlayer2:AVAudioPlayer!
    var receivedAudio:RecordedAudio!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//       if var filepath = NSBundle.mainBundle().pathForResource("movie_quote", ofType: "mp3")
//       {
//        var filepathUrl = NSURL.fileURLWithPath(filepath)
//       
//       }
//        else {
//            println("Error in obtaining a filepath")
//        }
        
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        audioPlayer.enableRate = true
        
        audioPlayer2 = AVAudioPlayer(contentsOfURL: receivedAudio.filePathUrl, error: nil)
        
        audioPlayer2.enableRate = true

        // Do any additional setup after loading the view.
        audioEngine = AVAudioEngine()
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathUrl, error: nil)
    }

    
    @IBAction func playSlowAudio(sender: UIButton)
    {
        //Play audio slooowwwllly here
        audioPlayer.stop()
        audioPlayer.rate = 0.5
        audioPlayer.play()
        audioPlayer.currentTime = 0 //To make sure that it plays file from the beginning.
    }
    
    
    @IBAction func playFastAudio(sender: UIButton) {
        //Play audio fastly here
        audioPlayer2.stop()
        audioPlayer2.rate = 1.5
        audioPlayer2.play()
        
    }
    @IBAction func playChipmunkAudio(sender: UIButton) {
        playAudioWithVariablePitch(1000)
        
    }
    
    @IBAction func playDarthvaderAudio(sender: UIButton) {
        playAudioWithVariablePitch(-1000)
    }
    func playAudioWithVariablePitch(pitch: Float){
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func stopButton(sender: UIButton) {
        audioPlayer.stop()
        audioPlayer2.stop()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
