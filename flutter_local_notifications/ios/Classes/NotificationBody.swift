
struct NotificationBody {
    var key: String?
    var id: Int?
    var snoozeId: String?
    var label: String?
    var channel: String?;
    var timeToTrigger: Int?
    var alarmValue: AlarmBody?
    var note: String?
    var isScheduled = false;
    var isPause = false;
    var repeatType = 0; // 0 - non repeating 1- daily 2-weekly 3- monthly  4- yearly
    
    func toDictionary() -> [String: Any?] {
        var data: [String: Any?] = [:]
        data["key"] = key
        data["id"] = id
        data["snoozeId"] = snoozeId
        data["timeToTrigger"] = timeToTrigger
        data["alarmValue"] = alarmValue?.toDictionary()
        data["note"] = note
        data["isScheduled"] = isScheduled
        data["isPause"] = isPause
        data["repeatType"] = repeatType
        
        return data
    }
    
    init(withDictionary data: [String: Any?]) {
        if let key = data["key"] as? String {
            self.key = key
        }
        if let id = data["id"] as? Int {
            self.id = id
        }
        if let snoozeId = data["snoozeId"] as? String {
            self.snoozeId = snoozeId
        }
        if let timeToTrigger = data["timeToTrigger"] as? Int {
            self.timeToTrigger = timeToTrigger
        }
        if let note = data["note"] as? String {
            self.note = note
        }
        if let alarmValue = data["alarmValue"] as? [String: Any?] {
            self.alarmValue = AlarmBody(withDictionary: alarmValue)
        }
        if let isScheduled = data["isScheduled"] as? Bool {
            self.isScheduled = isScheduled
        }
        if let isPause = data["isPause"] as? Bool {
            self.isPause = isPause
        }
        if let repeatType = data["repeatType"] as? Int {
            self.repeatType = repeatType
        }
    }
}

struct AlarmBody {
    var id: String?
    var snoozeId: String?
    var label: String?
    var timeToTrigger: Int?
    var ampm: Int?
    var isActive: Bool?
    var snooze: Int?
    var maxSnooze: Int?
    var isRepeating: Bool?
    var isReminder: Bool?
    var `repeat`: [Int]?
    var note: String?
    var repeatType: Int? // 1 - Daily  2- Weekly  3 - Monthly 4 - Yearly
    var every: Int?
    var on: [Int]?
    var until: Int? //  0 - forever
    var reminderDate: Int?
    var particularDates: [Int]?
    var ringtone: String?
    var isHighlighted: Bool?
    var withAnimation: Bool?
    
    init(withDictionary data: [String: Any?]) {
        if let id = data["id"] as? String {
            self.id = id
        }
        
        if let snoozeId = data["snoozeId"] as? String {
            self.snoozeId = snoozeId
        }
        
        if let label = data["label"] as? String {
            self.label = label
        }
        
        if let timeToTrigger = data["timeToTrigger"] as? Int {
            self.timeToTrigger = timeToTrigger
        }
        
        if let ampm = data["ampm"] as? Int {
            self.ampm = ampm
        }
        
        if let isActive = data["isActive"] as? Bool {
            self.isActive = isActive
        }
        
        if let snooze = data["snooze"] as? Int {
            self.snooze = snooze
        }
        
        if let maxSnooze = data["maxSnooze"] as? Int {
            self.maxSnooze = maxSnooze
        }
        
        if let isRepeating = data["isRepeating"] as? Bool {
            self.isRepeating = isRepeating
        }
        
        if let isReminder = data["isReminder"] as? Bool {
            self.isReminder = isReminder
        }
        
        if let `repeat` = data["repeat"] as? [Int] {
            self.repeat = `repeat`
        }
        
        if let note = data["note"]as? String {
            self.note = note
        }
        
        if let repeatType = data["repeatType"] as? Int {
            self.repeatType = repeatType
        }
        
        if let every = data["every"] as? Int {
            self.every = every
        }
        
        if let until = data["until"] as? Int {
            self.until = until
        }
        
        if let reminderDate = data["reminderDate"] as? Int {
            self.reminderDate = reminderDate
        }
        
        if let repeatType = data["repeatType"] as? Int {
            self.repeatType = repeatType
        }
        
        if let particularDates = data["particularDates"] as? [Int] {
            self.particularDates = particularDates
        }
        
        if let particularDates = data["particularDates"] as? [Int] {
            self.particularDates = particularDates
        }
        
        if let ringtone = data["ringtone"] as? String {
            self.ringtone = ringtone
        }
        
        if let isHighlighted = data["isHighlighted"] as? Bool {
            self.isHighlighted = isHighlighted
        }
        
        if let withAnimation = data["withAnimation"] as? Bool {
            self.withAnimation = withAnimation
        }
    }
    
    func toDictionary() -> [String: Any?] {
        var data: [String: Any?] = [:]
        data["id"] = id
        data["snoozeId"] = snoozeId
        data["label"] = label
        data["timeToTrigger"] = timeToTrigger
        data["ampm"] = ampm
        data["isActive"] = isActive
        data["snooze"] = snooze
        data["maxSnooze"] = maxSnooze
        data["isRepeating"] = isRepeating
        data["isReminder"] = isReminder
        data["repeat"] = `repeat`
        data["note"] = note
        data["repeatType"] = repeatType
        data["every"] = every
        data["until"] = until
        data["reminderDate"] = reminderDate
        data["particularDates"] = particularDates
        data["ringtone"] = ringtone
        data["isHighlighted"] = isHighlighted
        data["withAnimation"] = withAnimation
        
        return data
    }
}
