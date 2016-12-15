//
//  Enemy.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 12/15/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class Enemy: SKSpriteNode{
    init() {
        
        let boxTexture = SKTexture(imageNamed: "myElf")
        
        super.init(texture: boxTexture, color: UIColor.blue, size: GameControl.gameControl.blockSize)
        self.name = "enemy"
        
        self.physicsBody = SKPhysicsBody(rectangleOf: GameControl.gameControl.blockSize, center: self.position)
        
        self.physicsBody?.categoryBitMask = PhysicsCategory.elfCategory
        self.physicsBody?.contactTestBitMask = PhysicsCategory.playerCategory
        self.physicsBody?.affectedByGravity = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func removeGiftBox(){
        // MARK: Add the score here.
        self.removeFromParent()
    }
    
    func moveTheEnemy(){
        self.run(
            SKAction.repeatForever(
                SKAction.sequence(
                    [
                        SKAction.move(by: CGVector(dx: GameControl.gameControl.enemyMoveDistance, dy: 0 ), duration: GameControl.gameControl.enemyMoveTime),
                        SKAction.move(by: CGVector(dx: -2 * GameControl.gameControl.enemyMoveDistance, dy: 0 ), duration: 2 * GameControl.gameControl.enemyMoveTime),
                        SKAction.move(by: CGVector(dx: 2 * GameControl.gameControl.enemyMoveDistance, dy: 0 ), duration: 2 * GameControl.gameControl.enemyMoveTime),
                        SKAction.move(by: CGVector(dx: -1 * GameControl.gameControl.enemyMoveDistance, dy: 0 ), duration: GameControl.gameControl.enemyMoveTime)
                    ]
                )
            )
        )
    }
    
}
