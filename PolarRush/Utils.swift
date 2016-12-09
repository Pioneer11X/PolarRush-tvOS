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
