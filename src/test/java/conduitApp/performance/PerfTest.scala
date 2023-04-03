package performance

import com.intuit.karate.gatling.PreDef._
import io.gatling.core.Predef._
import scala.concurrent.duration._

import conduitApp.performance.createTokens.CreateTokens

class PerfTest extends Simulation {

    CreateTokens.createAccessTokens()

  val protocol = karateProtocol(
    "/api/articles/{slug}" -> Nil
  )

  protocol.nameResolver = (req, ctx) => req.getHeader("karate-name")
  protocol.runner.karateEnv("perf")

 
//without feeder
//val createArticle = scenario("create and delete article").exec(karateFeature("classpath:conduitApp/performance/createArticle.feature"))

//with feeder (data driven)
val csvFeeder = csv("articles.csv").circular
val tokenFeeder = Iterator.continually(Map("token" -> CreateTokens.getNextToken))
val createArticle = scenario("create and delete article")
        .feed(csvFeeder)
        .feed(tokenFeeder)
        .exec(karateFeature("classpath:conduitApp/performance/createArticle.feature"))                                                                       
  

  setUp(
    createArticle.inject(
        atOnceUsers(1),
        nothingFor(4), 
        constantUsersPerSec(1).during(5),
        constantUsersPerSec(2).during(10),
        rampUsers(2).during(20),
        nothingFor(5),
        constantUsersPerSec(1).during(5)
    ).protocols(protocol)
    
  )

}