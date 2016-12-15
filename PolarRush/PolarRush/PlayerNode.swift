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
		self.physicsBody?.contactTestBitMask = PhysicsCategory.platformCategory | PhysicsCategory.giftBoxCategory
		self.physicsBody?.allowsRotation = false
		self.physicsBody?.mass = GameControl.gameControl.playerMass
	}
	
	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}
	
	func moveLeft(){
//		if canMove{
//			canMove = false
            let newTexture = SKTexture(imageNamed: "myElfLeft")
            self.run(SKAction.setTexture(newTexture))
            self.position = self.position - CGPoint(x: GameControl.gameControl.movementSpeed, y: 0)
//            canMove = true
//		}
	}
	
	func moveLeftImpulse(){
		if canMove{
			canMove = false
			self.physicsBody?.applyImpulse(CGVector(dx: -1 * GameControl.gameControl.movementImpulse, dy: 0))
			
			let newTexture = SKTexture(imageNamed: "myElfLeft")
//			let newTexture = SKTexture(
			self.run(
				SKAction.sequence(
					[
						SKAction.group([
							SKAction.wait(forDuration: GameControl.gameControl.movementTime),
							SKAction.setTexture(newTexture)
							]),
						SKAction.run({
							self.canMove = true
						})
					]
				)
			)
		}
	}
	
	func moveRightImpulse(){
		if canMove{
			canMove = false
			self.physicsBody?.applyImpulse(CGVector(dx: GameControl.gameControl.movementImpulse, dy: 0))
			let newTexture = SKTexture(imageNamed: "myElf")
			self.run(
				SKAction.sequence(
					[
						SKAction.group([
							SKAction.setTexture(newTexture),
							SKAction.wait(forDuration: GameControl.gameControl.movementTime)
						]
						),
						SKAction.run({
							self.canMove = true
						})
					]
				)
			)
		}
	}
	
	func moveRight(){
//		if canMove{
//			canMove = false
            let newTexture = SKTexture(imageNamed: "myElf")
            self.run(SKAction.setTexture(newTexture))
            self.position = self.position + CGPoint(x: GameControl.gameControl.movementSpeed, y: 0)
//            canMove = true
//		}
	}
	
	func jump(){
		if canJump{
			canJump = false
            canMove = false
			self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 50))
			SKTAudio.sharedInstance().playSoundEffect(filename: "Jump-SoundBible.mp3")
		}
	}
	
}
