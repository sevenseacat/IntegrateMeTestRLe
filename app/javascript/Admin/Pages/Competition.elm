module Admin.Pages.Competition exposing (..)

import Admin.Competition exposing (Competition)
import Admin.Messages exposing (Msg(..))
import Html exposing (Html, text)


view : Competition -> Html Msg
view competition =
    text competition.name
