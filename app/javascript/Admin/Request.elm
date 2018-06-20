module Admin.Request exposing (..)

import Admin.DataLoader exposing (decodeCompetitionResponse)
import Http exposing (request, expectJson)


competitionSaveRequest : String -> String -> Http.Body -> Http.Request String
competitionSaveRequest token url content =
    request
        { method = "PUT"
        , headers = [ Http.header "X-XSRF-TOKEN" token ]
        , url = url
        , body = content
        , expect = expectJson decodeCompetitionResponse
        , timeout = Nothing
        , withCredentials = False
        }
