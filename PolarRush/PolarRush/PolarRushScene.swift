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
	private var newDoor = Door()
	private var won: Bool = false
	
	let scoreLabel: SKLabelNode = HUD.hud.scoreLabel
	let highscoreLabel: SKLabelNode = HUD.hud.highScoreLabel
	let timerLabel: SKLabelNode = HUD.hud.timerLabel
	
	let scoreNumberLabel: SKLabelNode = HUD.hud.scoreNumberLabel
	let highScoreNumberLabel: SKLabelNode = HUD.hud.highScoreNumberLabel
	let timerNumberLabel : SKLabelNode = HUD.hud.timerNumberLabel
	
	
	// TODO: This is bugging out when the delay between pause and unpause is kind of less than 2 seconds.
	var isGamePaused: Bool = false{
		didSet(isGamePausedNew){
			if self.isGamePaused{
				SKTAudio.sharedInstance().pauseBackgroundMusic()
				self.view?.isPaused = true
			}else{
				self.view?.isPaused = false
				SKTAudio.sharedInstance().backgroundMusicPlayer?.play()
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
		setupCamera()
//		newPlayer.position = CGPoint(x: 100, y: 100)
		newPlayer.position = CGPoint(x: 100, y: 100) + CGPoint(x: -1 * (self.view?.frame.size.width)!/2, y: -1 * (self.view?.frame.size.height)!/2)
		newPlayer.zPosition = 5
		
		
		newDoor.position = CGPoint(x: (self.view?.frame.size.width)!/2, y: (self.view?.frame.size.height)!/2) - CGPoint(x: 100, y: 100)
		newDoor.zPosition = 5
		
		
		GameControl.gameControl.resetLevelTimer()
		// TODO: Need to remove this and change this to unlock only when all the gift boxes are collected.
		unlockDoor()
		addGestureRecs()
		setupHUD()
		setupLevelTimer()
		
	}
	
	func unlockDoor(){
		// MARK: This needs to be called when all the giftboxes on the level are collected.
		// TODO: Add a function to check the giftboxes and call it in update.
		self.addChild(newDoor)
	}
	
	override func update(_ currentTime: TimeInterval) {
		updateHUD()
		controllerSupport()
		checkDoorReached()
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
			GameControl.gameControl.curScore += 10
		}
	}
	
	func playerJump(_ recognizer: UITapGestureRecognizer){
		self.newPlayer.jump()
	}
	
	func pauseCheck( _ recognizer: UITapGestureRecognizer){
		isGamePaused = !isGamePaused
//		addPauseOverlay()
	}
	
	func addPauseOverlay(){
		// TODO: Add Pause Overlay.
		if self.isGamePaused{
			addNodes(scene: self.scene!)
		}else{
			removeNodes(scene: self.scene!)
		}
		
	}
	
	func addGestureRecs(){
		
		let newRec = UITapGestureRecognizer(target: self, action: #selector(playerJump(_ :)))
		newRec.allowedPressTypes = [ NSNumber(value: UIPressType.select.rawValue ) ]
		self.view?.addGestureRecognizer(newRec)
		
		let pauseRec = UITapGestureRecognizer(target: self, action: #selector(pauseCheck(_:)))
		pauseRec.allowedPressTypes = [ NSNumber(value: UIPressType.playPause.rawValue) ]
		self.view?.addGestureRecognizer(pauseRec)
		
		let menuRec = UITapGestureRecognizer(target: self, action: #selector(goToMenu(_:)))
		menuRec.allowedPressTypes = [ NSNumber(value: UIPressType.menu.rawValue) ]
		self.view?.addGestureRecognizer(menuRec)
		
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
				
				if ( SKTGameController.sharedInstance.gameController.extendedGamepad?.rightTrigger.isPressed )!{
					isGamePaused = !isGamePaused
					// TODO: Need to fix unpausing using the controller.
				}
			}
		}

	}
	
	func checkDoorReached(){
		
		if newDoor.contains(newPlayer.position){
			if !newDoor.doorReached{
				self.won = true
				GameControl.gameControl.curScore += GameControl.gameControl.timer * GameControl.gameControl.curLevel
				GameControl.gameControl.gameViewController?.loadNextLevel()
			}
			// MARK: Door Reached.
			newDoor.doorReached = true
			
		}
		
	}
	
	private func setupCamera(){
//		self.camera = SKCameraNode() as! SKCameraNode
		self.camera = self.childNode(withName: "levelCamera") as? SKCameraNode
//		camera?.position = CGPoint(x: (self.view?.frame.size.width)!/2, y: (self.view?.frame.size.height)!/2)
		camera?.position = CGPoint.zero
	}
	
	private func setupHUD(){
		
		highscoreLabel.position = CGPoint(x: (self.camera?.position.x)! - 775, y: (self.camera?.position.y)! + 500)
		scoreLabel.position = CGPoint(x: (self.camera?.position.x)! - 775, y: 470)
		scoreNumberLabel.position = CGPoint(x: (self.camera?.position.x)! + 10 - 775, y: 470)
		highScoreNumberLabel.position = CGPoint(x: (self.camera?.position.x)! + 10 - 775, y: 500)
		timerLabel.position = CGPoint(x: (self.camera?.position.x)! - 775, y: 440)
		timerNumberLabel.position = CGPoint(x: (self.camera?.position.x)! + 10 - 775, y: 440)
		
		let nodes = [
			scoreLabel,
			highscoreLabel,
			timerLabel,
			
			scoreNumberLabel,
			highScoreNumberLabel,
			timerNumberLabel
		]
		
		for ins in nodes{
			ins.removeFromParent()
		}
		
		for ins in nodes{
			self.addChild(ins)
		}
		
	}
	
	private func setupLevelTimer(){
		
		_ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true){
			_ in
			if !self.won && GameControl.gameControl.timer > 0{
				GameControl.gameControl.timer -= 1
				
				self.scoreNumberLabel.text = "\(GameControl.gameControl.curScore)"
				self.highScoreNumberLabel.text = "\(GameControl.gameControl.highScore)"
				self.timerNumberLabel.text = "\(GameControl.gameControl.timer)"
			}
			if (GameControl.gameControl.timer < 1) {
				if !( self.childNode(withName: "flashedMessage") != nil ){
					self.flashMessage(text: "You were too late.", isInstruction: false)
				}
			}
		}
	}
	
	private func updateHUD(){
		
		self.timerNumberLabel.text = "\(GameControl.gameControl.timer)"
		self.scoreNumberLabel.text = "\(GameControl.gameControl.curScore)"
		self.highScoreNumberLabel.text = "\(GameControl.gameControl.highScore)"
		
	}
	
	@objc private func goToMenu(_ recognizer: UITapGestureRecognizer){
		GameControl.gameControl.gameViewController?.loadMenuScene()
	}
	
	func flashMessage(text: String, isInstruction: Bool){
		
		let textNode = SKLabelNode(fontNamed: GameConstants.gameConstants.fontName);
		textNode.text = text;
		textNode.name = "flashedMessage"
		
		if isInstruction{
			textNode.position = CGPoint(x: (self.camera?.position.x)! ,y: -150);
			textNode.zPosition = 5
			textNode.fontColor = UIColor.white
			textNode.fontSize = 32
			self.addChild(textNode)
			
			textNode.run(SKAction.sequence([
				SKAction.wait(forDuration: 2),
				SKAction.fadeOut(withDuration: 2)
				]))
		}else{
			textNode.position = CGPoint(x: (self.camera?.position.x)! ,y: 0);
			textNode.zPosition = 5
			textNode.fontColor = UIColor.white
			textNode.fontSize = 36
			self.addChild(textNode)
			
			textNode.run(SKAction.sequence([
				SKAction.repeat(SKAction.sequence([
					SKAction.scale(by: 2, duration: 0.5),
					SKAction.scale(by: 0.5, duration: 1)
					]),count: 3),
				SKAction.fadeOut(withDuration: 2)
				]))
		}
	}
	
}
