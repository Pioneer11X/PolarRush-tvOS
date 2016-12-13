//
//  MenuScene.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 07/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class MenuScene: SKScene{
	
	var originalFontSize: CGFloat = 144;
	var highlightedFontSize: CGFloat = 200;
	
	var newGameNode: SKSpriteNode?
	var creditsNode: SKSpriteNode?
	var optionsNode: SKSpriteNode?
	
	var selectedOption: Int = 0
	
	var canSelect: Bool = true{
		
		didSet(newSelect){
			if !newSelect{
				let _ = Timer.scheduledTimer(withTimeInterval: GameControl.gameControl.menuDelay, repeats: false){_ in
					self.canSelect = true
				}
			}
		}
		
	}
	
	// MARK: -- Variables used for selection
	var initialLocation: CGPoint = CGPoint.zero ; // Think this is not needed here.
	var finalLocation: CGPoint?;
	
	override func didMove(to view: SKView) {
		
		setupLabels();
		setupTapRecognizers()
		
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		if let touch = touches.first{
			finalLocation = touch.location(in: self)
		}
		
		let check = (finalLocation?.y)! - initialLocation.y
		
		if check > 0 {
			if selectedOption > 0{
				selectedOption -= 1;
			}else{
				selectedOption = 2;
			}
		}else if check < 0 {
			if selectedOption < 2{
				selectedOption += 1;
			}else{
				selectedOption = 0;
			}
		}
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		
		updateLabels();
		useController()
		
	}
	
	func setupLabels(){
		
		newGameNode = self.childNode(withName: "newGameNode") as! SKSpriteNode?
		creditsNode = self.childNode(withName: "creditsNode") as! SKSpriteNode?
		optionsNode = self.childNode(withName: "optionsNode") as! SKSpriteNode?
		
		newGameNode?.position = CGPoint(x: 0, y: (self.view?.frame.size.height)!/4);
		optionsNode?.position = CGPoint(x: 0, y: 0);
		creditsNode?.position = CGPoint(x: 0, y: -1 * (self.view?.frame.size.height)!/4);
		
	}
	
	func updateLabels(){
		
		switch selectedOption {
		case 0:
			newGameNode?.setScale(GameControl.gameControl.menuHighlightedScale)
			optionsNode?.setScale(GameControl.gameControl.menuInitialScale)
			creditsNode?.setScale(GameControl.gameControl.menuInitialScale)
		case 1:
			newGameNode?.setScale(GameControl.gameControl.menuInitialScale)
			optionsNode?.setScale(GameControl.gameControl.menuHighlightedScale)
			creditsNode?.setScale(GameControl.gameControl.menuInitialScale)
		case 2:
			newGameNode?.setScale(GameControl.gameControl.menuInitialScale)
			optionsNode?.setScale(GameControl.gameControl.menuInitialScale)
			creditsNode?.setScale(GameControl.gameControl.menuHighlightedScale)
		default:
			newGameNode?.setScale(GameControl.gameControl.menuInitialScale)
			optionsNode?.setScale(GameControl.gameControl.menuInitialScale)
			creditsNode?.setScale(GameControl.gameControl.menuInitialScale)
		}
		
	}
	
	func remoteTapped(){
//		print("Tap Recognised");
		switch selectedOption {
		case 0:
			// MARK: -- Call Load Game Scene Here
			print("NewGame Selected")
			GameControl.gameControl.gameViewController?.loadLevel1()
		case 1:
			// TODO: -- Call Instructions Scene here.
			GameControl.gameControl.gameViewController?.loadLevel1()
			print("Options Selected")
		case 2:
			// TODO: Show options scene here.
			print("Credits Selected")
		default:
			print("No Kappa")
		}
	}
	
	func setupTapRecognizers(){
		
		let newTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(remoteTapped));
		newTapRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
		self.view?.addGestureRecognizer(newTapRecognizer)
		
	}
	
	func useController(){
		if SKTGameController.sharedInstance.gameControllerConnected{
			if SKTGameController.sharedInstance.gameControllerType == controllerType.extended && self.canSelect{
				if (SKTGameController.sharedInstance.gameController.extendedGamepad?.leftThumbstick.down.isPressed)!{
					if selectedOption > 0{
						selectedOption -= 1;
					}else{
						selectedOption = 2;
					}
					self.canSelect = false
				}
				
				if (SKTGameController.sharedInstance.gameController.extendedGamepad?.leftThumbstick.up.isPressed)!{
					if selectedOption < 2{
						selectedOption += 1;
					}else{
						selectedOption = 0;
					}
					self.canSelect = false
				}
				
				if (SKTGameController.sharedInstance.gameController.extendedGamepad?.buttonA.isPressed)!{
					remoteTapped()
				}
			}
		}
	}
	
}
