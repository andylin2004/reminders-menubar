import SwiftUI
import EventKit

struct FormNewReminderView: View {
    @EnvironmentObject var remindersData: RemindersData
    
    @State var newReminderTitle = ""
    var reload: () -> Void
    
    var body: some View {
        Form {
            HStack {
                TextField("Type a reminder and hit enter", text: $newReminderTitle, onCommit: {
                    guard !newReminderTitle.isEmpty else { return }
                    
                    RemindersService.instance.createNew(with: newReminderTitle, in: remindersData.calendarForSaving)
                    newReminderTitle = ""
                    reload()
                })
                    .padding(5)
                    .padding(.horizontal, 10)
                    .padding(.leading, 15)
                    .background(Color("textFieldBackground"))
                    .cornerRadius(8)
                    .textFieldStyle(PlainTextFieldStyle())
                    .overlay(
                        Image(systemName: "plus.circle.fill")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.gray)
                            .padding(.leading, 5)
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color("textFieldStrock"), lineWidth: 0.8)
                    )
                
                Menu {
                    ForEach(remindersData.calendars, id: \.calendarIdentifier) { calendar in
                        Button(action: { remindersData.calendarForSaving = calendar }) {
                            let isSelected =
                                remindersData.calendarForSaving.calendarIdentifier == calendar.calendarIdentifier
                            if isSelected {
                                Image(systemName: "checkmark")
                            }
                            let paddingText = isSelected ? "" : "      "
                            Text(paddingText + calendar.title)
                                .foregroundColor(Color(calendar.color))
                        }
                    }
                } label: {
                }
                .menuStyle(BorderlessButtonMenuStyle())
                .frame(width: 11, height: 10)
                .padding(8)
                .background(Color(remindersData.calendarForSaving.color))
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color("textFieldStrock"), lineWidth: 0.8)
                )
                .help("Select where new reminders will be saved")
            }
        }
        .padding(10)
        .background(Color("backgroundTheme"))
    }
}

struct FormNewReminderView_Previews: PreviewProvider {
    static func reload() { return }

    static var previews: some View {
        Group {
            ForEach(ColorScheme.allCases, id: \.self) { color in
                FormNewReminderView(reload: reload)
                    .environmentObject(RemindersData())
                    .colorScheme(color)
                    .previewDisplayName("\(color) mode")
            }
        }
    }
}
