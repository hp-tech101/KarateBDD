@performance
Feature: Articles
    
    Background: Define URL
    Given url apiUrl
    
    * def titleFromCSV = __gatling.Title
    * def descFromCSV = __gatling.Description

    * def sleep = function(ms) { java.lang.Thread.sleep(ms)}
    * def pause = karate.get('__gatling.pause', sleep)

    * def timestamp = 
            """
                function() {
                   
                   let timestamp = null;
                   let date = new Date;
                   timestamp=date.getDate()+''+date.getMonth()+date.getFullYear()+date.getHours()+date.getMinutes()+date.getSeconds();
                   karate.log("Timestamp => "+timestamp)
                   return timestamp;
                }
            """ 
            
    
        Scenario: user journey delete article
            * configure headers = {"Authorization": #('Token '+ __gatling.token)}
            Given path 'articles'
            * def requestPayload =
            """
                {
                   "article": {
                    "tagList": ["test", "karate"],
                    //"title": "tjhgf32234",
                    //"description": "test",
                    "body": "test"
                    }
                }
            """    
            * def curr_timestamp = timestamp()
            * requestPayload.article.title = titleFromCSV+curr_timestamp
            * requestPayload.article.description = descFromCSV
            * print 'requestPayload is (updated) => ' + requestPayload
            And request requestPayload
            And header karate-name = 'Create Articles (Gatling)'
            When method post
            Then status 200
            
            # * pause(5000)

            # * def slug = response.article.slug 
            # Given path 'articles/'+slug
            # When method delete
            # Then status 204



            