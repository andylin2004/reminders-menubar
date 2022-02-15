//
//  ReminderTitleTextField.swift
//  Reminders Menu Bar
//
//  Created by Andy Lin on 2/14/22.
//  Copyright © 2022 Rafael Damasceno. All rights reserved.
//

import SwiftUI

struct ReminderTitleTextField: NSViewRepresentable{
    let placeholderTitle: String
    @Binding var remindOnDate: Bool
    @Binding var remindAtTime: Bool
    @Binding var remindDate: Date
    @ObservedObject var userPreferences = UserPreferences.instance
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    func makeNSView(context: Context) -> NSTextField {
        let textField = NSTextField()
        textField.delegate = context.coordinator
        textField.placeholderString = placeholderTitle
        textField.isBordered = false
        textField.font = .systemFont(ofSize: NSFont.systemFontSize)
        
        textField.backgroundColor = NSColor.clear
        
        return textField
    }
    
    func updateNSView(_ nsView: NSTextField, context: Context) {}
    
    class Coordinator: NSObject, NSTextFieldDelegate{
        var parent: ReminderTitleTextField
        
        init(_ parent: ReminderTitleTextField){
            self.parent = parent
        }
        
        func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
            if (commandSelector == #selector(NSResponder.insertNewline(_:))) {
                guard !textView.string.isEmpty else {
                    return false
                }
                RemindersService.instance.createNew(with: textView.string, in: parent.userPreferences.calendarForSaving, remindOn: parent.remindDate, includeDate: parent.remindOnDate, includeTime: parent.remindAtTime)
                textView.string = ""
                return true
            }
            return false
        }
        
    }
}

struct ReminderTitleTextField_Previews: PreviewProvider {
    static var previews: some View {
        ReminderTitleTextField(placeholderTitle: rmbLocalized(.newReminderTextFielPlaceholder), remindOnDate: .constant(true), remindAtTime: .constant(true), remindDate: .constant(Date()))
    }
}
