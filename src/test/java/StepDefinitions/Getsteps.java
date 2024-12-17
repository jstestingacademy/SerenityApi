package StepDefinitions;

import io.cucumber.java.en.Given;
import net.serenitybdd.rest.SerenityRest;

public class Getsteps {

	private String baseuri="https://www.c2ta.co.in";
	@Given("enter the BASEURI and resource")
	public void enter_the_baseuri_and_resource() {
		SerenityRest.given()
		.baseUri(baseuri)
		.when()
		.get("/api/read.php")
		.then().log().all();
	    
	}

	@Given("Validate the response")
	public void validate_the_response() {
	    SerenityRest.lastResponse()
	    .then().extract().response();
	}
}
