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
	
	private init(){
		
	}
	
	static var gameControl = GameControl()
	
}

struct PhysicsCategory{
	
	static let playerCategory = UInt32(1)
	static let platformCategory = UInt32(2)
	static let giftBoxCategory = UInt32(0)
	
}

struct CollisionCategory{
	
	static let playerCategory = UInt32(1)
	static let platformCategory = UInt32(2)
	static let giftBoxCategory = UInt32(4)
	
}
