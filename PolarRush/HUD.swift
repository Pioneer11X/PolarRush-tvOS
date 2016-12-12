//
//  HUD.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 12/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class HUD{
	
	var scoreLabel: SKLabelNode;
	var timerLabel: SKLabelNode;
	var timerNumberLabel: SKLabelNode
	var scoreNumberLabel: SKLabelNode;
	var highScoreLabel: SKLabelNode;
	var highScoreNumberLabel: SKLabelNode;
	
	private init() {
		scoreLabel = SKLabelNode(fontNamed: GameConstants.gameConstants.fontName)
		scoreLabel.horizontalAlignmentMode = .right
		scoreLabel.text = "Score: "
		
		highScoreLabel = SKLabelNode(fontNamed: GameConstants.gameConstants.fontName)
		highScoreLabel.horizontalAlignmentMode = .right
		highScoreLabel.text = "HighScore: "
		
		timerLabel = SKLabelNode(fontNamed: GameConstants.gameConstants.fontName)
		timerLabel.horizontalAlignmentMode = .right
		timerLabel.text = "Time: "
		
		
		timerNumberLabel = SKLabelNode(fontNamed: "Arial")
		timerNumberLabel.horizontalAlignmentMode = .left
		timerNumberLabel.fontSize = 0.6 * scoreLabel.fontSize
		
		scoreNumberLabel = SKLabelNode(fontNamed: "Arial")
		scoreNumberLabel.horizontalAlignmentMode = .left
		scoreNumberLabel.fontSize = 0.6 * scoreLabel.fontSize
		
		highScoreNumberLabel = SKLabelNode(fontNamed: "Arial")
		highScoreNumberLabel.horizontalAlignmentMode = .left
		highScoreNumberLabel.fontSize = 0.6 * scoreLabel.fontSize
	}
	
	static var hud: HUD = HUD()
	
}
