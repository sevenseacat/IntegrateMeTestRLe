module Admin.Request exposing (..)

import Admin.DataLoader exposing (responseDecoder)
import Admin.Types exposing (Response)
import Http exposing (request, expectJson)


competitionSaveRequest : String -> String -> Http.Body -> Http.Request Response
competitionSaveRequest token url content =
    request
        { method = "PUT"
        , headers = [ Http.header "X-XSRF-TOKEN" token ]
        , url = url
        , body = content
        , expect = expectJson responseDecoder
        , timeout = Nothing
        , withCredentials = False
        }
