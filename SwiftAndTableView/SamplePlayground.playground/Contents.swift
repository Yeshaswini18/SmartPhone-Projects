import UIKit

func testfunc(_ str: String, _ intVal: Int?) -> Int{
    print("String value = \(str)")
    
    guard let intVal = intVal else {
        print("Integer value was a nil")
        return 0}
    
    print("Integer value = \(intVal)")
    
    return intVal * 5
}

print(testfunc("yeshu", 3))// when you pass valid integer it returns "integer * 5"
print(testfunc("yeshu", nil))// when you pass nil it return 0
