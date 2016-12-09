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
	
	// MARK: Movement variables:
	private var initialLocation: CGPoint = CGPoint.zero
	private var finalLocation: CGPoint = CGPoint.zero
	private var originalLocation: CGPoint = CGPoint.zero
	
    
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
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.blue
            self.addChild(n)
        }
		let diff: CGPoint = pos - initialLocation
//		print(diff)
		if diff.x < -5 {
//			newPlayer.moveLeft()
			newPlayer.moveLeftImpulse()
		}else if diff.x > 5{
			newPlayer.moveRightImpulse()
		}
		
		if diff.y > 10{
			newPlayer.jump()
		}
		initialLocation = pos
    }
    
    func touchUp(atPoint pos : CGPoint) {
        if let n = self.spinnyNode?.copy() as! SKShapeNode? {
            n.position = pos
            n.strokeColor = SKColor.red
            self.addChild(n)
        }
		initialLocation = CGPoint.zero
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let label = self.label {
            label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
        }
        
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
    }
	
	func check(_ recognizer: UITapGestureRecognizer){
		self.newPlayer.jump()
	}
	
	func addGestureRecs(){
		
		let newRec = UITapGestureRecognizer(target: self, action: #selector(check(_ :)))
//		newRec.allowedPressTypes = [ NSNumber(value: UIPressType.leftArrow.rawValue ) ]
		newRec.allowedPressTypes = [ NSNumber(value: UIPressType.select.rawValue ) ]
		self.view?.addGestureRecognizer(newRec)
		
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
