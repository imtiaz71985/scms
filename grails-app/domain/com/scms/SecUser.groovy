package com.scms

class SecUser {

	transient springSecurityService

	long serviceId
	String username
	String password
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	String employeeId
	String employeeName
	String passwordResetLink    // encoded link id based on loginId + current time
	Date passwordResetValidity  // valid date time to reset password (valid till 24 hrs after sending request)
	String passwordResetCode    // security code to reset password (sent by mail)
	String hospitalCode

	static transients = ['springSecurityService']

	static constraints = {
		username blank: false, unique: true
		password blank: false
		serviceId blank: true
		employeeId(nullable: true)
		passwordResetLink(nullable: true)
		passwordResetValidity(nullable: true)
		passwordResetCode(nullable: true)
	}

	static mapping = {
		datasource 'comn'
		password column: '`password`'
		hospitalCode defaultValue: '00'
	}

	Set<SecRole> getAuthorities() {
		SecUserSecRole.findAllBySecUserAndAppsId(this, 3).collect { it.secRole }
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}
}
