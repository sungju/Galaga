//
//  GameScene.swift
//  Galaga
//
//  Created by Sungju Kwon on 2017. 3. 28..
//  Copyright © 2017년 Sungju Kwon. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    private var battleShip: SKSpriteNode?
    
    private var lastUpdateTime : TimeInterval = 0
    private var dt : TimeInterval = 0
    private let shipMovePointsPerSec: CGFloat = 300.0
    private var velocity = CGPoint.zero
    private var targetLocation = CGPoint.zero
    
    
    override func didMove(to view: SKView) {
        battleShip = SKSpriteNode.init(imageNamed: "Spaceship")
        battleShip?.xScale = 0.2
        battleShip?.yScale = 0.2
        
        battleShip?.position = CGPoint(x: 0, y: -(self.size.height / 4))
        
        addChild(battleShip!)
    }
    
    func correctTargetLocation(touchLocation: CGPoint) {
        let offset = CGPoint(x: touchLocation.x - (battleShip?.position.x)!,
                             y: touchLocation.y - (battleShip?.position.y)!)
        let length = sqrt(Double(offset.x * offset.x + offset.y * offset.y))
        let direction = CGPoint(x: offset.x / CGFloat(length),
                                y: offset.y / CGFloat(length))
        
        velocity = CGPoint(x: direction.x * shipMovePointsPerSec,
                           y: direction.y * shipMovePointsPerSec)
        
        targetLocation = touchLocation
    }
    
    func sceneTouched(touches: Set<UITouch>) {
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        correctTargetLocation(touchLocation: touchLocation)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTouched(touches: touches)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTouched(touches: touches)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        sceneTouched(touches: touches)
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        if (lastUpdateTime > 0) {
            dt = currentTime - lastUpdateTime
        } else {
            dt = 0
        }
        lastUpdateTime = currentTime
        
        let oldShipPosition = battleShip?.position
        self.moveObject(node: battleShip!, velocity: velocity, dt: dt)
        let minX = min(CGFloat((oldShipPosition?.x)!), CGFloat((battleShip?.position.x)!))
        let minY = min(CGFloat((oldShipPosition?.y)!), CGFloat((battleShip?.position.y)!))
        let maxX = max(CGFloat((oldShipPosition?.x)!), CGFloat((battleShip?.position.x)!))
        let maxY = max(CGFloat((oldShipPosition?.y)!), CGFloat((battleShip?.position.y)!))
        
        if (targetLocation.x > minX && targetLocation.x < maxX) {
            if (targetLocation.y > minY && targetLocation.y < maxY) {
                battleShip?.position = targetLocation
                velocity = CGPoint.zero
            }
        }
    }
    
    func moveObject(node: SKSpriteNode, velocity: CGPoint, dt: TimeInterval) {
        let amountToMove = CGPoint.init(x: (velocity.x * CGFloat(dt)),
                                        y: (velocity.y * CGFloat(dt)))
        
        node.position = CGPoint.init(x: node.position.x + amountToMove.x,
                                     y: node.position.y + amountToMove.y)
    }
    
}
