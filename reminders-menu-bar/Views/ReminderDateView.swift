//
//  ReminderDateView.swift
//  Reminders Menu Bar
//
//  Created by Andy Lin on 12/24/21.
//  Copyright © 2021 Rafael Damasceno. All rights reserved.
//

import SwiftUI

struct ReminderDateView: View {
    @Binding var remindOnDate: Bool
    @Binding var remindAtTime: Bool
    @Binding var date: Date
    
    var body: some View {
        HStack{
            Text(rmbLocalized(.remindOn))
            VStack{
                HStack(spacing:0){
                    Toggle(rmbLocalized(.remindOnDay), isOn: $remindOnDate)
                    DatePicker("", selection: $date, displayedComponents: [.date])
                }
                if (remindOnDate){
                    HStack(spacing:0){
                        Toggle(rmbLocalized(.remindAtTime), isOn: $remindAtTime)
                        DatePicker("", selection: $date, displayedComponents: [.hourAndMinute])
                    }
                }
            }
        }
    }
}

struct ReminderDateView_Previews: PreviewProvider {
    static var previews: some View {
        ReminderDateView(remindOnDate: .constant(true), remindAtTime: .constant(true), date: .constant(Date()))
    }
}
