package com.scms

import org.springframework.http.HttpMethod

class FeatureManagement {

	String url
	String configAttribute
	HttpMethod httpMethod
	String featureName
	String groupName

	static mapping = {
		cache true
	}

	static constraints = {
		url blank: false, unique: 'httpMethod'
		configAttribute blank: false
		httpMethod nullable: true
		featureName nullable: true
		groupName nullable: true
	}
}
