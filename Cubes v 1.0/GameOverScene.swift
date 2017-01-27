//
//  GameOverScene.swift
//  Cubes v 1.0
//
//  Created by James Paulk on 4/7/16.
//  Copyright © 2016 James Paulk. All rights reserved.
//

import SpriteKit

class GameOverScene: SKScene
{
	override func didMove(to view: SKView)
	{
		self.backgroundColor = SKColor.black

		let gameOverLabel = SKLabelNode(text: "Game Over!")
		gameOverLabel.fontSize = 50
		gameOverLabel.fontColor = SKColor.red
		gameOverLabel.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5)
		self.addChild(gameOverLabel)

		let playAgainLabel = SKLabelNode(text: "Tap to play again.")
		playAgainLabel.fontSize = 30
		playAgainLabel.fontColor = SKColor.white
		playAgainLabel.position = CGPoint(x: self.frame.width * 0.5, y: self.frame.height * 0.5 - 50)
		self.addChild(playAgainLabel)
	}

	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
	{
		let mainScene = GameScene()
		mainScene.size = self.size
		self.view?.presentScene(mainScene, transition: SKTransition.crossFade(withDuration: 1))
	}
}
