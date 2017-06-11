//
//  Constants.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/5/29.
//  Copyright © 2017年 Orav. All rights reserved.
//

import Foundation
import UIKit
import Mapbox

// MARK: - Protocols

protocol SegueDelegate: class {
    func segue(to identifier: SegueIdentifier)
}

protocol StatePropertiesProtocol {
    var message: Any { get }
    var retryLimit: Int? { get }
}

// MARK: - Events and states in schema


/// 3種case: boss回答純文字（String）、boss隨機回答文字（[String]）、boos回答有選項的文字（[String: Any]）
// case makeChoices: return ["message": "tell me what's you choice?", "options": ["OP1", "OP2", "OP3"]]
// options這個key中是要放要顯示在泡泡裡要給user選的按鈕（動態產生）

/// W1 Location state
enum W1State: StatePropertiesProtocol {
    case introduction
    var message: Any {
        switch self {
        case .introduction:
            return "Hey, %@.\nTook you long enough.\nIs Whitman there?"
        }
        return ""
    }
    var retryLimit: Int? {
        return nil
    }
}

enum W2State: StatePropertiesProtocol {
    case introduction
    // interview path
    case interviewSetup
    case interviewQ1
    case interviewQ2
    case interviewQ3
    case interviewQ4
    case interviewQ5
    case interviewEnd
    case interviewHint1
    case interviewHint2
    case interviewHint3
    case interviewHint4
    case interviewHint5
    case interviewHint6
    
    // history path
    case historySetup
    
    var message: Any {
        switch self {
        case .introduction:
            return "Hey, %@.\nTook you long enough.\nIs Whitman there?"
        case .interviewSetup:
            return "Whitman was editor of The Brooklyn Eagle, which used to be on this spot. That's probably why he's hanging out here.\nGo interview him. I'll send a list of questions.\nAre you ready?"
        case .interviewQ1:
            return ["message": "What year did he become editor?\n1. 1840\n2. 1846\n3. 1900", "options": ["1840", "1846", "1900"]]
        case .interviewQ2:
            return "Ask him what he liked best about the job.\nReady for the next question?"
        case .interviewQ3:
            return ["message": "Why did he stop being editor? Text me the number.\n1. He was fired\n2. He quit\n3. He ran for mayor", "options": ["He was fired", "He quit", "He ran for mayor"]]
        case .interviewQ4:
            return "Why was he fired? Send me a short sentence with the reason, 15 words max."
        case .interviewQ5:
            return "Now take a photo of him and send it to me."
        case .interviewEnd:
            return "Nice job with the interview!\nKeep it up, and you could get a Pulitzer."
        case .interviewHint1:
            return "Don't get cold feet! I'll give you all the questions you need to ask. Ready now?"
        case .interviewHint2:
            return ["message": "Stay focused!\nAsk the questions I send you, and then send me back the answers.\nWhat was the year: 1, 2, or 3?", "options": ["1", "2", "3"]]
        case .interviewHint3:
            return "Stop wasting time! Ready for the next question?"
        case .interviewHint4:
            return ["message": "Are you sure about that?", "options": ["He was fired", "He quit", "He ran for mayor"]]
        case .interviewHint5:
            return "You do know how to write, don't you? Send me a short sentence about why he was fired."
        case .interviewHint6:
            return "Tap the camera icon, take a photo of Whitman, and send it to me."
        default:
            return ""
        }
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
    case timesBoosIcon = "bossHeadIcon"
    case enquirerBossIcon = "bossHeadIconEnquirer"
    case timesMessagerLogo = "timesMessagerLogo"
    case enquirerMessagerLogo = "enquirerMessagerLogo"
    case userLocation = "yourCurrentPosition"
    case prompt = "prompt"
    case regionW = "characterLocation"
    case regionN = "neighborhoodLocation"
    case regionH = "historicalLocation"
    
    var image: UIImage {
        return UIImage(named: self.rawValue)!
    }
}

enum PlayerRole: String {
    case dumboTimes = "DumboTimes"
    case dumboEnquirer = "DumboEnquirer"
}

//SegueIdentifiers can be found in Main.storyboard
enum SegueIdentifier: String {
    case toStory = "ToStory"
    case toTask = "ToTask"
    case toAbout = "ToAbout"
    case toRestart = "ToRestart"
    case toSubmit = "ToSubmit"
}

enum TaskRegion {
    case W1
    case W2
    case W3
    case F
    case N1
    case HQ
    
    var point: MGLPointAnnotation {
        let point = MGLPointAnnotation()
        switch self {
        case .W1:
            point.coordinate = CLLocationCoordinate2D(latitude: 40.70238, longitude: -73.99354)
            point.title = "Eagle Warehouse"
            point.subtitle = "Interview Whitman if he's there, or find out about the Brooklyn Eagle"
        case .W2:
            point.coordinate = CLLocationCoordinate2D(latitude: 40.7033, longitude: -73.99534)
            point.title = "Fulton Ferry Landing"
            point.subtitle = "Interview Whitman if he's there, or find out about the poem Leaves of Grass"
        case .W3:
            point.coordinate = CLLocationCoordinate2D(latitude: 40.70397, longitude: -73.99293)
            point.title = "St. Ann's Warehouse"
            point.subtitle = "Interview Whitman if he's there, or find out about St. Ann's"
        case .F:
            point.coordinate = CLLocationCoordinate2D(latitude: 40.7045, longitude: -73.99037)
            point.title = "Beach"
            point.subtitle = "Interview Gabriel Harrison"
        case .N1:
            point.coordinate = CLLocationCoordinate2D(latitude: 40.70309, longitude: -73.99138)
            point.title = "66 Water Street"
            point.subtitle = "Check out one of DUMBO's oldest buildings"
        case .HQ:
            point.coordinate = CLLocationCoordinate2D(latitude: 40.7014, longitude: -73.98645)
            point.title = "Headquarter"
            point.subtitle = "The headquarter of news"
        }
        return point
    }
    
    var image: UIImage {
        switch self {
        case .W1, .W2, .W3, .F:
            return UIImage(asset: .regionW)
//        case .H4:
//            return UIImage(asset: .regionH)
        case .N1:
            return UIImage(asset: .regionN)
        case .HQ:
            return UIImage(asset: .userLocation)
        }
    }
    
    static func getRegion(with title: String) -> TaskRegion? {
        guard let region = (all.filter { $0.point.title == title }).first else {
            return nil
        }
        return region
    }
    
    static var all: [TaskRegion] {
        return [.W1, .W2, .W3, .F, .N1, .HQ]
    }
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

// UserDefault
struct Keys {
    static let role = "Role"
    static let email = "Email"
    static let userName = "UserName"
}

//TutorialIdentifiers can be found in Main.storyboard
enum TutorialIdentifier: String {
    case page1 = "Tutorial1"
    case page2 = "Tutorial2"
    case page3 = "Tutorial3"
}
