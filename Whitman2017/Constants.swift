//
//  Constants.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/5/29.
//  Copyright © 2017年 Orav. All rights reserved.
//

import Foundation
import UIKit

// MARK: - Protocols

protocol SegueDelegate: class {
    func segue(to identifier: SegueIdentifier)
}

protocol StatePropertiesProtocol {
    var message: Any { get }
    var retryLimit: Int? { get }
}

// MARK: - Events and states in schema

/// W1 Location state
enum W1State: StatePropertiesProtocol {
    
    /// 3種case: boss回答純文字（String）、boss隨機回答文字（[String]）、boos回答有選項的文字（[String: Any]）
    // case makeChoices: return ["message": "tell me what's you choice?", "options": ["OP1", "OP2", "OP3"]]
    // options這個key中是要放要顯示在泡泡裡要給user選的按鈕（動態產生）
    var message: Any {
        return ""
    }
    var retryLimit: Int? {
        return nil
    }
}

/// User behaviors for all schemas
enum UserEvent {
    case options(Int)
    case statement(String)
    case photo(UIImage)
}

// MARK: - DEFINE

enum MessageType {
    case mine
    case opponent
    
    var backgroundImage: UIImage {
        switch self {
        case .mine:
            return UIImage(asset: .messageMine)
        case .opponent:
            return UIImage(asset: .messageOpponent)
        }
    }
}

enum Caption: String {
    case story = "STORY"
    case task = "TASK"
    case about = "ABOUT"
    case restart = "RESTART"
    case submit = "SUBMIT"
}

enum Asset: String {
    case messageMine = "conversationRed"
    case messageOpponent = "conversation01"
    case storyIcon = "storyIcon"
    case taskIcon = "taskIcon"
    case aboutIcon = "aboutIcon"
    case restartIcon = "restartIcon"
    case submitIcon = "submitIcon"
    
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}

enum SegueIdentifier: String {
    case toStory = "ToStory"
    case toTask = "ToTask"
    case toAbout = "ToAbout"
    case toRestart = "ToRestart"
    case toSubmit = "ToSubmit"
}

struct MessageModel {
    var id: Int
    var text: String?
    var image: UIImage?
    var type: MessageType
    var width: CGFloat? = nil
    
    init(id: Int, text: String? = nil, image: UIImage? = nil, type: MessageType = .mine) {
        self.id = id
        self.text = text
        self.image = image
        self.type = type
    }
}

struct Constants {
    static let chatVCMaxHeight: CGFloat = UIScreen.main.bounds.height - 169
    static let chatVCMinHeight: CGFloat = 137
    static let messageSpacing: CGFloat = 20
    static let messageInsets = UIEdgeInsets(top: 3.4, left: 15.7, bottom: 10.6, right: 15.7)
    static let messageLimitSpacing = UIScreen.main.bounds.width * 0.8    
}
