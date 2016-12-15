//
//  Level3.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 13/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class Level4: PolarRushScene{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let rightWallPos = (self.childNode(withName: "rightWall")?.position.x)! - (self.childNode(withName: "rightWall")?.frame.size.width)!/2
        
        let test = [
            CGPoint(x: rightWallPos - 100, y: -1 * self.frame.size.height/2 + 100)
        ]
        self.addGiftBoxPos(arrayOfPos: test)
        
        let enemies = [
            CGPoint(x: 250, y: 250)
        ]
        self.addEnemies(arrayOfPos: enemies)
    }

	
	override func didMove(to view: SKView) {
		super.didMove(to: self.view!)
		displayInstructions()
	}
	
	func displayInstructions(){
		
		// TODO: We can make it part of the SuperClass, PolarRUsh and override it with new instructionset everylevel.
		
		if SKTGameController.sharedInstance.gameControllerType == controllerType.extended{
			// MARK: Using an external controller. Use different instructions.
		}else{
			let instructions = ["Swipe in any direction to move.", "Reach the spiral to advance"]
		}
	}
}

extension Level4{
	
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
