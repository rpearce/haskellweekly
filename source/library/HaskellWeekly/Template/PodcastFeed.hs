{-# LANGUAGE OverloadedStrings #-}

module HaskellWeekly.Template.PodcastFeed
  ( podcastFeedTemplate
  )
where

import qualified Data.Text
import qualified HaskellWeekly.Type.Episode
import qualified HaskellWeekly.Type.Route
import qualified HaskellWeekly.Type.Title
import qualified Text.Feed.Constructor
import qualified Text.Feed.Types
import qualified Text.RSS.Syntax

podcastFeedTemplate
  :: String -> [HaskellWeekly.Type.Episode.Episode] -> Text.Feed.Types.Feed
podcastFeedTemplate baseUrl episodes =
  Text.Feed.Constructor.withFeedDescription feedDescription
    . Text.Feed.Constructor.withFeedHome (feedHome baseUrl)
    . Text.Feed.Constructor.withFeedItems (fmap episodeToItem episodes)
    . Text.Feed.Constructor.withFeedTitle "Haskell Weekly"
    $ Text.Feed.Constructor.newFeed feedKind

feedDescription :: Data.Text.Text
feedDescription = Data.Text.unwords
  [ "Haskell Weekly covers the Haskell progamming language. Listen to"
  , "professional software developers discuss using functional programming to"
  , "solve real-world business problems. Each episode uses a conversational"
  , "two-host format and runs for about 15 minutes."
  ]

feedHome :: String -> Text.RSS.Syntax.URLString
feedHome baseUrl =
  Data.Text.pack
    $ baseUrl
    <> HaskellWeekly.Type.Route.routeToString
         HaskellWeekly.Type.Route.RoutePodcast

feedKind :: Text.Feed.Types.FeedKind
feedKind = Text.Feed.Constructor.RSSKind Nothing

episodeToItem :: HaskellWeekly.Type.Episode.Episode -> Text.Feed.Types.Item
episodeToItem episode =
  Text.Feed.Constructor.withItemTitle
      (HaskellWeekly.Type.Title.titleToText
      $ HaskellWeekly.Type.Episode.episodeTitle episode
      )
    $ Text.Feed.Constructor.newItem feedKind
