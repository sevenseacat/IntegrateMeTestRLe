module Admin.Pages.Competition exposing (view)

import Admin.Messages exposing (Msg(..))
import Admin.Routing exposing (linkTo, competitionsPath)
import Admin.Types exposing (Competition, MailingList, Errors)
import Dict exposing (Dict)
import Html exposing (Html, form, div, text, label, input, button, select, option, article, ul, li)
import Html.Attributes exposing (type_, value, class, for, name, checked, selected)
import Html.Events exposing (onInput, onCheck, onSubmit, onClick)


labelField : String -> String -> Html msg
labelField forValue textValue =
    div [ class "field-label is-normal" ]
        [ label [ for forValue, class "label" ]
            [ text textValue ]
        ]


textField : String -> String -> (String -> Msg) -> Html Msg
textField nameValue textValue msg =
    div [ class "field-body" ]
        [ div [ class "control" ]
            [ input
                [ type_ "text", name nameValue, class "input", value textValue, onInput msg ]
                []
            ]
        ]


checkboxField : String -> Bool -> String -> (Bool -> Msg) -> Html Msg
checkboxField nameValue checkedValue labelValue msg =
    div [ class "field-body" ]
        [ div [ class "field" ]
            [ div [ class "control" ]
                [ label [ class "checkbox" ]
                    [ input
                        [ type_ "checkbox", name nameValue, checked checkedValue, onCheck msg ]
                        []
                    , text labelValue
                    ]
                ]
            ]
        ]


selectField : String -> Maybe String -> List MailingList -> (String -> Msg) -> Html Msg
selectField nameValue selectedValue data msg =
    div [ class "field-body" ]
        [ div [ class "field is-narrow" ]
            [ div [ class "control" ]
                [ div [ class "select is-fullwidth" ]
                    [ select [ name nameValue, onInput msg ]
                        (List.map (optionField selectedValue) ((MailingList "" "") :: data))
                    ]
                ]
            ]
        ]


optionField : Maybe String -> MailingList -> Html msg
optionField selectedValue record =
    let
        isSelected =
            case selectedValue of
                Just val ->
                    val == record.id

                Nothing ->
                    False
    in
        option [ value record.id, selected isSelected ] [ text record.name ]


showErrors : Errors -> Html Msg
showErrors errors =
    case Dict.isEmpty errors of
        False ->
            article [ class "message is-danger" ]
                [ div [ class "message-body" ]
                    [ ul [] (Dict.foldr formatErrors [] errors) ]
                ]

        True ->
            text ""


formatErrors : String -> List String -> List (Html Msg) -> List (Html Msg)
formatErrors key vals acc =
    List.map (formatError key) vals ++ acc


formatError : String -> String -> Html msg
formatError key val =
    li []
        [ text (key ++ " " ++ val) ]


view : Competition -> Errors -> List MailingList -> Html Msg
view competition errors mailingLists =
    form [ onSubmit SaveCompetition ]
        [ showErrors errors
        , div [ class "field is-horizontal" ]
            [ labelField "name" "Name"
            , textField "name" competition.name UpdateName
            ]
        , div [ class "field is-horizontal" ]
            [ labelField "mailing_list_id" "Mailing List"
            , selectField "mailing_list_id" competition.mailingListId mailingLists UpdateMailingListId
            ]
        , div [ class "field is-horizontal" ]
            [ div [ class "field-label" ] []
            , checkboxField "requires_entry_name" competition.requiresEntryName "This competition requires an entry name" UpdateRequireEntryName
            ]
        , div [ class "field is-horizontal is-grouped" ]
            [ div [ class "field-label" ] []
            , div [ class "field-body" ]
                [ div [ class "control" ]
                    [ button [ class "button is-primary" ] [ text "Save" ]
                    , button ([ class "button is-text" ] ++ (linkTo competitionsPath)) [ text "Back" ]
                    ]
                ]
            ]
        ]
