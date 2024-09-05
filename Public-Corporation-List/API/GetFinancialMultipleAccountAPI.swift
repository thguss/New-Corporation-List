//
//  GetFinancialMultipleAccountAPI.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/15/24.
//

import Foundation

/**
 다중회사 주요계정 정보 조회
 OpenAPI : https://opendart.fss.or.kr/guide/detail.do?apiGrpCd=DS003&apiId=2019017
 */

class GetFinancialMultipleAccountAPI {
    static let shared = GetFinancialMultipleAccountAPI()

    private let URI = "https://opendart.fss.or.kr/api/fnlttMultiAcnt.json"
    private let API_KEY = "c0fa19277697e815963b4fd6c31bbb17d08f071c"    // crtfc_key
    private let REPORT_CODE = "11011"                                   // reprt_code
}

extension GetFinancialMultipleAccountAPI {
    
    func fetch(corpCodes: String, businessYear: String) async throws -> [FinancialMultipleAccountInfo] {
        /**
         URL 생성
         */
        guard let url = URL(string: "\(URI)?crtfc_key=\(API_KEY)&bsns_year=\(businessYear)&reprt_code=\(REPORT_CODE)&corp_code=\(corpCodes)") else {
            throw URLError(.badURL)
        }
        
        /**
         API 호출
         */
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        do {
            let decoder = JSONDecoder()
            let responseData = try decoder.decode(FinancialMultipleAccountsInfo.self, from: data)
            return responseData.result
        } catch {
            print(error)
            return []
        }
    }
}


