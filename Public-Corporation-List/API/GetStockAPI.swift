//
//  GetStocksAPI.swift
//  Public-Corporation-List
//
//  Created by sohyeon on 7/11/24.
//

/**
 [이름] 종목 기본 정보
 [설명] 종목 기본 정보 조회 (in 코스닥)
 [링크] http://openapi.krx.co.kr/contents/OPP/USES/service/OPPUSES002_S2.cmd?BO_ID=CifLHplnUFMgpHIMMPXs
 */

import Foundation

class GetStockAPI {
    static let shared = GetStockAPI()

    private let API_URI_KOSDAQ = "https://data-dbg.krx.co.kr/svc/apis/sto/ksq_isu_base_info"
    private let API_KEY = "55C2DFB405FC4A30A19BD3A6B171F695AF5C108D"
}

extension GetStockAPI {

    func fetch(baseDate: String) async throws -> [StockInfo] {
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
                .decode(StocksInfo.self, from: data)
                .result
        } catch {
            print(error)
            return []
        }
    }
}
