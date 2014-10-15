//
//  EnterPasswordScene.swift
//  MasterPass
//
//  Created by nick barr on 10/14/14.
//  Copyright (c) 2014 poemsio. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class EnterPasswordScene: SKScene, UITextFieldDelegate {

    let tileFontSize:CGFloat = 40

    override func didMoveToView(view: SKView) {
        
        let passphraseField = UITextField(frame:CGRectMake(self.size.width/2, 20, 2*view.frame.width/3, 60))
        passphraseField.center.x = view.center.x
        passphraseField.backgroundColor = UIColor.whiteColor()
        passphraseField.font = UIFont(name: "Avenir", size: tileFontSize)
        passphraseField.textAlignment = NSTextAlignment.Center
        passphraseField.keyboardType = UIKeyboardType.ASCIICapable
        passphraseField.autocorrectionType = UITextAutocorrectionType.No
        passphraseField.autocapitalizationType = UITextAutocapitalizationType.AllCharacters
        passphraseField.placeholder = "- - - -"
        passphraseField.textColor = UIColor.grayColor()
        passphraseField.returnKeyType = UIReturnKeyType.Done
        passphraseField.delegate = self
        
        
        view.addSubview(passphraseField)
        
        self.backgroundColor = UIColor.blackColor()

    }

}