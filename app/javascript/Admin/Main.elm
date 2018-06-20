module Admin.Main exposing (main)

import Admin.DataLoader as DataLoader
import Admin.Messages exposing (..)
import Admin.Pages.Competitions
import Admin.Pages.Competition
import Admin.Pages.NotFound
import Admin.Request exposing (competitionSaveRequest)
import Admin.Routing as Routing exposing (Route(..), competitionsPath, competitionPath)
import Admin.Types exposing (Competition, MailingList, Errors)
import Dict exposing (Dict)
import Html exposing (Html)
import Http
import Navigation exposing (Location)


type alias Flags =
    { competitions : String
    , mailingLists : String
    , csrfToken : String
    }


type alias Model =
    { competitions : List Competition
    , mailingLists : List MailingList
    , route : Route
    , currentCompetition : Maybe Competition
    , errors : Errors
    , csrfToken : String
    , flash : Maybe String
    }


init : Flags -> Location -> ( Model, Cmd Msg )
init { competitions, mailingLists, csrfToken } location =
    let
        currentRoute =
            Routing.parseLocation location

        comps =
            case DataLoader.loadCompetitions competitions of
                Ok data ->
                    data

                Err _ ->
                    []

        currentCompetition =
            loadCurrentCompetition comps currentRoute

        lists =
            case DataLoader.loadMailingLists mailingLists of
                Ok data ->
                    data

                Err _ ->
                    []
    in
        ( { competitions = comps
          , mailingLists = lists
          , route = currentRoute
          , currentCompetition = currentCompetition
          , errors = Dict.empty
          , csrfToken = csrfToken
          , flash = Nothing
          }
        , Cmd.none
        )


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ChangeLocation path ->
            ( { model | flash = Nothing }, Navigation.newUrl path )

        OnLocationChange location ->
            let
                newRoute =
                    Routing.parseLocation location

                currentCompetition =
                    loadCurrentCompetition model.competitions newRoute
            in
                ( { model | route = newRoute, currentCompetition = currentCompetition, errors = Dict.empty }, Cmd.none )

        UpdateName name ->
            let
                newCompetition =
                    case model.currentCompetition of
                        Just competition ->
                            Just { competition | name = name }

                        Nothing ->
                            Nothing
            in
                ( { model | currentCompetition = newCompetition }, Cmd.none )

        UpdateMailingListId id ->
            let
                newCompetition =
                    case model.currentCompetition of
                        Just competition ->
                            Just { competition | mailingListId = Just id }

                        Nothing ->
                            Nothing
            in
                ( { model | currentCompetition = newCompetition }, Cmd.none )

        UpdateRequireEntryName val ->
            let
                newCompetition =
                    case model.currentCompetition of
                        Just competition ->
                            Just { competition | requiresEntryName = val }

                        Nothing ->
                            Nothing
            in
                ( { model | currentCompetition = newCompetition }, Cmd.none )

        SaveCompetition ->
            case model.currentCompetition of
                Just c ->
                    ( model, submitCompetitionData model.csrfToken c )

                Nothing ->
                    ( model, Cmd.none )

        CompetitionSaved (Err _) ->
            ( { model | errors = Dict.fromList [ ( "Record", [ "could not be saved" ] ) ] }, Cmd.none )

        CompetitionSaved (Ok response) ->
            case response.competition of
                Just comp ->
                    -- Save was successful
                    let
                        competitionList =
                            updateCompetitionList model.competitions comp
                    in
                        ( { model
                            | competitions = competitionList
                            , errors = Dict.empty
                            , flash = Just "Competition saved successfully"
                          }
                        , Navigation.newUrl competitionsPath
                        )

                Nothing ->
                    -- There were errors ohnoes
                    ( { model | errors = response.errors }, Cmd.none )


updateCompetitionList : List Competition -> Competition -> List Competition
updateCompetitionList list newCompetition =
    let
        updateSingle competition =
            if competition.id == newCompetition.id then
                newCompetition
            else
                competition
    in
        List.map updateSingle list


submitCompetitionData : String -> Competition -> Cmd Msg
submitCompetitionData token competition =
    let
        body =
            competition
                |> DataLoader.encodeCompetition
                |> Http.jsonBody
    in
        Http.send CompetitionSaved (competitionSaveRequest token (competitionPath competition.id) body)


loadCurrentCompetition : List Competition -> Route -> Maybe Competition
loadCurrentCompetition competitions route =
    case route of
        CompetitionRoute id ->
            findCompetition competitions id

        _ ->
            Nothing


findCompetition : List Competition -> Int -> Maybe Competition
findCompetition list id =
    List.head (List.filter (\c -> c.id == id) list)


view : Model -> Html Msg
view model =
    case model.route of
        CompetitionsRoute ->
            Admin.Pages.Competitions.view model.competitions model.flash

        CompetitionRoute id ->
            case model.currentCompetition of
                Just c ->
                    Admin.Pages.Competition.view c model.errors model.mailingLists

                Nothing ->
                    Admin.Pages.NotFound.view

        NotFoundRoute ->
            Admin.Pages.NotFound.view


main : Program Flags Model Msg
main =
    Navigation.programWithFlags OnLocationChange
        { init = init
        , view = view
        , update = update
        , subscriptions = \_ -> Sub.none
        }
