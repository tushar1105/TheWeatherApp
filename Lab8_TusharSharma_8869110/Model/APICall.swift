//
//  APICall.swift
//  Lab8_TusharSharma_8869110
//
//  Created by Tushar Sharma on 2024-08-04.
// Structure containing the required components of the API call as properties with the initial values, the request string is sent over as and when required during object creation.

import Foundation

struct APICall {
    
    var protocolInUse : String = "https"
    var apiURL : String = "api.openweathermap.org"
    var apiMethod : String = "data"
    var apiVersion : String = "2.5"
    var apiQuery : String = "weather"
    var apiRequestString : String;
    var apiKey : String = "3c86cdb94245fa2ca3d0c97d28abc112"
    
    init(apiRequestString: String) {
        self.protocolInUse = "https"
        self.apiURL = "api.openweathermap.org"
        self.apiMethod = "data"
        self.apiVersion = "2.5"
        self.apiQuery = "weather"
        self.apiRequestString = apiRequestString
        self.apiKey = "3c86cdb94245fa2ca3d0c97d28abc112"
    }
    
    // function to return the final API endpoint.
    func completeAPIEndpoint() -> String {
        let finalApiEndpointString = "\(protocolInUse)://\(apiURL)/\(apiMethod)/\(apiVersion)/\(apiQuery)?\(apiRequestString)&appid=\(apiKey)"
        return finalApiEndpointString;
    }

}
