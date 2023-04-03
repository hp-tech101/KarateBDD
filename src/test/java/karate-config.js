function fn() {
  
  var env = karate.env; // get system property 'karate.env'
  karate.log('karate.env system property was:', env);
  
  if (!env) {
    env = 'dev';
  }
  
  //use this to use as default 
  var config = {
    apiUrl: 'https://api.realworld.io/api/'
  }
  
  if (env == 'dev') {
    config.userEmail='karate_siddy@test.com'
    config.userPassw='karate1234'
  } else if (env == 'perf') {
    config.userEmail='karate_siddy@test.com'
    config.userPassw='karate1234'
  } else if (env == 'uat') {
    config.userEmail='karate_siddy@test.com'
    config.userPassw='karate1234'
  } 
  
  var accessToken = karate.callSingle('classpath:helpers/createToken.feature', config).authToken
  karate.configure('headers', {Authorization: 'Token '+accessToken})
  return config;
}