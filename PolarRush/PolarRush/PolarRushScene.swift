//
//  PolarRushScene.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 10/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class PolarRushScene: SKScene, SKPhysicsContactDelegate {
	
	private var newPlayer = PlayerNode()
	
	var isGamePaused: Bool = false{
		didSet(isGamePausedNew){
			if isGamePausedNew{
				self.view?.isPaused = true
			}else{
				self.view?.isPaused = false
			}
		}
	}
	
	// MARK: Movement variables:
	private var initialLocation: CGPoint = CGPoint.zero
	private var finalLocation: CGPoint = CGPoint.zero
	private var originalLocation: CGPoint = CGPoint.zero
	
	override func didMove(to view: SKView) {
		
		self.physicsWorld.contactDelegate = self
		self.addChild(newPlayer)
		newPlayer.position = CGPoint(x: 100, y: 100)
		newPlayer.zPosition = 5
		
	}
	
	override func update(_ currentTime: TimeInterval) {
		controllerSupport()
	}
	
	func touchDown(atPoint pos : CGPoint) {
		
	}
	
	func touchMoved(toPoint pos : CGPoint) {
		let diff: CGPoint = pos - initialLocation

		if diff.x < -10 {
			newPlayer.moveLeftImpulse()
		}else if diff.x > 10{
			newPlayer.moveRightImpulse()
		}
		
		if diff.y > 10{
			newPlayer.jump()
		}
		initialLocation = pos
	}
	
	func touchUp(atPoint pos : CGPoint) {
		initialLocation = CGPoint.zero
	}
	
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchDown(atPoint: t.location(in: self)) }
	}
	
	override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
	}
	
	override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
		for t in touches { self.touchUp(atPoint: t.location(in: self)) }
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		
		let check = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		if check == ( PhysicsCategory.playerCategory | PhysicsCategory.platformCategory ){
			newPlayer.canJump = true
		}else if check == PhysicsCategory.giftBoxCategory | PhysicsCategory.playerCategory{
			// TODO: Remove the giftbox here.
			if contact.bodyA.categoryBitMask == PhysicsCategory.giftBoxCategory{
				contact.bodyA.node?.removeFromParent()
			}else{
				contact.bodyB.node?.removeFromParent()
			}
		}
	}
	
	func playerJump(_ recognizer: UITapGestureRecognizer){
		self.newPlayer.jump()
	}
	
	func pauseCheck( _ recognizer: UITapGestureRecognizer){
		isGamePaused = !isGamePaused
		addPauseOverlay()
	}
	
	func addPauseOverlay(){
		// TODO: Add Pause Overlay.
	}
	
	func addGestureRecs(){
		
		let newRec = UITapGestureRecognizer(target: self, action: #selector(playerJump(_ :)))
		newRec.allowedPressTypes = [ NSNumber(value: UIPressType.select.rawValue ) ]
		self.view?.addGestureRecognizer(newRec)
		
		let pauseRec = UITapGestureRecognizer(target: self, action: #selector(pauseCheck(_:)))
		pauseRec.allowedPressTypes = [ NSNumber(value: UIPressType.playPause.rawValue) ]
		self.view?.addGestureRecognizer(pauseRec)
		
	}
	
	func controllerSupport(){
		
		if SKTGameController.sharedInstance.gameControllerConnected{
			
			if SKTGameController.sharedInstance.gameControllerType == controllerType.extended{
				
				if (SKTGameController.sharedInstance.gameController.extendedGamepad?.leftThumbstick.left.isPressed)!{
					newPlayer.moveLeftImpulse()
				}
				if (SKTGameController.sharedInstance.gameController.extendedGamepad?.leftThumbstick.right.isPressed)!{
					newPlayer.moveRightImpulse()
				}
				if (SKTGameController.sharedInstance.gameController.extendedGamepad?.buttonA.isPressed)!{
					newPlayer.jump()
				}
			}
		}

	}
	
}
