//
//  GetKosdaqByDayTradingAPI.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/18/24.
//

import Foundation

/**
 [이름] 코스닥 일별 매매 정보 API
 [설명] 코스닥 시장에 상장되어 있는 주권의 매매정보를 제공한다.
 [링크] http://openapi.krx.co.kr/contents/OPP/USES/service/OPPUSES002_S2.cmd?BO_ID=hZjGpkllgCBCWqeTsYFj
 */

class GetDailyTradingAPI {
    static let shared = GetDailyTradingAPI()

    private let API_KEY = "55C2DFB405FC4A30A19BD3A6B171F695AF5C108D"
    private let API_URI_KOSDAQ = "https://data-dbg.krx.co.kr/svc/apis/sto/ksq_bydd_trd"
}

extension GetDailyTradingAPI {
    func fetch(baseDate: String) async throws -> [DailyTradingInfo] {
        guard let url = URL(string: "\(API_URI_KOSDAQ)?basDd=\(baseDate)") else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.setValue(API_KEY, forHTTPHeaderField: "AUTH_KEY")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw URLError(.badServerResponse)
        }

        do {
            return try JSONDecoder()
                .decode(DailyTradingsInfo.self, from: data)
                .result
        } catch {
            print(error)
            return []
        }
    }
}
