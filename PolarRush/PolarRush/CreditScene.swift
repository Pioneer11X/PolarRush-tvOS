//
//  CreditScene.swift
//  PolarRush
//
//  Created by Sravan Karuturi on 13/12/16.
//  Copyright © 2016 Sravan Karuturi. All rights reserved.
//

import Foundation
import SpriteKit

class CreditScene: SKScene{
	
	let creds = [
		"References: http://all-free-download.com/",
		"Font Reference: http://www.aringtypeface.com/license/product-usage-agreement/",
		"Background Music Reference: http://free-loops.com/6192-jingle-bells.html",
		"Winter Hat Icon Reference: http://free-loops.com/6192-jingle-bells.html by freepik",
		"Jump Sound Reference: http://soundbible.com/1343-Jump.html",
		"Icon Pack Reference: http://www.flaticon.com/packs/miscellanea-set",
		"Home Screen Reference: http://www.modernhdwallpaper.com/archives/10289.html",
		"Main Menu Background Reference: http://hdw.eweb4.com/out/26575.html",
		"Snow Texture Reference: http://bgfons.com/upload/snow_texture1554.jpg",
	]
	
	//"Icicles ClipArt Reference: http://gallery.yopriceville.com/Free-Clipart-Pictures/Winter-PNG/Long_Icicles_Transparent_PNG_Clip_Art_Image#.WDOSYqIrJok"
	
	override func didMove(to view: SKView) {
		
		var i = 0
		
		let _ = Timer.scheduledTimer(withTimeInterval: 5, repeats: true){_ in
			if i < self.creds.count{
				let creditNode = SKLabelNode(fontNamed: GameConstants.gameConstants.fontName)
				creditNode.text = self.creds[i]
				creditNode.position = CGPoint(x: 0, y: -1 * (self.view?.frame.size.height)!/6)
				creditNode.zPosition = 10
				self.addChild(creditNode)
				creditNode.run(
					SKAction.sequence([
						SKAction.fadeIn(withDuration: 1),
						SKAction.wait(forDuration: 3),
						SKAction.fadeOut(withDuration: 1),
						SKAction.run { creditNode.removeFromParent()}
						]
					)
				)
				i += 1
			}else{
				GameControl.gameControl.gameViewController?.loadMenuScene()
			}
		}
		
//		setupGest()
		
		
	}
	
	override func update(_ currentTime: TimeInterval) {
//		checkController()
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
