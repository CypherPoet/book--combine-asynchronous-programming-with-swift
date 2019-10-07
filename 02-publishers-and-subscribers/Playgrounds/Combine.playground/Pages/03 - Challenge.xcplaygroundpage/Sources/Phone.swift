import Foundation

public enum Phone {
    
    private static let keypad = [
        "abc": 1,
        "def": 2,
        "ghi": 3,
        "jkl": 4,
        "mno": 5,
        "pqr": 6,
        "stu": 7,
        "vqr": 8,
        "wxyz": 9
    ]
    
    
    public static func numberFromInput(_ input: Character) -> Int? {
        if let number = Int(String(input)), number < 10 {
            return number
        }
        
        for letters in Self.keypad.keys {
            if letters.contains(input) {
                return Self.keypad[letters]
            }
        }
        
        return nil
    }
}
