//
//  PauseOverLaySingleton.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 12/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

var pauseButton = SKSpriteNode(imageNamed: "pauseButton-edited")


var reloadLevelButton = SKSpriteNode(imageNamed: "reload-green")


var playButton = SKSpriteNode(imageNamed: "play-green")

var homeButton = SKSpriteNode(imageNamed: "house-edited")

var settingsButton = SKSpriteNode(imageNamed: "settings-green")

func setNames(){
	pauseButton.name = "pauseButton"
	reloadLevelButton.name = "reloadLevelButton"
	playButton.name = "playButton"
	homeButton.name = "homeButton"
	settingsButton.name = "settingsButton"
}

func updateNodes(node: SKSpriteNode){
	
	node.scale(to: GameControl.gameControl.blockSize)
	node.zPosition = zPosLayer.pauseMenu
	
}

func addNodes(scene: SKScene){
	
	setNames()
	
	let nodes = [
		pauseButton,
		reloadLevelButton,
		playButton,
		homeButton,
		settingsButton
	]
	
	for ins in nodes{
		updateNodes(node: ins)
	}
	
	scene.addChild(reloadLevelButton)
	scene.addChild(playButton)
	scene.addChild(homeButton)
	scene.addChild(settingsButton)
//	scene.addChild(reloadLevelButton)
}

func removeNodes(scene: SKScene){
	
//	let nodeArray = [
//		"reloadLevelButton",
//		"playButton",
//		"homeButton",
//		"settingsButton"
//	]
//	
//	for kapnode in nodeArray{
//		
//		let kapnodeNode = scene.childNode(withName: kapnode)
//		kapnodeNode?.removeFromParent()
//		
//	}
	
	let nodes = [
		pauseButton,
		reloadLevelButton,
		playButton,
		homeButton,
		settingsButton
	]
	
	for ins in nodes{
		ins.removeFromParent()
	}
	
}
