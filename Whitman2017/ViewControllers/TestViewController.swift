//
//  TestViewController.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/5/7.
//  Copyright © 2017年 Orav. All rights reserved.
//

import UIKit
import SwiftyStateMachine

/*
    1. 建立singleton管理各個schema，並根據location決定current schema要套用為何
    2. 使用UserDefault紀錄每個schema目前進行到的State，作為schema initial state
    3. 如果有需要拍照的則在app內實體路徑儲存PHAsset解出的Image實體檔案
    4. User回答的內容則用state作為key，回覆內容作為value儲存在UserDefault中，如果是圖片就存實體圖片路徑
    5. 要傳送給Server時就把這些key value轉化成json
    6. server根據state決定要把對應的文字或圖片貼在template上（應該會用靜態網頁先拉好template）
 */


enum TaskOneState: String {
    case waitingForUpload = "等待上傳中"
    case completedAndShowTips = "上傳成功了快給他看下一個點的資訊"
}

enum TaskOneEvent {
    case uploadSuccess
    case uploadFail
    
    var retryLimit: Int? {
        switch self {
        case .uploadSuccess:
            return nil
        case .uploadFail:
            return 2
        }
    }
}

enum TaskTwoState {
    case lookingFor
    case waitingForStart
    case qOne
    case qTwo
    case qThree
    case qEnding
    case postiveEnding
    case taskFinished
    case taskNotYet
    
    
    
    case historyStart
    case historyNext
    case historyInput
    case historyHint
    case historyFail
    
    var message: Any {
        switch self {
        case .lookingFor: return "你看到了誰嗎？"
        case .waitingForStart: return "你準備好了嗎？快去跟他聊聊吧！"
        case .qOne: return "第一個問題："
        case .qTwo: return "第二個問題："
        case .qThree: return "第三個問題："
        case .qEnding: return "去跟他拍張照片吧"
        case .postiveEnding: return "第一條支線結局"
        case .taskFinished: return "所有任務都完成囉"
        case .taskNotYet: return "還有任務沒完成喔，趕快前往下一個地點吧"
        case .historyStart: return "你有看到清明上河圖嗎？"
        case .historyNext: return "請問清明上河圖是出自於哪個朝代？ 1. 宋朝 2. 明朝 3. 清朝"
        case .historyInput: return "答對啦！說說你對清明上河圖的看法吧！"
        case .historyHint: return ["你要不要再想想看答案？", "用用大腦阿孩子", "You 9487!!!"]
        case .historyFail: return ["你要不要再仔細看看周圍有沒有像捲軸的東西？", "長長的⋯大大的⋯粗粗的⋯", "你有聽過上古卷軸嗎？", "喂喂，找個圖有很難嗎？"]
            
        }
    }
}

enum TaskTwoEvent { // user behavior
    case yesOrNo(String)
    case replyText(String)
    case uploadPhoto(UIImage)
    case options(Int)
}



class TestViewController: UIViewController {
    @IBOutlet weak var stateLabel: UILabel!
    @IBOutlet weak var incorrectButton: UIButton!
    @IBOutlet weak var correctButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    
    var retryCount: Int = 0
    
    let schema2 = StateMachineSchema<TaskTwoState, TaskTwoEvent, Void>(initialState: .lookingFor) { (state, event) -> (TaskTwoState, ((Void) -> ())?)? in
        switch state {
        case .lookingFor:
            switch event {
            case let .yesOrNo(answer):
                if answer == "Y" {
                    return (.waitingForStart, nil)
                } else if answer == "N" {
                    return (.historyStart, nil)
                }
            default:
                return (state, nil)
            }
        case .waitingForStart:
            switch event {
            case let .yesOrNo(answer):
                if answer == "Y" {
                    return (.qOne, nil)
                }
            default:
                return (state, nil)
            }
        case .qOne:
            switch event {
            case let .replyText(text):
                if !text.isEmpty {
                    return (.qTwo, nil)
                }
            default:
                return (state, nil)
            }
        case .qTwo:
            switch event {
            case let .replyText(text):
                if !text.isEmpty {
                    return (.qThree, nil)
                }
            default:
                return (state, nil)
            }
        case .qThree:
            switch event {
            case let .replyText(text):
                if !text.isEmpty {
                    return (.qEnding, nil)
                }
            default:
                return (state, nil)
            }
        case .qEnding:
            switch event {
            case .uploadPhoto:
                return (.postiveEnding, nil)
            default:
                return (state, nil)
            }
            
        case .historyStart, .historyFail:
            switch event {
            case let .yesOrNo(answer):
                if answer == "Y" {
                    return (.historyNext, nil)
                } else if answer == "N" {
                    return (.historyFail, nil)
                } else {
                    return (.historyFail, nil)
                }
            default:
                return (state, nil)
            }
        case .historyNext, .historyHint:
            switch event {
            case let .options(x):
                if x == 1 { // correct option
                    return (.historyInput, nil)
                } else {    // wrong
                    return (.historyHint, nil)
                }
            default:
                return (state, nil)
            }
        case .historyInput:
            switch event {
            case let .replyText(text):
                return (.postiveEnding, nil)
            default:
                return (.postiveEnding, nil)
            }
        default:
            break
        }
        return nil
    }
    
