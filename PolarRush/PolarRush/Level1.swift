//
//  Level1.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 10/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class Level1: PolarRushScene{
	
	override func didMove(to view: SKView) {
		
		super.didMove(to: self.view!)
		let newBox = GiftBox()
		self.addChild(newBox)
		
		displayInstructions()
		
	}
	
	func displayInstructions(){
		
		// TODO: We can make it part of the SuperClass, PolarRUsh and override it with new instructionset everylevel.
		
		if SKTGameController.sharedInstance.gameControllerType == controllerType.extended{
			// MARK: Using an external controller. Use different instructions.
		}else{
			let instructions = ["Swipe in any direction to move.", "Reach the spiral to advance"]
			self.printOnScreen(data: instructions, timeDelay: 3)
		}
		
	}
	
	func printOnScreen( data: [String], timeDelay: Double ){
		// MARK: Use this function to display all sorts of text on screen. We can make it part of the super class.
		
		var i = 0.0
		var newLabelNode = SKLabelNode(fontNamed: "Arial")
		
		for ins in data{
			
			// TODO: Change the font
			newLabelNode.text = ins
			newLabelNode.position = CGPoint(x: 0, y: (self.view?.frame.size.height)!/4)
			newLabelNode.zPosition = 4
			newLabelNode.name = "newLabel"
			
			// MARK: THe displaying part.
			
			// TODO: Use timers.
			newLabelNode.run(
				SKAction.sequence(
					[
						SKAction.wait(forDuration: timeDelay * i),
						SKAction.run({self.addChild(newLabelNode)}),
						SKAction.wait(forDuration: GameControl.gameControl.displayTime),
						SKAction.fadeOut(withDuration: GameControl.gameControl.fadeOutTime),
						SKAction.run({
							newLabelNode.removeFromParent()
						})
					]
				)
			)
			
			i += 1.0
			
		}
		
	}
	
}
