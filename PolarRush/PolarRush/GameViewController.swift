//
//  GameViewController.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 09/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		GameControl.gameControl.gameViewController = self;
		SKTAudio.sharedInstance().playBackgroundMusic(filename: "jingle-bells.mp3")
        loadGameScene()
//		loadMenuScene()
//        loadLevel1()
//		loadLevel2()
//		loadCreditsScene()
		
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
	
	func loadMenuScene(){
		if let view = self.view as! SKView? {
			if let scene = SKScene(fileNamed: "MenuScene") {
				scene.scaleMode = .aspectFill
				view.presentScene(scene)
			}
			view.ignoresSiblingOrder = true
			view.showsFPS = true
			view.showsNodeCount = true
		}
	}
	
	func loadGameScene(){
		if let view = self.view as! SKView? {
			// Load the SKScene from 'GameScene.sks'
			            if let scene = SKScene(fileNamed: "GameScene") {
//			if let scene = SKScene(fileNamed: "MenuScene") {
				// Set the scale mode to scale to fit the window
				scene.scaleMode = .aspectFill
				
				// Present the scene
				view.presentScene(scene)
			}
			
			view.ignoresSiblingOrder = true
			
			view.showsFPS = true
			view.showsNodeCount = true
		}
	}
	
	func loadLevel1(){
		if let view = self.view as! SKView? {
			// Load the SKScene from 'GameScene.sks'
			if let scene = SKScene(fileNamed: "Level1") {
				// Set the scale mode to scale to fit the window
				scene.scaleMode = .aspectFill
				
				// Present the scene
				view.presentScene(scene)
			}
			
			view.ignoresSiblingOrder = true
			
			view.showsFPS = true
			view.showsNodeCount = true
		}
	}
	
	func loadLevel2(){
		if let view = self.view as! SKView?{
			if let scene = SKScene(fileNamed: "Level2"){
				scene.scaleMode = .aspectFill
				view.presentScene(scene)
			}
		}
	}
	
	func loadNextLevel(){
		var i = GameControl.gameControl.curLevel
		i = i + 1;
		if i > GameControl.gameControl.maxLevel{
			i = GameControl.gameControl.maxLevel
		}
		if let view = self.view as! SKView? {
			if let scene = SKScene(fileNamed: "Level\(i)") {
				scene.scaleMode = .aspectFill
				let transition = SKTransition.fade(withDuration: 0.5);
				view.presentScene(scene, transition: transition)
			}
		}
		GameControl.gameControl.curLevel = i
	}
	
	func loadCreditsScene(){
		if let view = self.view as! SKView? {
			if let scene = SKScene(fileNamed: "CreditScene") {
				scene.scaleMode = .aspectFill
				let transition = SKTransition.fade(withDuration: 0.5);
				view.presentScene(scene, transition: transition)
			}
		}
	}
	
	func loadInsScene(){
		if let view = self.view as! SKView? {
			if let scene = SKScene(fileNamed: "InsScene") {
				scene.scaleMode = .aspectFill
				let transition = SKTransition.fade(withDuration: 0.5);
				view.presentScene(scene, transition: transition)
			}
		}
	}
}
