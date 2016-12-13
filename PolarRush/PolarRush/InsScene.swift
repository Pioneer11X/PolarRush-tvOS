//
//  InsScene.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 13/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class InsScene: SKScene{
	
	override func didMove(to view: SKView) {
		setupGest()
	}
	
	override func update(_ currentTime: TimeInterval) {
		checkController()
	}
	
	private func checkController(){
		if SKTGameController.sharedInstance.gameControllerType == controllerType.extended{
			if (SKTGameController.sharedInstance.gameController.extendedGamepad?.buttonA.isPressed)!{
				loadMenuScene()
			}
		}
	}
	
	private func loadMenuScene(){
		GameControl.gameControl.gameViewController?.loadMenuScene()
	}
	
	@objc private func RemoteTapped(_ recognizer: UITapGestureRecognizer){
		loadMenuScene()
	}
	
	private func setupGest(){
		let newRec = UITapGestureRecognizer(target: self, action: #selector(RemoteTapped(_:)))
		newRec.allowedPressTypes = [NSNumber(value: UIPressType.select.rawValue)]
		self.view?.addGestureRecognizer(newRec)
	}
	
}
