//
//  GameScene.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 09/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
	
	private var newPlayer = PlayerNode()
	private var newbox = GiftBox()
    
    // MARK: Fixed update loop.
    private var lastTime: TimeInterval?
    private var deltaTime: TimeInterval = 1 // Sample delta time of 1 second.
	
	private var isGamePaused: Bool = false{
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
	
    private var rightPressed: Bool = false
    private var leftPressed: Bool = false
    
    override func didMove(to view: SKView) {
		
		
		self.physicsWorld.contactDelegate = self
		
//		newPlayer.position = CGPoint(x: 100, y: 100)
		self.addChild(newPlayer)
		addGestureRecs()
		
		newbox.position = CGPoint(x: 3 * (self.view?.frame.size.width)!/8, y: 3 * (self.view?.frame.size.height)!/8)
		newbox.zPosition = 5
		self.addChild(newbox)
		
		
		
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            label.run(SKAction.fadeIn(withDuration: 2.0))
        }
        
        // Create shape node to use during mouse interaction
        let w = (self.size.width + self.size.height) * 0.05
        self.spinnyNode = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
        
        if let spinnyNode = self.spinnyNode {
            spinnyNode.lineWidth = 2.5
            
            spinnyNode.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(M_PI), duration: 1)))
            spinnyNode.run(SKAction.sequence([SKAction.wait(forDuration: 0.5),
                                              SKAction.fadeOut(withDuration: 0.5),
                                              SKAction.removeFromParent()]))
        }
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.green
            self.addChild(n)
        }
        if pos.x > 10 {
            rightPressed = true
        }else if pos.x < -10 {
            leftPressed = true
        }
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
        
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
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
		initialLocation = CGPoint.zero
        rightPressed = false
        leftPressed = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        if let label = self.label {
//            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//        }
        
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
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
//		print(SKTGameController.sharedInstance.gameController.extendedGamepad?.leftThumbstick.left.isPressed)
		
        
        // Commenting out to test the fixed update loop.
        
		if SKTGameController.sharedInstance.gameControllerConnected{
			
			if SKTGameController.sharedInstance.gameControllerType == controllerType.extended{
			
				if (SKTGameController.sharedInstance.gameController.extendedGamepad?.leftThumbstick.left.isPressed)!{
//					newPlayer.moveLeftImpulse()
                    leftPressed = true
                }else{
                    leftPressed = false
                }
				if (SKTGameController.sharedInstance.gameController.extendedGamepad?.leftThumbstick.right.isPressed)!{
//					newPlayer.moveRightImpulse()
                    rightPressed = true
                }else{
                    rightPressed = false
                }
				if (SKTGameController.sharedInstance.gameController.extendedGamepad?.buttonA.isPressed)!{
					newPlayer.jump()
				}
			}
		}
 
        
        if lastTime != nil{
            lastTime = fixedUpdate(currentTime: currentTime, deltaTime: GameControl.gameControl.movementTime, lastTime: lastTime!)
        }else{
            lastTime = currentTime
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
	
	func check(_ recognizer: UITapGestureRecognizer){
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
		
		let newRec = UITapGestureRecognizer(target: self, action: #selector(check(_ :)))
		newRec.allowedPressTypes = [ NSNumber(value: UIPressType.select.rawValue ) ]
		self.view?.addGestureRecognizer(newRec)
		
		let pauseRec = UITapGestureRecognizer(target: self, action: #selector(pauseCheck(_:)))
		pauseRec.allowedPressTypes = [ NSNumber(value: UIPressType.playPause.rawValue) ]
		self.view?.addGestureRecognizer(pauseRec)
		
	}
	
	func didBegin(_ contact: SKPhysicsContact) {
		
		let check = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
		
		if check == ( PhysicsCategory.playerCategory | PhysicsCategory.platformCategory ){
			newPlayer.canJump = true
		}else if check == PhysicsCategory.giftBoxCategory | PhysicsCategory.playerCategory{
			newbox.removeGiftBox()
		}
	}
}
