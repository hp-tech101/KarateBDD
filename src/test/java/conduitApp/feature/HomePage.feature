@regression @smoke
Feature: Tests for the home page

    Background: Define URL
        Given url apiUrl
    
        
    Scenario: Get all tags 
        Given path 'tags'
        When method Get
        Then status 200
        And match response.tags contains ['welcome','et']
        And match response.tags contains any ['welcome','booba', 'octonaughts']
        # And match response.tags contains only ['welcome']
        And match response.tags !contains 'cars'
        And match response.tags == "#array"
        And match each response.tags == "#string"
        And match response.tags == "#notnull"
        And assert response.tags.length > 0
        And match response == { "tags": "#array"}
    
    Scenario: Get 10 articles from the page
        * def timeValidator = read('classpath:helpers/timeValidator.js')

        Given params { limit: 10, offset: 0 } 
        Given path 'articles'
        When method Get
        Then status 200
        # And match response.articles == "#array"
        # And match response.articlesCount == "#number"
        And match response == { "articles": "#array", "articlesCount" : "#number" }
        And match each response.articles == "#object"
        * def exp_articlesCount = 197
        And assert response.articlesCount >= exp_articlesCount
        And match response.articles == "#notnull"
        And assert response.articles.length > 0
        And match response.articles[*].favoritesCount != 0
        And match response.articles[*].author.bio contains null
        And match each response..following == false
        And match each response..author.bio == null 
        And match each response..bio == "##string"
        And match each response.articles ==
        """
            {
            "slug": "#string",
            "title": "#string",
            "description": "#string",
            "body": "#string",
            "tagList": "#array",
            "createdAt": "#? timeValidator(_)",
            "updatedAt": "#? timeValidator(_)",
            "favorited": "#boolean",
            "favoritesCount": "#number",
            "author": {
                "username": "#string",
                "bio": "##string",
                "image": "#string",
                "following": "#boolean"
            }
        }
        """