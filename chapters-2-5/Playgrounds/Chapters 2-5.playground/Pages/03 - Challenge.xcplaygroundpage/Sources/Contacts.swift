import Foundation


public enum PhoneBook {

    private static let contacts: [String: String] = [
        "(012)-345-6789" : "The Orderly",
        "(777)-777-7777" : "Mr. Lucky",
    ]
    
    
    public static func phoneNumberString(from digits: [Int]) -> String {
        guard digits.count == 10 else {
            preconditionFailure("Phone numbers must have 10 digits (XXX)-XXX-XXXX")
        }
        
        let areaCode = digits.dropLast(7)
        let firstHalf = digits.dropFirst(3).dropLast(4)
        let lastHalf = digits.dropFirst(6)
        
        return "(\(areaCode))-\(firstHalf)-\(lastHalf)"
    }
    
    
    public static func formattedPhoneNumber(from digitString: String) -> String {
        guard digitString.count == 10 else {
            preconditionFailure("Phone numbers must have 10 digits (XXX)-XXX-XXXX")
        }
        
        var formattedNumberString = digitString
        
        formattedNumberString.insert("(", at: formattedNumberString.startIndex)

        formattedNumberString.insert(")", at: formattedNumberString.index(
            formattedNumberString.startIndex,
            offsetBy: 4
        ))
        
        [5, 9].forEach { dashOffset in
            formattedNumberString.insert("-", at: formattedNumberString.index(
                formattedNumberString.startIndex,
                offsetBy: dashOffset
            ))
        }
        
        return formattedNumberString
    }
    
    
    public static func phoneNumber(for name: String) -> String? {
        contacts[name]
    }
    
    
    public static func dial(phoneNumber: String) -> String {
        guard let contact = contacts[phoneNumber] else {
            return "Contact not found for \(phoneNumber)"
        }
        
        return "📱 Dialing \(contact) at \(phoneNumber)..."
    }

    
    public static func name(for numberString: String) -> String? {
        nil
    }
}
