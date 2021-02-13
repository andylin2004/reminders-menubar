import SwiftUI
import EventKit

struct FormNewReminderView: View {
    @EnvironmentObject var remindersData: RemindersData
    
    @State var newReminderTitle = ""
    
    var body: some View {
        Form {
            HStack {
                TextField("Type a reminder and hit enter", text: $newReminderTitle, onCommit: {
                    guard !newReminderTitle.isEmpty else { return }
                    
                    RemindersService.instance.createNew(with: newReminderTitle, in: remindersData.calendarForSaving)
                    newReminderTitle = ""
                })
                    .padding(.vertical, 8)
                    .padding(.horizontal, 8)
                    .padding(.leading, 22)
                    .background(Color("textFieldBackground"))
                    .cornerRadius(8)
                    .textFieldStyle(PlainTextFieldStyle())
                    .overlay(
                        Image(systemName: "plus.circle.fill")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .padding(.leading, 8)
                    )
                
                Menu {
                    ForEach(remindersData.calendars, id: \.calendarIdentifier) { calendar in
                        Button(action: { remindersData.calendarForSaving = calendar }) {
                            let isSelected =
                                remindersData.calendarForSaving.calendarIdentifier == calendar.calendarIdentifier
                            SelectableView(title: calendar.title, isSelected: isSelected, color: Color(calendar.color))
                        }
                    }
                } label: {
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .frame(width: 14, height: 16)
                .padding(8)
                .padding(.trailing, 2)
                .background(Color(remindersData.calendarForSaving.color))
                .cornerRadius(8)
                .help("Select where new reminders will be saved")
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
