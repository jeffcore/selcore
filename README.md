# Selcore

(work in progress)

This was going to be the ebay killer selling app for iOS. After a few months of development a ton of these apps hit the App Store. So I decided to focus on other projects.

## Tech
1. DB - MongoDB 4.0
2. API - Express 4.15 / NodeJS 12.14.1
3. iOS - Swift 3

## How to run
This app runs on docker containers.

Configure app:
- copy config file /selcore-api/config.js.example to new file config.js 
- copy config file /selcore-web/src/js/selcore.config.js.example to new file selcore.config.js
- run: docker-compose up mongo
- create a mongodb database called selcore or whatever you want
- run: docker-compuse up api

## To Do
1. Upgrade iOS app to Swift 5