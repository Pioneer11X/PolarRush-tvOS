//
//  Level3.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 13/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class Level3: PolarRushScene{
	
	override func didMove(to view: SKView) {
		
		super.didMove(to: self.view!)
		
		let newBox = GiftBox()
		newBox.position = CGPoint(x: self.frame.size.width/2 - 100, y: -1 * self.frame.size.height/2 + 100)
		self.addChild(newBox)
		
		displayInstructions()
		
	}
	
	
	
	func displayInstructions(){
		
		// TODO: We can make it part of the SuperClass, PolarRUsh and override it with new instructionset everylevel.
		
		if SKTGameController.sharedInstance.gameControllerType == controllerType.extended{
			// MARK: Using an external controller. Use different instructions.
		}else{
			let instructions = ["Swipe in any direction to move.", "Reach the spiral to advance"]
			//			self.printOnScreen(data: instructions, timeDelay: 3)
		}
		
	}
	
	//	func printOnScreen( data: [String], timeDelay: Double ){
	//
	//		// MARK: Use this function to display all sorts of text on screen. We can make it part of the super class.
	//
	//
	//
	//		var i = 0
	//
	//		for i in 0..<data.count-1{
	//			let _ = Timer.scheduledTimer(timeInterval: timeDelay, target: self, selector: Selector("printIns(text: data[i])"), userInfo: data[i], repeats: false)
	//		}
	//	}
}

extension Level3{
	
	@objc func printIns( text: String ){
		
		// TODO: Change the font here.
		let newLabelNode = SKLabelNode(fontNamed: "Arial")
		
		newLabelNode.text = text
		newLabelNode.position = CGPoint(x: 0, y: (self.view?.frame.size.height)!/4)
		newLabelNode.zPosition = 4
		newLabelNode.name = "newLabel"
		newLabelNode.fontColor = UIColor.white
	}
	
}
