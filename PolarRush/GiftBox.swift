//
//  GiftBox.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 09/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class GiftBox: SKSpriteNode{
	
	init() {
		
		let boxTexture = SKTexture(imageNamed: "gift")
		
		super.init(texture: boxTexture, color: UIColor.blue, size: GameControl.gameControl.blockSize)
		self.name = "giftBox"
		
		self.physicsBody = SKPhysicsBody(rectangleOf: GameControl.gameControl.blockSize, center: self.position)
		
		self.physicsBody?.categoryBitMask = PhysicsCategory.giftBoxCategory
		self.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
		self.physicsBody?.collisionBitMask = CollisionCategory.giftBoxCategory
		self.physicsBody?.affectedByGravity = false
		
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func removeGiftBox(){
		// MARK: Add the score here.
		self.removeFromParent()
	}
	
}
