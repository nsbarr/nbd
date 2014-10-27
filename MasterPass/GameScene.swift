//
//  GameScene.swift
//  MasterPass
//
//  Created by nick barr on 10/13/14.
//  Copyright (c) 2014 poemsio. All rights reserved.
//

import SpriteKit
import UIKit
import QuartzCore

class GameScene: SKScene, UITextFieldDelegate {
    
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
    var animator = UIDynamicAnimator()
    var originPoint:CGPoint = CGPoint(x: 0.0,y: 0.0)
    var inputtedPassphrase = String()
    var blurEffectView:UIVisualEffectView!
    let topmostPosition:CGFloat = 0.0
    var yPositionOfLowestRow:CGFloat = 99999
    var lettersInWord = 5

    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        self.backgroundColor = UIColor.blackColor()
        
        let path = NSBundle.mainBundle().pathForResource("everyfiveletterword", ofType: "txt")
        let content = NSString(contentsOfFile: path!, encoding: NSUTF8StringEncoding, error: nil)
        let upperContent = content!.uppercaseString
        wordArray = upperContent.componentsSeparatedByString("\n")
    
        
        
        var masterpassLogo = UIImage(named: "masterpasslogo.png")
        let logoArea = UIImageView(frame: CGRect(x:(view.frame.width-256)/2,y:view.frame.height/2-250,width:256,height:125))
        logoArea.image = masterpassLogo
        view.addSubview(logoArea)
        
        
        var playerVComputer = MenuButton(frame: CGRect(x:(view.frame.width-200)/2,y:view.frame.height/2+40,width:200,height:40))
        playerVComputer.setTitle("P1 v CP", forState: .Normal)
        playerVComputer.addTarget(self, action: Selector("pvcButtonPressed:"), forControlEvents: .TouchUpInside)
        view.addSubview(playerVComputer)
        
        var playerVPlayer = MenuButton(frame: CGRect(x:(view.frame.width-200)/2,y:view.frame.height/2+100,width:200,height:40))
        playerVPlayer.setTitle("P1 v P2", forState: .Normal)
        playerVPlayer.addTarget(self, action: Selector("pvpButtonPressed:"), forControlEvents: .TouchUpInside)
        view.addSubview(playerVPlayer)
        
