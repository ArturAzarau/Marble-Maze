//
//  GameScene.swift
//  Marble Maze
//
//  Created by Артур Азаров on 14.08.2018.
//  Copyright © 2018 Артур Азаров. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    // MARK: - Properties
    
    private enum LevelParts: String {
        case wall = "x"
        case vortex = "v"
        case star = "s"
        case finish = "f"
    }
    
    private enum CollisionTypes: UInt32 {
        case player = 1
        case wall = 2
        case star = 4
        case vortex = 8
        case finish = 16
    }
    
    // MARK: - Scene life cycle
    
    override func didMove(to view: SKView) {
        createBackground()
        loadLevel()
    }
    
    // MARK: - Methods
    private func loadLevel() {
        func loadWall(at position: CGPoint) {
            let node = SKSpriteNode(imageNamed: "block")
            node.position = position
            
            node.physicsBody = SKPhysicsBody(rectangleOf: node.size)
            node.physicsBody?.categoryBitMask = CollisionTypes.wall.rawValue
            node.physicsBody?.isDynamic = false
            addChild(node)
        }
        
        func loadVortex(at position: CGPoint) {
            let node = SKSpriteNode(imageNamed: "vortex")
            node.name = "vortex"
            node.position = position
            node.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat.pi, duration: 1)))
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            
            node.physicsBody?.categoryBitMask = CollisionTypes.vortex.rawValue
            node.physicsBody?.collisionBitMask = 0
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            addChild(node)
        }
        
        func loadStar(at position: CGPoint) {
            let node = SKSpriteNode(imageNamed: "star")
            node.position = position
            node.name = "star"
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.physicsBody?.isDynamic = false
            
            node.physicsBody?.categoryBitMask = CollisionTypes.star.rawValue
            node.physicsBody?.collisionBitMask = 0
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            addChild(node)
        }
        
        func loadFinishFlag(at position: CGPoint) {
            let node = SKSpriteNode(imageNamed: "finish")
            node.physicsBody = SKPhysicsBody(circleOfRadius: node.size.width / 2)
            node.position = position
            node.name = "finish"
            node.physicsBody?.isDynamic = false
            
            node.physicsBody?.categoryBitMask = CollisionTypes.finish.rawValue
            node.physicsBody?.collisionBitMask = 0
            node.physicsBody?.contactTestBitMask = CollisionTypes.player.rawValue
            addChild(node)
        }
        
        // Method starts here
        if let levelPath = Bundle.main.path(forResource: "level1", ofType: "txt"), let levelString = try? String(contentsOfFile: levelPath) {
            let lines = levelString.components(separatedBy: "\n")
            for (row, line) in lines.reversed().enumerated() {
                for (column, letter) in line.enumerated() {
                    let position = CGPoint(x: 64 * column + 32, y: 64 * row + 32)
                    let levelPart = LevelParts(rawValue: String(letter))!
                    switch levelPart {
                    case .wall: loadWall(at: position)
                    case .vortex: loadVortex(at: position)
                    case .star: loadStar(at: position)
                    case .finish: loadFinishFlag(at: position)
                    }
                }
            }
        }
    }
    
    private func createBackground() {
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint(x: 512, y: 384)
        background.blendMode = .replace
        background.zPosition = -1
        addChild(background)
    }
}
