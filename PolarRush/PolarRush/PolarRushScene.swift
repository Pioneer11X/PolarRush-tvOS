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
    private var giftBoxPoints: [CGPoint] = []
    private var enemyPoints: [CGPoint] = []
    
    // MARK: Fixed update loop.
    private var lastTime: TimeInterval?
	
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
    
    private var rightPressed: Bool = false
    private var leftPressed: Bool = false
	
	override func didMove(to view: SKView) {
		
		self.physicsWorld.contactDelegate = self
		self.addChild(newPlayer)
		setupCamera()
//		newPlayer.position = CGPoint(x: 100, y: 100)
		newPlayer.position = CGPoint(x: 100, y: 100) + CGPoint(x: -1 * (self.view?.frame.size.width)!/2, y: -1 * (self.view?.frame.size.height)!/2)
		newPlayer.zPosition = 5
		
		
		newDoor.position = CGPoint(x: (self.view?.frame.size.width)!/2, y: (self.view?.frame.size.height)!/2) - CGPoint(x: 100, y: 100)
		newDoor.zPosition = 5
		
		
		GameControl.gameControl.resetLevel()
		
        setupGiftBoxes(giftBoxPoints: self.giftBoxPoints)
        setupEnemies(enemyPoints: enemyPoints)
		addGestureRecs()
		setupHUD()
		setupLevelTimer()
		
	}
    
    func setupGiftBoxes(giftBoxPoints: [CGPoint]){
        
        for pos in self.giftBoxPoints{
            
            let newBox = GiftBox()
            newBox.position = pos
            self.addChild(newBox)
            
        }
        
    }
    
    func setupEnemies(enemyPoints: [CGPoint]){
        for pos in self.enemyPoints{
            let enemyNode = Enemy()
            enemyNode.position = pos
            self.addChild(enemyNode)
            enemyNode.moveTheEnemy()
        }
    }
    
    public func addGiftBoxPos(arrayOfPos: [CGPoint]){
        for ins in arrayOfPos{
            self.giftBoxPoints.append(ins)
        }
    }
    
    public func addEnemies(arrayOfPos: [CGPoint]){
        for ins in arrayOfPos{
            self.enemyPoints.append(ins)
        }
    }
	
	func unlockDoor(){
		// MARK: This needs to be called when all the giftboxes on the level are collected.
		newDoor.removeFromParent()
		self.addChild(newDoor)
	}
	
	override func update(_ currentTime: TimeInterval) {
		
		if noMoreBoxes(){
			unlockDoor()
		}
        
        if lastTime != nil{
            lastTime = fixedUpdate(currentTime: currentTime, deltaTime: GameControl.gameControl.movementTime, lastTime: lastTime!)
        }else{
            lastTime = currentTime
        }
		
		updateHUD()
		controllerSupport()
		checkDoorReached()
		updateCamera()
	}
	
	func noMoreBoxes() -> Bool{
		if self.childNode(withName: "giftBox") != nil {
			return false
		}
		return true
	}
	
	func touchDown(atPoint pos : CGPoint) {
        if pos.x > 10 {
            rightPressed = true
        }else if pos.x < -10 {
            leftPressed = true
        }
	}
	
	func updateCamera(){
		
		if  ( modulus(value: ((self.camera?.position)! - self.newPlayer.position).x ) > self.frame.size.width/4 ){
			// TODO: Move Camera Here.
			
			// if the player crosses the width of the screen, Move it towards him.
			moveCamera(targetPos: getTargetPos())
			
		}
		
	}
	
	func getTargetPos() -> CGPoint{
		
		let leftWall = self.childNode(withName: "leftWall") as! SKSpriteNode
		let rightWall = self.childNode(withName: "rightWall") as! SKSpriteNode
		
		let leftWallPos = leftWall.position.x + leftWall.size.width/2
		let rightWallPos = rightWall.position.x - rightWall.size.width/2

		let camOffset = (self.view?.frame.size.width)!/2
		
		let min = leftWallPos + camOffset
		let max = rightWallPos - camOffset
		
		if newPlayer.position.x < min {
			// TODO: Check for higher up levels. Feels like this isn't modular.
//			return CGPoint(x: min + self.view!.frame.width/2, y: 0)
			return CGPoint.zero
		}else if newPlayer.position.x > max {
			return CGPoint(x: max , y: 0)
		}else{
			return CGPoint(x: newPlayer.position.x, y: 0)
		}
		
	}
	
	func moveCamera(targetPos: CGPoint){
		self.camera?.run(SKAction.move(to: targetPos, duration: 2))
	}
	
	func touchMoved(toPoint pos : CGPoint) {
		//GameControl.gameControl.movementTime = GameControl.gameControl.movementTimeInt
        if pos.x > 10 {
            rightPressed = true
        }else{
            rightPressed = false
        }
        
        if pos.x < -10 {
            leftPressed = true
        }else{
            leftPressed = false
        }
        
        if pos.y > 10 {
            newPlayer.jump()
        }
        
	}
	
	func touchUp(atPoint pos : CGPoint) {
		initialLocation = CGPoint.zero
        leftPressed = false
        rightPressed = false
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
            newPlayer.canMove = true
		}else if check == PhysicsCategory.giftBoxCategory | PhysicsCategory.playerCategory{
			// TODO: Remove the giftbox here.
            let bodyApos = (contact.bodyA.node?.position)
            let bodyBpos =  (contact.bodyB.node?.position)
			if contact.bodyA.categoryBitMask == PhysicsCategory.giftBoxCategory{
                if bodyApos != nil{
                    GameControl.gameControl.collectedGiftBoxesPos.append(bodyApos!)
                }
				contact.bodyA.node?.removeFromParent()
            }else if contact.bodyB.categoryBitMask == PhysicsCategory.giftBoxCategory{
                if bodyBpos != nil{
                    GameControl.gameControl.collectedGiftBoxesPos.append(bodyBpos!)
                }
				contact.bodyB.node?.removeFromParent()
			}
			GameControl.gameControl.curScore += 10
            
        }else if check == PhysicsCategory.playerCategory | PhysicsCategory.elfCategory{
            // MARK: We are removing the enemy here. Not sure if we want to do that for balance reasons.
            if contact.bodyA.categoryBitMask == PhysicsCategory.elfCategory{
                contact.bodyA.node?.removeFromParent()
            }else if contact.bodyB.categoryBitMask == PhysicsCategory.elfCategory{
                contact.bodyB.node?.removeFromParent()
            }
            
            // Put back one of the giftBoxes everytime the player touches the enemy.
            
            if let firstGiftBox = GameControl.gameControl.collectedGiftBoxesPos.first{
                let newBox = GiftBox()
                newBox.position = firstGiftBox
                self.addChild(newBox)
            }
            
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
                    if newPlayer.canMove{
                        leftPressed = true
                    }
                }else{
                    leftPressed = false
                }
                
				if (SKTGameController.sharedInstance.gameController.extendedGamepad?.leftThumbstick.right.isPressed)!{
                    if newPlayer.canMove{
                        rightPressed = true
                    }
                }else{
                    rightPressed = false
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
		
		// MARK: Position Updating
		highscoreLabel.position = CGPoint(x: (self.camera?.position.x)! - 775, y: (self.camera?.position.y)! + 500)
		scoreLabel.position = CGPoint(x: (self.camera?.position.x)! - 775, y: 470)
		scoreNumberLabel.position = CGPoint(x: (self.camera?.position.x)! + 10 - 775, y: 470)
		highScoreNumberLabel.position = CGPoint(x: (self.camera?.position.x)! + 10 - 775, y: 500)
		timerLabel.position = CGPoint(x: (self.camera?.position.x)! - 775, y: 440)
		timerNumberLabel.position = CGPoint(x: (self.camera?.position.x)! + 10 - 775, y: 440)
		
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
    
    // MARK: Fixed Update function.
    func fixedUpdate( currentTime: TimeInterval, deltaTime: TimeInterval, lastTime: TimeInterval) -> TimeInterval{
        // This function needs to be called at a fixed rate, no matter which device it runs on, how frame rate you get.
        if currentTime - lastTime > deltaTime {
            // Do stuff.
            if leftPressed{
                newPlayer.moveLeft()
            }
            
            if rightPressed{
                newPlayer.moveRight()
            }
            
            return currentTime
        }else{
            return lastTime
        }
    }
	
}
