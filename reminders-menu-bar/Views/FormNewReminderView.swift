import SwiftUI
import EventKit

struct FormNewReminderView: View {
    @EnvironmentObject var remindersData: RemindersData
    @ObservedObject var userPreferences = UserPreferences.instance
    
    @State var newReminderTitle = ""
    @State var remindOnDate = false
    @State var remindAtTime = false
    @State var date = Date()
    
    var body: some View {
        VStack {
            HStack {
                VStack{
                    TextField(rmbLocalized(.newReminderTextFielPlaceholder), text: $newReminderTitle, onCommit: {
                        guard !newReminderTitle.isEmpty else { return }
                        
                        RemindersService.instance.createNew(with: newReminderTitle, in: userPreferences.calendarForSaving, remindOn: date, includeDate: remindOnDate,includeTime: remindAtTime)
                        newReminderTitle = ""
                    })
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .padding(.leading, 22)
                    .background(
                        userPreferences.backgroundIsTransparent ?
                            Color("textFieldBackgroundTransparent") :
                            Color("textFieldBackground")
                    )
                    .cornerRadius(8)
                    .textFieldStyle(PlainTextFieldStyle())
                    .overlay(
                        Image(systemName: "plus.circle.fill")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                    )
                    
                    HStack{
                        Text("Remind on")
                        VStack{
                            HStack(spacing:0){
                                Toggle("Day:", isOn: $remindOnDate)
                                DatePicker("", selection: $date, displayedComponents: [.date])
                            }
                            if (remindOnDate){
                                HStack(spacing:0){
                                    Toggle("Time:", isOn: $remindAtTime)
                                    DatePicker("", selection: $date, displayedComponents: [.hourAndMinute])
                                }
                            }
                        }
                    }
                }
                
                Menu {
                    ForEach(remindersData.calendars, id: \.calendarIdentifier) { calendar in
                        Button(action: { userPreferences.calendarForSaving = calendar }) {
                            let isSelected =
                                userPreferences.calendarForSaving.calendarIdentifier == calendar.calendarIdentifier
                            SelectableView(title: calendar.title, isSelected: isSelected, color: Color(calendar.color))
                        }
                    }
                } label: {
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .frame(width: 14, height: 16)
                .padding(8)
                .padding(.trailing, 2)
                .background(Color(userPreferences.calendarForSaving.color))
                .cornerRadius(8)
                .help(rmbLocalized(.newReminderCalendarSelectionToSaveHelp))
            }
        }
        .padding(10)
    }
}

struct FormNewReminderView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.self) { color in
                FormNewReminderView()
                    .environmentObject(RemindersData())
                    .colorScheme(color)
                    .previewDisplayName("\(color) mode")
            }
        }
    }
}
