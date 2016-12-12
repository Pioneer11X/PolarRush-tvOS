//
//  Door.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 11/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class Door: SKSpriteNode{
	
	var doorAlreadyReached = false
	
	var doorReached = false{
		didSet(newValue){
			if newValue == true && !doorAlreadyReached{
				doorAlreadyReached = true
				shrink()
			}
		}
	}
	
	init() {
		
		let newTexture = SKTexture(imageNamed: "redBlueSpiral")
		
		super.init(texture: newTexture, color: UIColor.white, size: GameControl.gameControl.blockSize)

		
		
//		self.physicsBody = SKPhysicsBody(circleOfRadius: GameControl.gameControl.blockSize.width/2, center: self.position)
		
//		self.physicsBody?.affectedByGravity = false
//		self.physicsBody?.categoryBitMask = PhysicsCategory.doorCategory
//		self.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
//		self.physicsBody?.collisionBitMask = 0
//		self.physicsBody?.isDynamic = false
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func shrink(){
		self.run(SKAction.scaleX(by: 0.5, y: 0.5, duration: 1))
	}
	
}