        let handleTap = UITapGestureRecognizer(target: self, action: Selector("hideKeyboard:"))
        self.view?.addGestureRecognizer(handleTap)

    }
    
    func pvcButtonPressed(sender: UIButton){
        
        for subview in self.view!.subviews {
            subview.removeFromSuperview()
        }
        

        self.computerMasterPass()
        
        
    }
    
    func pvpButtonPressed(sender: UIButton){
        for subview in view!.subviews {
            subview.removeFromSuperview()
        }
        self.enterMasterPass()
    }
    
    func hideKeyboard(sender: UITapGestureRecognizer){
        globalPassphraseField.text = nil
        globalPassphraseField.resignFirstResponder()
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if (countElements(textField.text)) > lettersInWord-1 {
            let swiftRange = advance(textField.text.startIndex, lettersInWord-1)..<advance(textField.text.startIndex, lettersInWord)
            textField.text = textField.text.stringByReplacingCharactersInRange(swiftRange, withString: "")
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.animateView(self.view!, up: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        self.animateView(self.view!, up: false)
    }
    
    func animateView(viewToAnimate:UIView, up:Bool){
        

        let movementDistance = -200 //ToDo: this shouldn't be static
        let movement = (up ? movementDistance : -movementDistance)
        UIView.beginAnimations("animateView", context: nil) //ToDo: use blocks instead
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(0.2)
      
        
        if yPositionOfLowestRow < 340 {
            view!.frame = CGRectOffset(view!.frame,0,CGFloat(movement))
        }
        else {
             globalPassphraseField.frame = CGRectOffset(globalPassphraseField.frame, 0, CGFloat(movement))
        }
        

        
//        if up {
//       //     let filter = CIFilter(name: "CIGaussianBlur")
////            let blurLevel = 40.0
////            filter.setValue(NSNumber(double: blurLevel), forKey: "inputRadius")
//         //   self.shouldEnableEffects = true
//    //        self.filter = filter
//            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Dark)
//            blurEffectView = UIVisualEffectView(effect: blurEffect)
//            let vibrancyEffect = UIVibrancyEffect(forBlurEffect: blurEffect)
//            blurEffectView.frame = view!.bounds //view is self.view in a UIViewController
//            view!.insertSubview(blurEffectView, belowSubview: globalPassphraseField)
//            //if you have more UIViews on screen, use insertSubview:belowSubview: to place it underneath the lowest view
//            
//            //add auto layout constraints so that the blur fills the screen upon rotating device
//            blurEffectView.setTranslatesAutoresizingMaskIntoConstraints(false)
//            view!.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Top, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Top, multiplier: 1, constant: 0))
//            view!.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Bottom, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Bottom, multiplier: 1, constant: 0))
//            view!.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Leading, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Leading, multiplier: 1, constant: 0))
//            view!.addConstraint(NSLayoutConstraint(item: blurEffectView, attribute: NSLayoutAttribute.Trailing, relatedBy: NSLayoutRelation.Equal, toItem: view, attribute: NSLayoutAttribute.Trailing, multiplier: 1, constant: 0))
//        }
//        else {
////            self.filter = nil
////            self.shouldEnableEffects = false
//            blurEffectView.removeFromSuperview()
//        }
      
    }

    
    
    func computerMasterPass() {
        let randomIndex = Int(arc4random_uniform(UInt32(wordArray.count)))
        vc.passcode = Array(wordArray[randomIndex])
        println(vc.passcode)
        
        self.generatepassphraseField()
        
        playerPromptLine1.text = "THINK YOU CAN"
        playerPromptLine1.position = CGPointMake(self.frame.midX, self.frame.midY)
        playerPromptLine1.fontSize = 30
        
        self.addChild(playerPromptLine1)
        
        playerPromptLine2.text = "HACK IT?"
        playerPromptLine2.position = CGPointMake(playerPromptLine1.position.x, playerPromptLine1.position.y-30)
        playerPromptLine2.fontSize = 30
        
        self.addChild(playerPromptLine2)
    }
    
    
    func enterMasterPass() {
        vc.passcode = []
        self.generatepassphraseField()

        playerPromptLine1.text = "SET MASTERPASS."
        playerPromptLine1.position = CGPointMake(self.frame.midX, self.frame.midY)
        playerPromptLine1.fontSize = 30
        
        self.addChild(playerPromptLine1)
        
        playerPromptLine2.text = "THEN PASS TO HACKER."
        playerPromptLine2.position = CGPointMake(playerPromptLine1.position.x, playerPromptLine1.position.y-30)
        playerPromptLine2.fontSize = 30
        
        self.addChild(playerPromptLine2)
    }
    
    func generatepassphraseField() {
        let passphraseField = UITextField(frame:CGRectMake(0, view!.frame.height-100, view!.frame.width, 60))
        passphraseField.center.x = view!.center.x
        
        passphraseField.font = UIFont(name: "Avenir", size: tileFontSize)
        passphraseField.textAlignment = NSTextAlignment.Center
        passphraseField.keyboardType = UIKeyboardType.ASCIICapable
        passphraseField.autocorrectionType = UITextAutocorrectionType.No
        passphraseField.keyboardAppearance = UIKeyboardAppearance.Dark
        passphraseField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        passphraseField.textColor = UIColor.blackColor()
        passphraseField.returnKeyType = UIReturnKeyType.Done
        passphraseField.delegate = self
        passphraseField.tintColor = UIColor.blackColor()
       // passphraseField.borderStyle = UITextBorderStyle.Bezel
       // let pattern = UIImage(named: "bo_play_pattern.png")
       // passphraseField.backgroundColor = UIColor(patternImage: pattern!)
        passphraseField.backgroundColor = UIColor.whiteColor()
        let placeholderColor = UIColor.blackColor()
        passphraseField.attributedPlaceholder = NSAttributedString(string:"● ● ● ●", attributes:[NSForegroundColorAttributeName: placeholderColor])
        globalPassphraseField = passphraseField
        view!.addSubview(passphraseField)

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        inputtedPassphrase = textField.text.uppercaseString
        println(textField.text)
        textField.resignFirstResponder()
        if (vc.passcode.isEmpty && find(wordArray, inputtedPassphrase) != nil) {
            println("setting password!")
            vc.passcode = Array(textField.text.uppercaseString)
            println(vc.passcode)
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
      //      self.shakeTheView()
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
        if (vc.passcode == arrayOfLetters) {
            self.winState()
        }
        
        
        
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
        
        
        var letterNode = SKSpriteNode()

        
        if result == 2 {
            
           // let letterNode = SKSpriteNode(color: UIColor.redColor(), size:CGSizeMake(guessLetterWidth, guessLetterHeight))
            letterNode = SKSpriteNode(imageNamed: "Oval.png")

            
            
        }
            
        else if result == 1 {
            letterNode = SKSpriteNode(imageNamed: "Rectangle.png")

            
        }
        
       letterNode.position = CGPointMake(leftmostPosition+(CGFloat(position)*guessLetterWidth),self.frame.height-(topmostPosition+(CGFloat(numberOfGuesses)*guessLetterHeight)+verticalTileSpacing))
        
        
        if letterNode.position.y < yPositionOfLowestRow {
            yPositionOfLowestRow = letterNode.position.y
            println(yPositionOfLowestRow)
        }
        
        letterNode.size = CGSizeMake(0.2,0.2)

        
        let letterLabelNode = SKLabelNode(fontNamed: "Avenir")
        letterLabelNode.fontSize = tileFontSize
        letterLabelNode.fontColor = tileFontColor
        letterLabelNode.fontName = "Avenir"
        letterLabelNode.text = text
        letterLabelNode.position = CGPointMake(0,-14)
        
        
        letterNode.setScale(0.0)

        let letterGrow = SKAction.scaleTo(1.0, duration: 0.4)
        
        //letterNode.runAction(letterGrow)
        
        
        let fadeIn = SKAction.fadeInWithDuration(0.4)
        let scaleToSize = SKAction.resizeToWidth(guessLetterWidth, height:guessLetterHeight, duration: 0.4)
        let wait = SKAction.waitForDuration(0.5)
        let fadeInAndScaleUp = SKAction.group([fadeIn,scaleToSize])
        
        //letterNode.runAction(fadeInAndScaleUp)
    
        
        let actionSequence = SKAction.sequence([letterGrow, wait, fadeInAndScaleUp])
        letterNode.runAction(actionSequence)
        
        letterNode.addChild(letterLabelNode)
        self.addChild(letterNode)
        



        
        
      //  theShapePath.addChild(letterLabelNode)
     //   println(self.children)
 
    }
    
    
    func winState(){
        println("you win")
     //   for child in self.children {
    //        child.removeFromParent()
    //    }
        globalPassphraseField.removeFromSuperview()
        vc.defineWord()
    }
    


    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
    //    println("huh")
        
        

          }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
       // println(countElements(inputtedPassphrase))
    }
    

}
