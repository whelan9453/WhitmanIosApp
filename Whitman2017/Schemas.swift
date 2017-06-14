//
//  Schemas.swift
//  Whitman2017
//
//  Created by Toby Hsu on 2017/6/11.
//  Copyright © 2017年 Orav. All rights reserved.
//

import Foundation
import SwiftyStateMachine

struct Machines {
    static let W1 = StateMachine(schema: Schemas.W1.schema as! StateMachineSchema<W1State, UserEvent, Void>, subject: ())
    static let W2 = StateMachine(schema: Schemas.W2.schema as! StateMachineSchema<W2State, UserEvent, Void>, subject: ())
}

enum Schemas {
    case W1
    case W2
    
    var schema: Any {
        switch self {
        case .W1:
            let lastState = UserDefaults.standard.value(forKey: Keys.stateW1) as? Int ?? 0
            return StateMachineSchema<W1State, UserEvent, Void>(initialState: W1State(rawValue: lastState)!) { (state, event) -> (W1State, ((Void) -> ())?)? in
                return nil
            }
        case .W2:
            let lastState = UserDefaults.standard.value(forKey: Keys.stateW2) as? Int ?? 0
            return StateMachineSchema<W2State, UserEvent, Void>(initialState: W2State(rawValue: lastState)!) { (state, event) -> (W2State, ((Void) -> ())?)? in
                switch state {
                case .introduction:
                    switch event {
                    case let .options(answer):
                        return answer == 0 ? (.interviewSetup, nil) : (.historySetup, nil)
                    default:
                        return (state, nil)
                    }
                case .interviewSetup, .interviewHint1:
                    switch event {
                    case let .options(answer):
                        return answer == 0 ? (.interviewQ1, nil) : (.interviewHint1, nil)
                    default:
                        return (state, nil)
                    }
                case .interviewQ1, .interviewHint2:
                    switch event {
                    case let .options(answer):
                        return answer == 0 ? (.interviewQ2, nil) : (.interviewHint2, nil)
                    default:
                        return (state, nil)
                    }
                case .interviewQ2, .interviewHint3:
                    switch event {
                    case let .options(answer):
                        return answer == 0 ? (.interviewQ3, nil) : (.interviewHint3, nil)
                    default:
                        return (state, nil)
                    }
                case .interviewQ3, .interviewHint4:
                    switch event {
                    case let .options(answer):
                        return answer == 0 ? (.interviewQ4, nil) : (.interviewHint4, nil)
                    default:
                        return (state, nil)
                    }
                case .interviewQ4, .interviewHint5:
                    switch event {
                    case let .statement(text):
                        return !text.isEmpty ? (.interviewQ5, nil) : (.interviewHint5, nil)
                    default:
                        return (state, nil)
                    }
                case .interviewQ5:
                    switch event {
                    case let .photo(image):
                        return (.interviewEnd, nil)
                    default:
                        return (state, nil)
                    }
                case .interviewEnd:
                    switch event {
                    case let .options(answer):
                        return answer == 0 ? (.interviewQ1, nil) : nil
                    default:
                        return (state, nil)
                    }
                case .historySetup, .historyHint1:
                    switch event {
                    case let .options(answer):
                        return answer == 0 ? (.historyQ1, nil) : (.historyHint1, nil)
                    default:
                        return (state, nil)
                    }
                case .historyQ1, .historyHint2:
                    switch event {
                    case let .options(answer):
                        return answer == 0 ? (.historyQ2, nil) : (.historyHint2, nil)
                    default:
                        return (state, nil)
                    }
                case .historyQ2, .historyHint3:
                    switch event {
                    case let .options(answer):
                        return answer == 0 ? (.historyQ3, nil) : (.historyHint3, nil)
                    default:
                        return (state, nil)
                    }
                case .historyQ3, .historyHint4:
                    switch event {
                    case let .options(answer):
                        return answer == 0 ? (.historyEnd, nil) : (.historyHint4, nil)
                    default:
                        return (state, nil)
                    }
                default:
                    return nil
                }
            }
        }
    }
}
