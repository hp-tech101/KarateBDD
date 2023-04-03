@regression
Feature: Articles
    
    Background: Define URL
    Given url apiUrl
    # * def tokenResponse = callonce read('classpath:helpers/CreateToken.feature')
    # * def token = tokenResponse.authToken;
    # * print 'authToken from within Article => ' + token

    * def randomString = 
            """
                function(length) {
                   const characters ='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
                   let result = ' ';
                   const charactersLength = characters.length;
                   for ( let i = 0; i < length; i++ ) {
                        result += characters.charAt(Math.floor(Math.random() * charactersLength));
                    }
                    return result;
                }
            """ 
            
    
        Scenario: create a new article
            # Given header Authorization = 'Token ' + token
            Given path 'articles'
            
            * def randomisedTitle = randomString(10)
            * print 'title is (updated) =>' + randomisedTitle
            * def requestPayload =
            """
                {
                   "article": {
                    "tagList": ["test", "karate"],
                    //"title": "tjhgf32234",
                    "description": "test",
                    "body": "test"
                    }
                }
            """    
            * requestPayload.article.title = randomisedTitle   
            * print 'requestPayload is (updated) => ' + requestPayload
            And request requestPayload
            When method post
            Then status 200
            And match response.article.title == randomisedTitle
            And match response.article.tagList contains ["test", "karate"]
            And match response.article == "#object"
            And match response.article.tagList == "#array"
            And match response.article.author == "#object"

        
        Scenario: user journey delete article
            
            # Given header Authorization = 'Token ' + token
            Given path 'articles'
            * def randomisedTitle = randomString(10)
            * print 'title is (updated delete) =>' + randomisedTitle
            * def requestPayload =
            """
                {
                   "article": {
                    "tagList": ["test", "karate"],
                    //"title": "tjhgf32234",
                    "description": "test",
                    "body": "test"
                    }
                }
            """    
            * requestPayload.article.title = randomisedTitle   
            * print 'requestPayload is (updated) => ' + requestPayload
            And request requestPayload
            When method post
            Then status 200
            And match response.article.title == randomisedTitle
            And match response.article.tagList contains ["test", "karate"]
            And match response.article == "#object"
            And match response.article.tagList == "#array"
            And match response.article.author == "#object"

            
            * def slug = response.article.slug 
            # Given header Authorization = 'Token ' + token
            Given path 'articles/'+slug
            When method delete
            Then status 204



            