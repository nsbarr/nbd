//
//  GameScene.swift
//  MasterPass
//
//  Created by nick barr on 10/13/14.
//  Copyright (c) 2014 poemsio. All rights reserved.
//

import SpriteKit
import UIKit

class GameScene: SKScene, UITextFieldDelegate {
    
//    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
//        println("huh")
//    }
    
    let guessLetterWidth:CGFloat = 60
    let guessLetterHeight:CGFloat = 60
    let tileFontSize:CGFloat = 40
    let tileFontColor = UIColor.whiteColor()
    let verticalTileSpacing:CGFloat = 14
    var numberOfGuesses:Int = 0
    var vc = GameViewController()
    let playerPromptLine1 = SKLabelNode(fontNamed: "Chalkduster")
    let playerPromptLine2 = SKLabelNode(fontNamed: "Chalkduster")
    var wordArray:[String] = Array()
    var globalPassphraseField = UITextField()
   // var passcode:[Character] = Array()
    
    
    
    var inputtedPassphrase = String()
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        let passphraseField = UITextField(frame:CGRectMake(self.size.width/2, 20, 2*view.frame.width/3, 60))
        passphraseField.center.x = view.center.x
        passphraseField.backgroundColor = UIColor.blackColor()
        passphraseField.font = UIFont(name: "Avenir", size: tileFontSize)
        passphraseField.textAlignment = NSTextAlignment.Center
        passphraseField.keyboardType = UIKeyboardType.ASCIICapable
        passphraseField.autocorrectionType = UITextAutocorrectionType.No
        passphraseField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
       // passphraseField.placeholder = "- - - -"
        passphraseField.textColor = UIColor.whiteColor()
        passphraseField.returnKeyType = UIReturnKeyType.Done
        passphraseField.delegate = self
        let placeholderColor = UIColor.whiteColor()
        passphraseField.attributedPlaceholder = NSAttributedString(string:"- - - -", attributes:[NSForegroundColorAttributeName: placeholderColor])
        globalPassphraseField = passphraseField
        
        playerPromptLine1.text = "SET MASTERPASS."
        playerPromptLine1.position = CGPointMake(self.frame.midX, self.frame.midY)
        playerPromptLine1.fontSize = 30
        
        self.addChild(playerPromptLine1)
        
        playerPromptLine2.text = "THEN PASS TO HACKER."
        playerPromptLine2.position = CGPointMake(playerPromptLine1.position.x, playerPromptLine1.position.y-30)
        playerPromptLine2.fontSize = 30
        
        self.addChild(playerPromptLine2)
    
        
        let path = NSBundle.mainBundle().pathForResource("everyfourletterword", ofType: "txt")
        let content = NSString.stringWithContentsOfFile(path!, encoding: NSUTF8StringEncoding, error: nil)
        let upperContent = content.uppercaseString
        wordArray = upperContent.componentsSeparatedByString("\n")
        
        view.addSubview(passphraseField)

