package com.scms

class SecRole {

	String name
	String authority
	long appsId

	static mapping = {
		datasource 'comn'
		cache true
	}

	static constraints = {
		authority blank: false, unique: true
		appsId blank: true
	}
}
