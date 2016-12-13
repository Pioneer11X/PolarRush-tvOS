//
//  Utils.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 09/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

func - (left: CGPoint, right: CGPoint) -> CGPoint{
	return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func + ( left: CGPoint, right: CGPoint) -> CGPoint{
	return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func * ( left: Double, right: CGPoint) -> CGPoint {
	let new = CGFloat(left)
	return CGPoint(x: new * right.x, y: new * right.y )
}

func * ( left: CGPoint, right: Double) -> CGPoint {
	let new = CGFloat(right)
	return CGPoint(x: new * left.x, y: new * left.y )
}

func modulus (value: CGFloat) -> CGFloat{
	return value < 0 ? -1 * value : value
}
