//
//  ViewController.swift
//  retro-calculator
//
//  Created by Ryan Tallmadge on 12/7/15.
//  Copyright © 2015 ryant. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    enum Operation: String{
        case Divide     = "/";
        case Multiply   = "*";
        case Subtract   = "-";
        case Add        = "+";
        case Equals     = "=";
        case Empty      = "Empty";
    }
    
    
    //Outlets
    @IBOutlet weak var outputLbl: UILabel!;
    
    //Params
    var btnSoundAVA             : AVAudioPlayer!;
    var runningTotalStr         = "";
    var leftValStr              = "";
    var rightValStr             = "";
    var currentOperatorStr      : Operation = Operation.Empty;
    var result                  = "";
    
    override func viewDidLoad() {
        super.viewDidLoad();
        let path     = NSBundle.mainBundle().pathForResource("btn", ofType: "wav");
        let soundURL = NSURL(fileURLWithPath: path!);
        
        do{
            try btnSoundAVA = AVAudioPlayer(contentsOfURL: soundURL);
            btnSoundAVA.prepareToPlay();
        } catch let err as NSError{
            print(err.debugDescription);
        }
    }
    
    func playSound(){
        if(btnSoundAVA.playing){
            btnSoundAVA.stop();
        }
        btnSoundAVA.play();
    }
    
    func processOperation(op: Operation){
        playSound();
        
        if (currentOperatorStr != Operation.Empty){
            //Run Some Math
            rightValStr     = runningTotalStr;

            if(rightValStr != ""){
                if(currentOperatorStr == Operation.Multiply){
                    result = String(Float(leftValStr)! * Float(rightValStr)!);
                }else if(currentOperatorStr == Operation.Add){
                    result = String(Float(leftValStr)! + Float(rightValStr)!);
                }else if(currentOperatorStr == Operation.Subtract){
                    result = String(Float(leftValStr)! - Float(rightValStr)!);
                }else if(currentOperatorStr == Operation.Divide){
                    result = String(Float(leftValStr)! / Float(rightValStr)!);
                }
            }
            
            runningTotalStr = "";
            leftValStr      = result;
            updateOutputLabel(result);
            currentOperatorStr  = op;
        }else{
            //This the the first time and opertor has been pressed
            leftValStr          = runningTotalStr;
            runningTotalStr     = "";
            currentOperatorStr  = op;
        }
    }
    
    func updateOutputLabel(label : String){
        outputLbl.text = label;
    }

    @IBAction func numberPresed(btn: UIButton!){
        playSound();
        runningTotalStr += "\(btn.tag)";
        updateOutputLabel(runningTotalStr);
    }

    @IBAction func onDividePressed(sender: AnyObject) {
        processOperation(Operation.Divide);
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        processOperation(Operation.Multiply);
    }

    @IBAction func onAddPressed(sender: AnyObject) {
        processOperation(Operation.Add);
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        processOperation(Operation.Subtract);
    }

    @IBAction func onEqualPressed(sender: AnyObject) {
        processOperation(Operation.Equals);
    }
    
    
}

