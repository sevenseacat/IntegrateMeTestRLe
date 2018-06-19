module Admin.CompetitionLoader exposing (..)

import Admin.Competition exposing (Competition)
import Json.Decode exposing (Decoder, decodeString, bool, int, list, string, nullable)
import Json.Decode.Pipeline exposing (decode, hardcoded, required)
import Json.Decode.Extra exposing (date)


loadCompetitions : String -> Result String (List Competition)
loadCompetitions cs =
    decodeString (list competitionDecoder) cs


competitionDecoder : Decoder Competition
competitionDecoder =
    decode Competition
        |> required "id" int
        |> required "name" string
        |> required "requires_entry_name" bool
        |> required "mailing_list_id" (nullable string)
        |> required "entries_count" int
        |> required "created_at" date
