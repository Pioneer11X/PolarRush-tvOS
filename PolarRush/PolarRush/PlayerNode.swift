//
//  playerNode.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 09/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class PlayerNode: SKSpriteNode{
	
	var canMove: Bool = true
	var canJump: Bool = true
	
	init() {
//		super.init(imageNamed: "MyElf")
		let newTexture = SKTexture(imageNamed: "myElf")
		super.init(texture: newTexture, color: UIColor.red, size: GameControl.gameControl.blockSize)
		self.physicsBody = SKPhysicsBody(texture: newTexture, size: GameControl.gameControl.blockSize)
		self.physicsBody?.categoryBitMask = PhysicsCategory.playerCategory
		self.physicsBody?.contactTestBitMask = PhysicsCategory.platformCategory
		self.physicsBody?.allowsRotation = false
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func moveLeft(){
		if canMove{
			canMove = false
			self.run(SKAction.sequence(
				[
					SKAction.moveBy(x: -1 * GameControl.gameControl.movementSpeed, y: 0, duration: GameControl.gameControl.movementTime),
					SKAction.run( { self.canMove = true } )
				]
			))
		}
	}
	
	func moveRight(){
		if canMove{
			canMove = false
			self.run(SKAction.sequence(
				[
					SKAction.moveBy(x: GameControl.gameControl.movementSpeed, y: 0, duration: GameControl.gameControl.movementTime),
					SKAction.run( { self.canMove = true } )
				]
			))
		}
	}
	
	func jump(){
		if canJump{
			canJump = false
			self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
		}
	}
	
}
