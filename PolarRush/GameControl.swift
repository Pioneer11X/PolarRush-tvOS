//
//  GameControl.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 09/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class GameControl{
	
	var gameViewController: GameViewController?
	
	let blockSize = CGSize(width: 100, height: 100)
	let movementSpeed: CGFloat = 10 //2
	var movementTime = 0.005
	let movementTimeExt = 0.25
	let movementTimeInt = 0.75
	let movementImpulse: CGFloat = 20
	let playerMass : CGFloat = 0.05
    
    // MARK: Collected GiftBoxPoints
    var collectedGiftBoxesPos: [CGPoint] = []
	
	// MARK: Display Constant
	
	let displayTime: Double = 1
	let fadeOutTime = 0.5
	
	// MARK: Menu Constants.
	let menuDelay = 0.25
	let menuInitialScale:CGFloat = 1
	let menuHighlightedScale:CGFloat = 1.2
	let menuMovementTime: Double = 0.5
//	let menuMovementDistance: CGVector = CGVector(dx: 150, dy: 0)
	let menuMovementDistance: CGFloat = 150
	
    
    // MARK: Enemy Movements.
    let enemyMoveDistance = 100
    let enemyMoveTime: Double = 1
    
	// MARK: GameData
	
	let initTimer = 60
	let initScore = 0
	
	var timer = 20
	var curScore = 0{
		didSet(blah){
			if curScore > self.highScore{
				self.highScore = curScore
			}
		}
	}
	
	var highScoreKey = "highScoreKey"
	
	var highScore: Int{
		didSet{
			let defaults = UserDefaults.standard;
			defaults.set(highScore, forKey: highScoreKey)
		}
	}
	
	var curLevel = 0
	var maxLevel = 4
	
	private init(){
		let defaults = UserDefaults.standard;
		self.highScore = ( defaults.integer(forKey: highScoreKey) )
	}
	
	static var gameControl = GameControl()
	
	func resetLevel(){
		self.timer = self.initTimer
        self.collectedGiftBoxesPos = []
	}
	
	// MARK: Options
	var playSounds: Bool = true
	
}

struct PhysicsCategory{
	
	static let playerCategory = UInt32(1)
	static let platformCategory = UInt32(2)
	static let giftBoxCategory = UInt32(4)
	static let doorCategory = UInt32(8)
    static let elfCategory = UInt32(16)
	
}

struct CollisionCategory{
	
	static let playerCategory = UInt32(1)
	static let platformCategory = UInt32(2)
	static let giftBoxCategory = UInt32(4)
	
}

struct zPosLayer{
	
	static let background: CGFloat = 0
	static let platform: CGFloat = 5
	static let giftbox: CGFloat = 10
	static let player: CGFloat = 15
	static let hud: CGFloat = 20
	static let pauseMenu: CGFloat = 25
	
}
