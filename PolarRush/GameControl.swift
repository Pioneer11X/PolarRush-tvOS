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
	
	let blockSize = CGSize(width: 50, height: 50)
	let movementSpeed: CGFloat = 150
	let movementTime = 0.5
	let movementImpulse: CGFloat = 20
	
	private init(){
		
	}
	
	static var gameControl = GameControl()
	
}

struct PhysicsCategory{
	
	static let playerCategory = UInt32(1)
	static let platformCategory = UInt32(2)
	
}