        self.backgroundColor = UIColor.blackColor()
        

    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (countElements(textField.text)) > 3 {
            let swiftRange = advance(textField.text.startIndex, 3)..<advance(textField.text.startIndex, 4)
            textField.text = textField.text.stringByReplacingCharactersInRange(swiftRange, withString: "")
        }
        
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        inputtedPassphrase = textField.text.uppercaseString
        println(textField.text)
        textField.resignFirstResponder()
        println(vc.passcode)
        if (vc.passcode.isEmpty && find(wordArray, inputtedPassphrase) != nil) {
            println("setting password!")
            vc.passcode = Array(textField.text)
            textField.text = nil
            playerPromptLine1.text = "THINK YOU CAN"
            playerPromptLine2.text = "HACK IT?"
            
        }
        else if (vc.passcode.isEmpty && find(wordArray, inputtedPassphrase) == nil){
            textField.text = nil
            playerPromptLine1.text = "HAS TO BE A WORD."
            playerPromptLine2.text = "EASIER TO REMEMBER."
        }
        else if (find(wordArray, inputtedPassphrase) == nil){
            textField.text = nil
            playerPromptLine1.text = "YOU CAN ONLY GUESS"
            playerPromptLine2.text = "ENGLISH WORDS."
        }
        else {
            println("evaluating guess")
            textField.text = nil
            
            if (playerPromptLine1.parent != nil) {
                playerPromptLine1.text = ""
                playerPromptLine2.text = ""
            }

            self.evaluateGuess(inputtedPassphrase)
        }
        return false
    }
    
    
    
    func evaluateGuess(guessText: String) {
        numberOfGuesses++
        var workingPasscode = vc.passcode
        var arrayOfLetters = Array(guessText.uppercaseString)
       // let killArray:[Character] = [!,!,!,!]
        let killCharacter: Character = "!"
        
        for var i = 0; i < arrayOfLetters.count; ++i {
        //create a filtered array for each letter, and count the elements in the array.
            let guessResult = 0
            
            
            //first check for perfect matches

            if (arrayOfLetters[i] == workingPasscode[i]){
                println("right letter right place!")
            self.createGuessResultWithText(String(arrayOfLetters[i]), withResult:2, inPosition:i)
               // println(passcode[i])
                workingPasscode[i] = Character("!") //this is good
                arrayOfLetters[i] = Character("!")
            }
        }
        for var i = 0; i < arrayOfLetters.count; ++i {
        
            //then check for imperfect matches
            if ((find(workingPasscode, arrayOfLetters[i]) != nil) && (arrayOfLetters[i] != Character("!"))) {
                println("right letter wrong place!")
                self.createGuessResultWithText(String(arrayOfLetters[i]), withResult:1, inPosition:i)
                
                workingPasscode[find(workingPasscode, arrayOfLetters[i])!] = Character("!") //this is good
                arrayOfLetters[i] = Character("!") //this is good
             //   println(passcode[i])

            }
            
            else if (arrayOfLetters[i] != Character("!")){
                println("wrong letter, wrong place")
                self.createGuessResultWithText(String(arrayOfLetters[i]), withResult:0, inPosition:i)
            }
        
        
        }
        
        
        //self.createGuessRow(guessText)
    }
    
    func createGuessResultWithText(text:String, withResult result:Int, inPosition position:Int) {
        
        
        let arrayOfLetters = Array(inputtedPassphrase)
        let leftmostPosition = self.frame.midX - CGFloat(arrayOfLetters.count-1)*guessLetterWidth/2
        let topmostPosition:CGFloat = 80.0
        
        
        var letterNode = SKSpriteNode()

        
        if result == 2 {
            
           // let letterNode = SKSpriteNode(color: UIColor.redColor(), size:CGSizeMake(guessLetterWidth, guessLetterHeight))
            letterNode = SKSpriteNode(imageNamed: "Oval.png")

            
            
        }
            
        else if result == 1 {
            letterNode = SKSpriteNode(imageNamed: "Rectangle.png")

            
        }
        
        
       // theShapePath.position = CGPointMake(leftmostPosition+(CGFloat(position)*guessLetterWidth),self.frame.midY)
      //  theShapePath.strokeColor = UIColor.whiteColor()
      //  theShapePath.lineWidth = 10
        
        

        letterNode.size = CGSizeMake(guessLetterWidth, guessLetterHeight)
        letterNode.position = CGPointMake(leftmostPosition+(CGFloat(position)*guessLetterWidth),self.frame.height-(topmostPosition+(CGFloat(numberOfGuesses)*guessLetterHeight)+verticalTileSpacing))

        
        let letterLabelNode = SKLabelNode(fontNamed: "Avenir")
        letterLabelNode.fontSize = tileFontSize
        letterLabelNode.fontColor = tileFontColor
        letterLabelNode.fontName = "Avenir"
        letterLabelNode.text = text
        letterLabelNode.position = CGPointMake(0,-14)
        
        letterNode.addChild(letterLabelNode)
        self.addChild(letterNode)


        
        
      //  theShapePath.addChild(letterLabelNode)
     //   println(self.children)
 
    }
    
    
    
    


    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    //    println("huh")
        
        

          }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
       // println(countElements(inputtedPassphrase))
    }
    

}
