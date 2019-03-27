//
//  ViewController.swift
//  Quizzler
//
//  Created by Angela Yu on 25/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //Place your instance variables here
    let allQuestions = QuestionBank()
    var currentQuestion: Question!
    var pickedQuestion : Int = 0
    var alert: UIAlertController!
    var playSound: AVAudioPlayer!
    let successSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "right"
        , ofType: "mp3")!) as URL
    let failSound = NSURL(fileURLWithPath: Bundle.main.path(forResource: "wrong"
        , ofType: "mp3")!) as URL
    
    
    func playJingle(sound: URL){
        do{
            try playSound = AVAudioPlayer(contentsOf: sound)
        } catch {
            print(error)
        }
        
        playSound.play()
    }
    
    
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet var progressBar: UIView!
    @IBOutlet weak var progressLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad() 
        
        alert = UIAlertController(title: "Awesome", message: "You've finished all the questions, do you want to start over?", preferredStyle: .alert)
        
        let restartAction = UIAlertAction(title: "Restart", style: .default
            , handler: { action in
                self.startOver()
        })
        
        alert.addAction(restartAction)
        
        startOver()
    }
    


    @IBAction func answerPressed(_ sender: AnyObject) {
        let esito = checkAnswerByTag(tag: sender.tag)
        if esito {
            let currentScore = Int(scoreLabel.text!.split(separator: " ")[1])
            scoreLabel.text = "Score: \(currentScore!+1)"
            playJingle(sound: successSound)
        }
        else {
            playJingle(sound: failSound)
        }
        updateUI()
        

    }
    
    func checkAnswerByTag(tag: Int) -> Bool {
        return tag == 1 && currentQuestion.answer == true
            || tag == 2 && currentQuestion.answer == false
    }
    
    func updateUI() {
        
        if pickedQuestion == allQuestions.list.count {
            present(alert, animated: true, completion: nil)
        } else {
            redrawProgressBar()
            updateProgressLabel()
            updateQuestionLabel()
            pickedQuestion = pickedQuestion + 1
        }
        
    }
    
    func redrawProgressBar(){
        let totalWidth = UIScreen.main.bounds.width
        let progressPercentage = CGFloat((pickedQuestion+1) * 100 / allQuestions.list.count)
        let widthInPerc = progressPercentage * totalWidth / 100
        progressBar.frame.size.width = widthInPerc
    }
    
    func updateProgressLabel(){
        progressLabel.text = "\(String(pickedQuestion+1)) / \(allQuestions.list.count)"
    }
    
    func updateQuestionLabel(){
        currentQuestion = allQuestions.list[pickedQuestion]
        questionLabel.text = currentQuestion.question
    }
    
    func startOver() {
        pickedQuestion = 0
        scoreLabel.text = "Score: 0"
        updateUI()
    }
    

    
}
