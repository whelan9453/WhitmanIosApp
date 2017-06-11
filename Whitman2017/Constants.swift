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
    case timesBoosIcon = "bossHeadIcon"
    case enquirerBossIcon = "bossHeadIconEnquirer"
    case timesMessagerLogo = "timesMessagerLogo"
    case enquirerMessagerLogo = "enquirerMessagerLogo"
    case userLocation = "yourCurrentPosition"
    case prompt = "prompt"
    case regionW = "characterLocation"
    case regionN = "neighborhoodLocation"
    case regionF = "historicalLocation"
    
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
        case .W1, .W2, .W3:
            return UIImage(asset: .regionW)
        case .F:
            return UIImage(asset: .regionF)
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
