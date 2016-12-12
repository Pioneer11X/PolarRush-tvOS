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
	let movementSpeed: CGFloat = 500
	let movementTime = 0.75
	let movementImpulse: CGFloat = 20
	let playerMass : CGFloat = 0.05
	
	// MARK: Display Constant
	
	let displayTime: Double = 1
	let fadeOutTime = 0.5
	
	// MARK: Menu Timing Constant.
	let menuDelay = 0.25
	
	private init(){
		
	}
	
	static var gameControl = GameControl()
	
}

struct PhysicsCategory{
	
	static let playerCategory = UInt32(1)
	static let platformCategory = UInt32(2)
	static let giftBoxCategory = UInt32(4)
	static let doorCategory = UInt32(8)
	
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
