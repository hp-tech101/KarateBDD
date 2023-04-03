Feature: Create Token

Scenario: create token
    Given url apiUrl
    Given path 'users/login'
    And request { "user" : {"email": "#(userEmail)", "password": "#(userPassw)"}}
    * print '(debugToday) userEmail = ' + userEmail
    * print '(debugToday) userPass  = ' + userPassw
    When method post
    Then status 200   
    * def authToken = response.user.token
    * print 'authToken from createToken feature => ' + authToken