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
	
	var newGameNode: SKLabelNode?
	var optionsNode: SKLabelNode?
	var instructionsNode: SKLabelNode?
	
	var selectedOption: Int = 0
	
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
		
	}
	
	func setupLabels(){
		
		newGameNode = self.childNode(withName: "newGame") as! SKLabelNode?
		optionsNode = self.childNode(withName: "options") as! SKLabelNode?
		instructionsNode = self.childNode(withName: "instructions") as! SKLabelNode?
		
		newGameNode?.position = CGPoint(x: 0, y: (self.view?.frame.size.height)!/4);
		instructionsNode?.position = CGPoint(x: 0, y: 0);
		optionsNode?.position = CGPoint(x: 0, y: -1 * (self.view?.frame.size.height)!/4);
		
	}
	
	func updateLabels(){
		
		switch selectedOption {
		case 0:
			newGameNode?.fontSize = highlightedFontSize
			instructionsNode?.fontSize = originalFontSize
			optionsNode?.fontSize = originalFontSize
		case 1:
			newGameNode?.fontSize = originalFontSize
			instructionsNode?.fontSize = highlightedFontSize
			optionsNode?.fontSize = originalFontSize
		case 2:
			newGameNode?.fontSize = originalFontSize
			instructionsNode?.fontSize = originalFontSize
			optionsNode?.fontSize = highlightedFontSize
		default:
			newGameNode?.fontSize = originalFontSize
			instructionsNode?.fontSize = originalFontSize
			optionsNode?.fontSize = originalFontSize
		}
		
	}
	
	func remoteTapped(){
//		print("Tap Recognised");
		switch selectedOption {
		case 0:
			// MARK: -- Call Load Game Scene Here
			print("NewGame Selected")
			GameControl.gameControl.gameViewController?.loadGameScene()
		case 1:
			GameControl.gameControl.gameViewController?.loadLevel1()
			print("Instructions Selected")
		case 2:
			print("Options Selected")
		default:
			print("No Kappa")
		}
	}
	
	func setupTapRecognizers(){
		
		let newTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(remoteTapped));
		newTapRecognizer.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
		self.view?.addGestureRecognizer(newTapRecognizer)
		
	}
	
}
