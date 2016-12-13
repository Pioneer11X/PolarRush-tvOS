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
	
	var nGNIP: CGPoint?
	var cNIP: CGPoint?
	var oNIP: CGPoint?
	
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
		
		nGNIP = newGameNode?.position
		cNIP = creditsNode?.position
		oNIP = optionsNode?.position
		
//		newGameNode?.position = CGPoint(x: 0, y: (self.view?.frame.size.height)!/4);
//		optionsNode?.position = CGPoint(x: 0, y: 0);
//		creditsNode?.position = CGPoint(x: 0, y: -1 * (self.view?.frame.size.height)!/4);
		
	}
	
	func updateLabels(){
		
		switch selectedOption {
			
		case 0:
			resetLabels()
			newGameNode?.run(SKAction.move(by: GameControl.gameControl.menuMovementDistance, duration: GameControl.gameControl.menuMovementTime))
		case 1:
			resetLabels()
			optionsNode?.run(SKAction.move(by: GameControl.gameControl.menuMovementDistance, duration: GameControl.gameControl.menuMovementTime))
		case 2:
			resetLabels()
			creditsNode?.run(SKAction.move(by: GameControl.gameControl.menuMovementDistance, duration: GameControl.gameControl.menuMovementTime))
		default:
			resetLabels()
		}
	}
	
	func resetLabels(){
		newGameNode?.run(SKAction.move(to: nGNIP!, duration: GameControl.gameControl.menuMovementTime))
		optionsNode?.run(SKAction.move(to: oNIP!, duration: GameControl.gameControl.menuMovementTime))
		creditsNode?.run(SKAction.move(to: cNIP!, duration: GameControl.gameControl.menuMovementTime))
	}
	
	func remoteTapped(){
//		print("Tap Recognised");
		switch selectedOption {
		case 0:
			// MARK: -- Call Load Game Scene Here
			print("NewGame Selected")
			GameControl.gameControl.gameViewController?.loadLevel1()
		case 1:
			// TODO: -- Call Options Scene here.
			GameControl.gameControl.gameViewController?.loadLevel1()
			print("Options Selected")
		case 2:
			// TODO: Show Credits scene here.
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