    let schema = StateMachineSchema<TaskOneState, TaskOneEvent, Void>(initialState: .waitingForUpload) { (state, event) -> (TaskOneState, ((Void) -> ())?)? in
        switch state {
        case .waitingForUpload:
            switch event {
            case .uploadSuccess:
                return (.completedAndShowTips, { _ in

                })
            case .uploadFail:
                return (.waitingForUpload, { _ in

                })
            }
        case .completedAndShowTips:
            return nil
        }
    }
    var machine: StateMachine<StateMachineSchema<TaskTwoState, TaskTwoEvent, Void>>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func test() {
//        stateLabel.text = "你在Dumbo附近厚？快給我拍點有趣的！！！"
        retryCount = 0
    }
    
    @IBAction func incorrectAction(_ sender: UIButton) {
//        machine.handleEvent(.uploadFail)
    }

    @IBAction func correctAction(_ sender: UIButton) {
//        machine.handleEvent(.uploadSuccess)
    }
    
    @IBAction func sendAction(_ sender: UIButton) {
        print("current state: \(machine.state)")
        switch machine.state {
        case .lookingFor:
            machine.handleEvent(.yesOrNo(textField.text!))
        case .waitingForStart:
            machine.handleEvent(.yesOrNo(textField.text!))
        case .qOne:
            machine.handleEvent(.replyText(textField.text!))
        case .qTwo:
            machine.handleEvent(.replyText(textField.text!))
        case .qThree:
            machine.handleEvent(.replyText(textField.text!))
        case .qEnding:  // 應該在選擇好照片點上傳時判斷
            machine.handleEvent(.uploadPhoto(UIImage()))
        case .postiveEnding:
            stateLabel.text = "任務完成"
            
        case .historyStart, .historyFail:
            machine.handleEvent(.yesOrNo(textField.text!))
        case .historyNext, .historyHint:
            machine.handleEvent(.options(Int(textField.text!)!))
        case .historyInput:
            machine.handleEvent(.replyText(textField.text!))
        default:
            break
        }
        textField.text = nil
    }
    
    @IBAction func arriveAction(_ sender: UIButton) {
//        machine = StateMachine(schema: schema, subject: test())
//        machine.didTransitionCallback = { (oldState, event, newState) in
//            if oldState == newState {
//                self.retryCount += 1
//                print(self.retryCount)
//            } else {
//                self.retryCount = 0
//            }
//            
//            if let limit = event.retryLimit {
//                if self.retryCount > limit {
//                    self.stateLabel.text = "上傳這麼多次都錯，87ㄇ？"
//                } else {
//                    self.stateLabel.text = newState.rawValue + "\(self.retryCount)"
//                }
//            } else {
//                self.stateLabel.text = newState.rawValue
//            }
//            
//        }
        machine = StateMachine(schema: schema2, subject: test())
        stateLabel.text = TaskTwoState.lookingFor.message as? String
        machine.didTransitionCallback = { [unowned self] (oldState, event, newState) in
            switch newState.message {
            case is String:
                self.stateLabel.text = newState.message as? String
            case is [String]:   // 多語句需要random挑選
                let randomIndex = Int(arc4random_uniform(UInt32((newState.message as! [String]).count)))
                self.stateLabel.text = (newState.message as! [String])[randomIndex]
            default:
                break
            }
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
