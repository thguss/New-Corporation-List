//
//  FoundationExtensions.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/22/24.
//

import Foundation
import SwiftUI

extension Int {
    func toTenThousandsWonString() -> String {
        // 천만원 단위로 변환
        let valueInTenThousands = self / 10000000

        // 금액 표시 (3자리마다 , 찍기)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: valueInTenThousands)) {
            return "\(formattedNumber)천만원"
        } else {
            return "\(valueInTenThousands)천만원"
        }
    }
    
    func toTenThousandsString() -> String {
        // 천만원 단위로 변환
        let valueInTenThousands = self / 10000000

        // 금액 표시 (3자리마다 , 찍기)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: valueInTenThousands)) {
            return "\(formattedNumber)천만"
        } else {
            return "\(valueInTenThousands)천만"
        }
    }

    func toWonString() -> String {
        let value = self / 1
        
        // 금액 표시 (3자리마다 , 찍기)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        numberFormatter.groupingSeparator = ","
        
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: value)) {
            return "\(formattedNumber)원"
        } else {
            return "\(value)원"
        }
    }
}

extension String {
    func toDateString() -> String? {
        // 입력 형식의 DateFormatter 생성
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMdd"
        
        // 입력 문자열을 Date 객체로 변환
        guard let date = inputFormatter.date(from: self) else {
            return nil
        }
        
        // 출력 형식의 DateFormatter 생성
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy.MM.dd"
        
        // Date 객체를 원하는 형식의 문자열로 변환
        let outputString = outputFormatter.string(from: date)
        return outputString
    }
    
    func extractYear() -> String {
        // 입력 날짜 형식 설정
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyyMMdd"
        
        // 출력 날짜 형식 설정
        let outputFormatter = DateFormatter()
        outputFormatter.dateFormat = "yyyy"
        
        // 입력 날짜 문자열을 Date 객체로 변환
        if let date = inputFormatter.date(from: self) {
            let calendar = Calendar.current
            let inputYear = calendar.component(.year, from: date)
            let currentYear = calendar.component(.year, from: Date())
            
            // 입력 날짜의 연도가 현재 연도와 같은 경우 작년 연도를 반환
            if inputYear == currentYear {
                let lastYear = currentYear - 1
                return String(lastYear)
            } else {
                // 입력 날짜의 연도가 현재 연도와 다른 경우 해당 연도를 반환
                return outputFormatter.string(from: date)
            }
        } else {
            // 변환에 실패한 경우 빈 문자열 반환
            return ""
        }
    }
}

extension Double {
    func toString() -> String {
        return String(format: "%.2f", self)
    }
    
    func toStringWithPercent() -> String {
        if self > 0.00 {
            return "+\(String(format: "%.2f", self))%"
        } else {
            return "\(String(format: "%.2f", self))%"
        }
    }
}

extension Double? {
    func color() -> Color {
        guard let value = self else { return .black }
        if value == 0 { return .black}
        return value > 0 ? .red : .blue
    }
}

extension Date {
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        return formatter.string(from: self)
    }
    
    func toStringWithPoint() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        return formatter.string(from: self)
    }
}
